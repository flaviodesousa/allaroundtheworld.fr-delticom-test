#! /usr/bin/perl

use 5.014;
use strict;
use warnings;

use Cwd 'abs_path';
use Text::CSV;

use AATW::Schema::Deploy;
use AATW::Schema;

our @EXPECTED_COLUMN_HEADERS = qw(order_date customer_id customer_first_name customer_last_name order_number item_name item_manufacturer item_price);



sub verify_if_source_file_not_yet_processed {
	my ($schema, $fullname) = @_;
	my $source_rs = $schema->resultset('Source');
	my $source_data = {full_path_name => $fullname};
	if ($source_rs->find($source_data)) {
		warn "File \"$fullname\" already imported. Ignoring.\n";
		return undef;
	}
	return $source_rs->create($source_data);
}


sub do_import {
	my $schema = shift;
	my $csv = Text::CSV->new( { binary => 1, allow_whitespace => 1 } )
		or die "Cannot use CSV: ".Text::CSV->error_diag ();

	foreach my $filename (@ARGV) {

		my $source = verify_if_source_file_not_yet_processed($schema, abs_path($filename));
		next unless $source;

		open my $fh, "<:encoding(utf8)", $filename
			or die "$filename: $!";
		
		# is the 1st line a valid header?
		my @col_names = map { s/ /_/g; $_ } @{ $csv->getline( $fh ) };	
		if (join(',', @EXPECTED_COLUMN_HEADERS) ne join(',', @col_names)) {
			die "$filename: malformed header, expected column headers not present.";
		}

		my $row_ref = {};
		$csv->bind_columns( \@{$row_ref}{@col_names} );

		while ( $csv->getline( $fh ) ) {
			my $customer = $schema->resultset('Customer')->find_or_create(
				{
				alternate_id => $row_ref->{customer_id},
				first_name => $row_ref->{customer_first_name},
				last_name => $row_ref->{customer_last_name}
				});
			my ($date, $time) = split ' ', $row_ref->{order_date};
			my $order = $customer->orders->find_or_create(
				{					
				number => $row_ref->{order_number},
				date => $date,
				time => $time
				});
			my $item = $schema->resultset('Item')->find_or_create(
				{
				name => $row_ref->{item_name},
				manufacturer => $row_ref->{item_manufacturer}
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
}



my $schema = AATW::Schema::Deploy->deploy_db();
do_import($schema);
