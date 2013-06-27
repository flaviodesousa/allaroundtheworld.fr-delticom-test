package AATW::Schema;

use 5.014;
use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces();
say __PACKAGE__;
