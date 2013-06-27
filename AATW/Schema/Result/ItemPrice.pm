package AATW::Schema::Result::ItemPrice;

use 5.014;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('orders');
__PACKAGE__->add_columns(qw/ id price source_id order_id item_id /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('sources', 'AATW::Schema::Result::Source', 'source_id');
__PACKAGE__->belongs_to('orders', 'AATW::Schema::Result::Order', 'order_id');
__PACKAGE__->belongs_to('items', 'AATW::Schema::Result::Item', 'item_id');

say __PACKAGE__;