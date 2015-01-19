# vim:set sw=4 ts=4 ft=perl:
package Mose::Analysis::Graph;

use IRacing::Setup;
use strict;

my $GraphList = {
    latemodel => [
        qw/
          ballast
          front_rideheight
          front_tiretemp
          front_tread
          left_spring_package
          left_tiretemp_avg
          left_weight_dist
          rear_rideheight
          rear_tiretemp
          rear_tread
          rideheight_relation
          right_spring_package
          right_tiretemp_avg
          right_weight_dist
          trackbar_height
          /
    ],
    'stockcars chevyss' => [
        qw/
          ballast
          front_rideheight
          front_tiretemp
          front_tread
          left_spring_package
          left_tiretemp_avg
          left_weight_dist
          rear_rideheight
          rear_tiretemp
          rear_tread
          rideheight_relation
          right_spring_package
          right_tiretemp_avg
          right_weight_dist
          trackbar_height
          /
    ],
    'stockcars fordfusion' => [
        qw/
          ballast
          front_rideheight
          front_tiretemp
          front_tread
          left_spring_package
          left_tiretemp_avg
          left_weight_dist
          rear_rideheight
          rear_tiretemp
          rear_tread
          rideheight_relation
          right_spring_package
          right_tiretemp_avg
          right_weight_dist
          trackbar_height
          /
    ],
    'stockcars toyotacamry' => [
        qw/
          ballast
          front_rideheight
          front_tiretemp
          front_tread
          left_spring_package
          left_tiretemp_avg
          left_weight_dist
          rear_rideheight
          rear_tiretemp
          rear_tread
          rideheight_relation
          right_spring_package
          right_tiretemp_avg
          right_weight_dist
          trackbar_height
          /
    ],
    williamsfw31 => [
        qw/
          ballast
          front_rideheight
          front_tiretemp
          front_tread
          left_tiretemp_avg
          left_weight_dist
          rear_rideheight
          rear_tiretemp
          rear_tread
          rideheight_relation
          right_tiretemp_avg
          right_weight_dist
          /
    ],
};

