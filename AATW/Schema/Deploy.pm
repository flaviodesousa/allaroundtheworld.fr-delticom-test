package AATW::Schema::Deploy;

use 5.014;
use strict;
use warnings;

use DBIx::SQLite::Deploy;

{
	my $DB_SCHEMA = <<_DEPLOYMENT_SCRIPT_;
    ---
    PRAGMA foreign_keys = ON;
    ---
    CREATE TABLE customers (
        id                  INTEGER PRIMARY KEY AUTOINCREMENT,
        alternate_id        TEXT NOT NULL,
        first_name          TEXT NOT NULL,
        last_name           TEXT NOT NULL,
        UNIQUE (alternate_id, first_name, last_name)
    );
    ---
    CREATE TABLE orders (
        id                  INTEGER PRIMARY KEY AUTOINCREMENT,
        number              TEXT NOT NULL,
        date                DATE NOT NULL,
        time                TIME NOT NULL,
        customer_id         INTEGER NOT NULL,
        FOREIGN KEY(customer_id) REFERENCES customers(id) NOT DEFERRABLE,
        UNIQUE (number, date, time)
    );
    ---
    CREATE TABLE items (
        id                  INTEGER PRIMARY KEY AUTOINCREMENT,
        name                TEXT NOT NULL,
        manufacturer        TEXT NOT NULL,
        UNIQUE (name, manufacturer)
    );
	---
	CREATE TABLE item_prices (
        id                  INTEGER PRIMARY KEY AUTOINCREMENT,
        price               NUMERIC NOT NULL,
        order_id            INTEGER NOT NULL,
        item_id             INTEGER NOT NULL,
        FOREIGN KEY(order_id) REFERENCES orders(id) NOT DEFERRABLE,
        FOREIGN KEY(item_id) REFERENCES items(id) NOT DEFERRABLE,
        UNIQUE (order_id, item_id)
	);
	---
_DEPLOYMENT_SCRIPT_



	sub deploy_db {
		my $deployment = DBIx::SQLite::Deploy->deploy( '/tmp/aatw.sqlite3', $DB_SCHEMA );
		$deployment->deploy( { create => 1 } );

		return $deployment->connect;
	}
}