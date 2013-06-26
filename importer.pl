#! /usr/bin/perl

use 5.014;
use strict;

use Text::CSV;

our @EXPECTED_COLUMN_HEADERS = qw(order_date customer_id customer_first_name customer_last_name order_number item_name item_manufacturer item_price);



sub do_import {
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
}



sub deploy_dbmy $deployment = DBIx::SQLite::Deploy->deploy( '~/.orders.sqlite' => <<_DEPLOYMENT_SCRIPT_ )
    [% PRIMARY_KEY = "INTEGER PRIMARY KEY AUTOINCREMENT" %]
    [% CLEAR %]
    ---
    CREATE TABLE customer (
        id                  [% PRIMARY_KEY %],
        alternate_id        TEXT NOT NULL,
        first_name          TEXT NOT NULL,
        last_name           TEXT NOT NULL,
        UNIQUE (alternate_id, first_name, last_name)
    );
    ---
    CREATE TABLE order (
        id                  [% PRIMARY_KEY %],
        number              TEXT NOT NULL,
        date                DATE NOT NULL,
        time                TIME NOT NULL,
        customer_id         INTEGER REFERENCES customer(id),
        UNIQUE (number, date, time)
    );
    ---
    CREATE TABLE item (
        id                  [% PRIMARY_KEY %],
        name                TEXT NOT NULL,
        manufacturer        TEXT NOT NULL,
        UNIQUE (name, manufacturer)
    );
	---
	CREATE TABLE item_price (
        id                  [% PRIMARY_KEY %],
        price               NUMERIC NOT NULL,
        order_id            INTEGER REFERENCES order(id),
        item_id				INTEGER REFERENCES item(id),
        UNIQUE (order_id, item_id)
	);
_DEPLOYMENT_SCRIPT_
}



do_import();