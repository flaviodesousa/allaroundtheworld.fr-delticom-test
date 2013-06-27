package AATW::Schema::Result::Source;

use 5.014;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('sources');
__PACKAGE__->add_columns(qw/ id full_path_name /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('unique_sources' => [qw(full_path_name)]);
__PACKAGE__->has_many('item_prices', 'AATW::Schema::Result::ItemPrice', 'source_id');

say __PACKAGE__;