my $GraphData = {
    front_rideheight => sub {
        my $s = shift;
        return (
            $s->data(
                component => [ 'CHASSIS' => 'LEFT FRONT' => 'Ride height' ]
            ),
            $s->data(
                component => [ 'CHASSIS' => 'RIGHT FRONT' => 'Ride height' ]
            )
        );
    },
    rear_rideheight => sub {
        my $s = shift;
        if ( $s->car_name eq 'williamsfw31' ) {
            return (
                $s->data(
                    component => [ 'CHASSIS' => 'REAR' => 'Ride height' ]
                )
            );
        }
        else {
            return (
                $s->data(
                    component => [ 'CHASSIS' => 'LEFT REAR' => 'Ride height' ]
                ),
                $s->data(
                    component => [ 'CHASSIS' => 'RIGHT REAR' => 'Ride height' ]
                )
            );
        }
    },
    rideheight_relation => sub {
        my $s     = shift;
        my $front = (
            $s->data(
                component => [ 'CHASSIS' => 'LEFT FRONT' => 'Ride height' ]
              ) + $s->data(
                component => [ 'CHASSIS' => 'RIGHT FRONT' => 'Ride height' ]
              )
        ) / 2.000;
        my $rear;
        if ( $s->car_name eq 'williamsfw31' ) {
            $rear =
              $s->data( component => [ 'CHASSIS' => 'REAR' => 'Ride height' ] );
        }
        else {
            $rear = (
                $s->data(
                    component => [ 'CHASSIS' => 'LEFT REAR' => 'Ride height' ]
                  ) + $s->data(
                    component => [ 'CHASSIS' => 'RIGHT REAR' => 'Ride height' ]
                  )
            ) / 2.000;
        }
        return ( $front, $rear );
    },
    trackbar_height => sub {
        my $s = shift;
        return (
            $s->data(
                component => [ 'CHASSIS' => 'LEFT REAR' => 'Track bar height' ]
            ),
            $s->data(
                component => [ 'CHASSIS' => 'RIGHT REAR' => 'Track bar height' ]
            ),
        );
    },
    front_tiretemp => sub {
        my $s = shift;
        return (
            $s->data(
                component => [ 'TIRE' => 'LEFT FRONT' => 'Last temps O' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'LEFT FRONT' => 'Last temps M' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'LEFT FRONT' => 'Last temps I' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'RIGHT FRONT' => 'Last temps I' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'RIGHT FRONT' => 'Last temps M' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'RIGHT FRONT' => 'Last temps O' ]
            )
        );
    },
    rear_tiretemp => sub {
        my $s = shift;
        return (
            $s->data(
                component => [ 'TIRE' => 'LEFT REAR' => 'Last temps O' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'LEFT REAR' => 'Last temps M' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'LEFT REAR' => 'Last temps I' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'RIGHT REAR' => 'Last temps I' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'RIGHT REAR' => 'Last temps M' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'RIGHT REAR' => 'Last temps O' ]
            )
        );
    },
    front_tread => sub {
        my $s = shift;
        return (
            $s->data(
                component => [ 'TIRE' => 'LEFT FRONT' => 'Tread remaining O' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'LEFT FRONT' => 'Tread remaining M' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'LEFT FRONT' => 'Tread remaining I' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'RIGHT FRONT' => 'Tread remaining I' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'RIGHT FRONT' => 'Tread remaining M' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'RIGHT FRONT' => 'Tread remaining O' ]
            )
        );
    },
    rear_tread => sub {
        my $s = shift;
        return (
            $s->data(
                component => [ 'TIRE' => 'LEFT REAR' => 'Tread remaining O' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'LEFT REAR' => 'Tread remaining M' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'LEFT REAR' => 'Tread remaining I' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'RIGHT REAR' => 'Tread remaining I' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'RIGHT REAR' => 'Tread remaining M' ]
            ),
            $s->data(
                component => [ 'TIRE' => 'RIGHT REAR' => 'Tread remaining O' ]
            )
        );
    },
    left_weight_dist => sub {
        my $s = shift;
        return (
            $s->data(
                component => [ 'CHASSIS' => 'LEFT FRONT' => 'Corner weight' ]
            ),
            $s->data(
                component => [ 'CHASSIS' => 'LEFT REAR' => 'Corner weight' ]
            )
        );
    },
    right_weight_dist => sub {
        my $s = shift;
        return (
            $s->data(
                component => [ 'CHASSIS' => 'RIGHT FRONT' => 'Corner weight' ]
            ),
            $s->data(
                component => [ 'CHASSIS' => 'RIGHT REAR' => 'Corner weight' ]
            )
        );
    },
    ballast => sub {
        my $s = shift;
        my $ballast;
        if ( $s->car_name eq 'williamsfw31' ) {
            $ballast =
              $s->data( component => [ 'CHASSIS' => 'GENERAL' => 'Ballast' ] );
        }
        else {
            $ballast =
              $s->data(
                component => [ 'CHASSIS' => 'FRONT' => 'Ballast forward' ] );
        }
        return ( [ 1, $ballast ] );
    },
    left_spring_package => sub {
        my $s = shift;
        return (
            $s->data(
                component => [ 'CHASSIS' => 'LEFT FRONT' => 'Spring rate' ]
            ),
            $s->data(
                component => [ 'CHASSIS' => 'LEFT REAR' => 'Spring rate' ]
            )
        );
    },
    right_spring_package => sub {
        my $s = shift;
        return (
            $s->data(
                component => [ 'CHASSIS' => 'RIGHT FRONT' => 'Spring rate' ]
            ),
            $s->data(
                component => [ 'CHASSIS' => 'RIGHT REAR' => 'Spring rate' ]
            )
        );
    },
    left_tiretemp_avg => sub {
        my $s = shift;
        return (
            $s->data(
                component => [ 'ANALYSIS' => 'Avg. temps' => 'LEFT FRONT' ]
            ),
            $s->data(
                component => [ 'ANALYSIS' => 'Avg. temps' => 'LEFT REAR' ]
            ),
            int(
                (
                    $s->data(
                        component =>
                          [ 'ANALYSIS' => 'Avg. temps' => 'LEFT FRONT' ]
                      ) + $s->data(
                        component =>
                          [ 'ANALYSIS' => 'Avg. temps' => 'LEFT REAR' ]
                      )
                ) / 2
            )
        );
    },
    right_tiretemp_avg => sub {
        my $s = shift;
        return (
            $s->data(
                component => [ 'ANALYSIS' => 'Avg. temps' => 'RIGHT FRONT' ]
            ),
            $s->data(
                component => [ 'ANALYSIS' => 'Avg. temps' => 'RIGHT REAR' ]
            ),
            int(
                (
                    $s->data(
                        component =>
                          [ 'ANALYSIS' => 'Avg. temps' => 'RIGHT FRONT' ]
                      ) + $s->data(
                        component =>
                          [ 'ANALYSIS' => 'Avg. temps' => 'RIGHT REAR' ]
                      )
                ) / 2
            )
        );
    },
};

sub available_graph {
    my $car = shift;
    return @{ $GraphList->{$car} };
}

sub data {
    my ( $graph_name, @setups ) = @_;
    my $ret = [];
    foreach my $s (@setups) {
		my $name = $s->file_name;
		$name =~ tr/<>//d;	#XXX: dirty hack
        push @{$ret},
          +{
            name => $name,
            data => [ $GraphData->{$graph_name}->($s) ],
          };
    }
    return $ret;
}

1;
