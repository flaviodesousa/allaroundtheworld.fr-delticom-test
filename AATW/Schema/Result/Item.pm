package AATW::Schema::Result::Item;

use 5.014;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('items');
__PACKAGE__->add_columns(qw/ id name manufacturer /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('unique_items' => [qw(name manufacturer)]);
__PACKAGE__->has_many('item_prices', 'AATW::Schema::Result::ItemPrice', 'item_id');

say __PACKAGE__;