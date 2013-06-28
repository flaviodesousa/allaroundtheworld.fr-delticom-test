#! /usr/bin/perl

use 5.014;
use strict;
use warnings;
use Carp;

use Cwd 'abs_path';
use Text::CSV;

use AATW::Schema::Deploy;
use AATW::Schema;

our ($schema, @EXPECTED_COLUMN_HEADERS);

@EXPECTED_COLUMN_HEADERS = qw(order_date customer_id customer_first_name customer_last_name order_number item_name item_manufacturer item_price);



sub input_file_already_imported {
	my ($fully_qualified_file_name) = @_;
	my $source_rs = $schema->resultset('Source');
	my $source_data = {full_path_name => $fully_qualified_file_name};
	if ($source_rs->find($source_data)) {
		warn "File \"$fully_qualified_file_name\" already imported. Ignoring.\n";
		return 1;
	}
	return;
}



sub do_import {
	my $csv = Text::CSV->new( { binary => 1, allow_whitespace => 1 } )
		or croak "Cannot use CSV: ".Text::CSV->error_diag ();

	for my $filename (@ARGV) {

		my $fully_qualified_file_name = abs_path($filename);

		next if input_file_already_imported($fully_qualified_file_name);

		open my $fh, "<:encoding(utf8)", $fully_qualified_file_name
			or croak "$fully_qualified_file_name: $!";
		
		# is the 1st line a valid header?
		my @col_names = map { s/ /_/g; $_ } @{ $csv->getline( $fh ) };
		if (join(',', @EXPECTED_COLUMN_HEADERS) ne join(',', @col_names)) {
			warn "$fully_qualified_file_name: malformed header, expected column headers not present.\n";
			next;
		}

		my $source = $schema->resultset('Source')->find_or_create(
			{full_path_name => $fully_qualified_file_name},
			{key => 'unique_sources'});

		my $row_ref = {};
		$csv->bind_columns( \@{$row_ref}{@col_names} );

		while ( $csv->getline( $fh ) ) {
			my $customer = $schema->resultset('Customer')->find_or_create(
				{
					alternate_id => $row_ref->{customer_id},
					first_name => $row_ref->{customer_first_name},
					last_name => $row_ref->{customer_last_name}
				},
				{
					key => 'unique_customers'
				});
			my ($date, $time) = split ' ', $row_ref->{order_date};
			my $order = $customer->orders->find_or_create(
				{					
					number => $row_ref->{order_number},
					date => $date,
					time => $time
				},
				{
					key => 'unique_orders'
				});
			my $item = $schema->resultset('Item')->find_or_create(
				{
					name => $row_ref->{item_name},
					manufacturer => $row_ref->{item_manufacturer}
				},
				{
					key => 'unique_items'
				});
			my $price = $row_ref->{item_price}; $price =~ s/[^\d.]//g;
			$item->item_prices->create({
				price => $price,
				order_id => $order->id,
				source_id => $source->id
				});
		}

		close $fh;

		$csv->eof or $csv->error_diag();
	}

	return;
}



$schema = AATW::Schema::Deploy->deploy_db();

do_import;
