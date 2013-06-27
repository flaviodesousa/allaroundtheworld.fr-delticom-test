package AATW::Schema::Result::Item;

use 5.014;
use strict;
use warnings;
use base 'DBIx::Class::Core';
use subs 'find_or_create';

__PACKAGE__->table('items');
__PACKAGE__->add_columns(qw/ id name manufacturer /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('unique_items' => [qw(name manufacturer)]);
__PACKAGE__->has_many('item_prices', 'AATW::Schema::Result::ItemPrice', 'item_id');

sub find_or_create {
	my ($class, $schema, $attributes) = @_;

	my $rs = $schema->resultset('Item');

	my $item = $rs->find( $attributes );

	$item = $rs->create( $attributes ) unless $item;

	return $item;
}

1;