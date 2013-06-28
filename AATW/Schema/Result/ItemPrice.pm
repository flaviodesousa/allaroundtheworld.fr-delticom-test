package AATW::Schema::Result::ItemPrice;

use 5.014;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('item_prices');
__PACKAGE__->add_columns(qw/ id price source_id order_id item_id /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('source', 'AATW::Schema::Result::Source', 'source_id');
__PACKAGE__->belongs_to('order', 'AATW::Schema::Result::Order', 'order_id');
__PACKAGE__->belongs_to('item', 'AATW::Schema::Result::Item', 'item_id');

1;