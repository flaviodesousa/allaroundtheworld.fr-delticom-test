#! /usr/bin/perl

use 5.014;
use strict;

use Text::CSV;

my $csv = Text::CSV->new({ binary => 1, allow_whitespace => 1, })
	or die "Cannot use CSV: ".Text::CSV->error_diag ();

foreach my $filename (@ARGV) {
	open my $fh, "<:encoding(utf8)", $filename or die "$filename: $!";
	while ( my $row = $csv->getline( $fh ) ) {
		say join '/', @$row;
	}
}