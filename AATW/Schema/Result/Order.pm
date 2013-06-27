package AATW::Schema::Result::Order;

use 5.014;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('orders');
__PACKAGE__->add_columns(qw/ id number date time customer_id /);
__PACKAGE__->set_primary_key('id');

say __PACKAGE__;