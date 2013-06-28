package AATW::Schema::Result::Order;

use 5.014;
use strict;
use warnings;
use base 'DBIx::Class::Core';

our $VERSION = q(0.0.1);

__PACKAGE__->table('orders');
__PACKAGE__->add_columns(qw/ id number date time customer_id /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(
    'unique_orders' => [qw(number date time customer_id)] );
__PACKAGE__->belongs_to( 'customer', 'AATW::Schema::Result::Customer',
    'customer_id' );
__PACKAGE__->has_many( 'item_prices', 'AATW::Schema::Result::ItemPrice',
    'order_id' );

1;
