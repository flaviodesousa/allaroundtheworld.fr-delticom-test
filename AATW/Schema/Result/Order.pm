package AATW::Schema::Result::Order;

use 5.014;

use strict;
use warnings;
use base 'DBIx::Class::Core';
use subs 'find_or_create';

__PACKAGE__->table('orders');
__PACKAGE__->add_columns(qw/ id number date time customer_id /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('unique_orders' => [qw(number date time customer_id)]);
__PACKAGE__->belongs_to('customers', 'AATW::Schema::Result::Customer', 'customer_id');
__PACKAGE__->has_many('item_prices', 'AATW::Schema::Result::ItemPrice', 'order_id');

sub find_or_create {
	my ($class, $schema, $customer, $attributes) = @_;

	my $rs = $schema->resultset('Order');

	my $order = $customer->orders->find( $attributes );

	$order = $customer->orders->create( $attributes ) unless $order;

	return $order;
}

1;