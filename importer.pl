#! /usr/bin/perl

use 5.014;
use strict;

use Text::CSV;

our @EXPECTED_COLUMN_HEADERS = qw(order_date customer_id customer_first_name customer_last_name order_number item_name item_manufacturer item_price);

my $csv = Text::CSV->new( { binary => 1, allow_whitespace => 1 } )
	or die "Cannot use CSV: ".Text::CSV->error_diag ();

foreach my $filename (@ARGV) {
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
		say join '/', %$row_ref;
	}

	close $fh;

	$csv->eof or $csv->error_diag();
}