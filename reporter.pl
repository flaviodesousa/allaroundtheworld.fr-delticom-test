#! /usr/bin/perl

use 5.014;
use strict;
use warnings;

use AATW::Schema::Deploy;
use AATW::Schema;
use AATW::Report::Text;

our ( $schema, $reporter );

sub order_details {
    my $order_id    = shift;
    my $order_items = $schema->resultset('ItemPrice')->search(
        {
            order_id => $order_id
        }
    );
    while ( my $item = $order_items->next ) {
        $reporter->item_price_line( $item->item->name, $item->price );
    }
}

sub customer_totals_by_order {
    my ( $day, $customer_id ) = @_;

    # totals by orders placed by a given customer on a given day
    my $by_orders = $schema->resultset('Order')->search(
        {
            date        => $day,
            customer_id => $customer_id
        },
        {
            join   => ['item_prices'],
            select => [ 'me.id', 'me.number', { sum => 'item_prices.price' } ],
            as     => [qw(order_id order_number total)],
            group_by => ['me.id'],
            order_by => ['me.number']
        }
    );
    while ( my $order = $by_orders->next ) {
        $reporter->order_header( $order->get_column('order_number'),
            $order->get_column('total') );
        order_details( $order->get_column('order_id') );
    }
}

sub day_totals_by_customer {
    my $day          = shift;

    # totals by customer for a given day
    my $by_customers = $schema->resultset('Order')->search(
        { date => $day },
        {
            join   => [ 'customer', 'item_prices' ],
            select => [
                'customer.id',         'customer.alternate_id',
                'customer.first_name', 'customer.last_name',
                { sum => 'item_prices.price' }
            ],
            as => [qw(customer_id alternate_id first_name last_name total)],
            group_by => ['customer.id'],
            order_by => [ 'customer.last_name', 'customer.first_name ' ]
        }
    );
    while ( my $customer = $by_customers->next ) {
        $reporter->customer_header(
            $customer->get_column('first_name'),
            $customer->get_column('last_name'),
            $customer->get_column('customer_id'),
            $customer->get_column('total')
        );
        customer_totals_by_order( $day, $customer->get_column('customer_id') );
    }
}

sub do_report {

    # totals by day
    my $days = $schema->resultset('Order')->search(
        {},
        {
            join   => ['item_prices'],
            select => [
                'date',
                { sum   => 'item_prices.price' },
                { count => 'distinct me.id' }
            ],
            as       => [ 'date', 'total', 'order_count' ],
            group_by => ['date'],
            order_by => ['date desc']
        }
    );

    while ( my $day = $days->next ) {
        $reporter->day_header(
            $day->date,
            $day->get_column('order_count'),
            $day->get_column('total')
        );

        day_totals_by_customer( $day->date );
    }
}

$schema   = AATW::Schema::Deploy->deploy_db();
$reporter = AATW::Report::Text->new();

do_report;
