package AATW::Schema::Result::Source;

use 5.012;
use strict;
use warnings;
use base 'DBIx::Class::Core';

our $VERSION = q(0.0.1);

__PACKAGE__->table('sources');
__PACKAGE__->add_columns(qw/ id full_path_name /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('unique_sources' => [qw(full_path_name)]);
__PACKAGE__->has_many('item_prices', 'AATW::Schema::Result::ItemPrice', 'source_id');

1;