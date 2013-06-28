package AATW::Schema::Result::Customer;

use 5.014;
use strict;
use warnings;
use base 'DBIx::Class::Core';

our $VERSION = q(0.0.1);

use AATW::Schema;

__PACKAGE__->table('customers');
__PACKAGE__->add_columns(qw/ id alternate_id first_name last_name /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('unique_customers' => [qw(alternate_id first_name last_name)]);
__PACKAGE__->has_many('orders', 'AATW::Schema::Result::Order', 'customer_id');

1;