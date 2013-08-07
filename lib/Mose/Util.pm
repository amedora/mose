# vim:set sw=4 ts=4 ft=perl:
package Mose::Util;

use base 'Exporter';

our @EXPORT_OK = qw/
	graph_list
	laptime_in_milisec
/;

my $graph_list = {
	'stockcars chevyss' => [qw/
		front_rideheight
		rear_rideheight
		rideheight_relation
		trackbar_height
		left_weight_dist
		ballast
		right_weight_dist
		left_spring_package
		right_spring_package
		front_tiretemp
		left_tiretemp_avg
		right_tiretemp_avg
		rear_tiretemp
		front_tread
		rear_tread
	/],
	'stockcars fordfusion' => [qw/
		front_rideheight
		rear_rideheight
		rideheight_relation
		trackbar_height
		left_weight_dist
		ballast
		right_weight_dist
		left_spring_package
		right_spring_package
		front_tiretemp
		left_tiretemp_avg
		right_tiretemp_avg
		rear_tiretemp
		front_tread
		rear_tread
	/],
	latemodel => [qw/
		front_rideheight
		rear_rideheight
		rideheight_relation
		trackbar_height
		left_weight_dist
		ballast
		right_weight_dist
		left_spring_package
		right_spring_package
		front_tiretemp
		left_tiretemp_avg
		right_tiretemp_avg
		rear_tiretemp
		front_tread
		rear_tread
	/],
};

sub graph_list {
	my $car = shift;
	return @{$graph_list->{$car}};
}

sub laptime_in_milisec {
    my $format = shift;
    my ( $min, $sec ) = split /:/, $format;
    $min = $min * 60 * 1000;
    $sec = $sec * 1000;
    return $min + $sec;
}

1;
