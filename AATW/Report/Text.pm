package AATW::Report::Text;

use 5.012;
use strict;
use warnings;

our $VERSION = q(0.0.1);

use FileHandle;

use Moose;

sub day_header {
	my ($self, $day, $orders, $total) = @_;
	$orders = "$orders Order" . ($orders > 1 ? 's' : '');
	format_name STDOUT 'DAY_FORMAT';
	write;
format DAY_FORMAT =
 =============================================================================
 Day @<<<<<<<<<             @>>>>>>>>>>                     Total $ @######.##
 $day, $orders, $total
.
}

sub customer_header {
	my ($self, $first_name, $last_name, $id, $total) = @_;
	my $customer = "$last_name, $first_name (id=$id)";
	format_name STDOUT 'CUSTOMER_FORMAT';
	write;
format CUSTOMER_FORMAT =
     ----------------------------------------------------------------------- |
     Customer: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  Total $ @######.## --+ ~
$customer, $total
.
}

sub order_header {
	my ($self, $order_number, $total) = @_;
	format_name STDOUT 'ORDER_FORMAT';
	write;
format ORDER_FORMAT =
               --------------------------------------------------------- |   |
               Order #@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  Total $ @######.##-+   |
$order_number, $total
                     ----------------------Items------------------------ |   |
.
}

sub item_price_line {
	my ($self, $name, $price) = @_;
	format_name STDOUT 'ITEM_PRICE';
	write;
format ITEM_PRICE =
                    @>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $ @######.##   |   |
$name, $price
.
}

1;