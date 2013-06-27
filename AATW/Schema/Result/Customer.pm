package AATW::Schema::Result::Customer;

use 5.014;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('customers');
__PACKAGE__->add_columns(qw/ id alternate_id first_name last_name /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('unique_customers' => [qw(alternate_id first_name last_name)]);
#__PACKAGE__->has_many('orders');
say __PACKAGE__;