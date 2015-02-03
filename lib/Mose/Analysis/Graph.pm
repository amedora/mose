# vim:set sw=4 ts=4 ft=perl:
package Mose::Analysis::Graph;

use IRacing::Setup;
use strict;

my $common_top_oval = {
    front_rideheight => {
        unit => {
            ENGLISH => 'inch',
            METRIC  => 'mm',
        },
        min => {
            ENGLISH => 1.5,
            METRIC  => 40,
        },
        max => {
            ENGLISH => 7,
            METRIC  => 180,
        },
    },
    rear_rideheight => {
        unit => {
            ENGLISH => 'inch',
            METRIC  => 'mm',
        },
        min => {
            ENGLISH => 1.5,
            METRIC  => 40,
        },
        max => {
            ENGLISH => 7,
            METRIC  => 180,
        },
    },
    rideheight_relation => {
        unit => {
            ENGLISH => 'inch',
            METRIC  => 'mm',
        },
        min => {
            ENGLISH => 1.5,
            METRIC  => 40,
        },
        max => {
            ENGLISH => 7,
            METRIC  => 180,
        },
    },
    trackbar_height => {
        unit => {
            ENGLISH => 'inch',
            METRIC  => 'mm',
        },
        min => {
            ENGLISH => 6,
            METRIC  => 150,
        },
        max => {
            ENGLISH => 15,
            METRIC  => 390,
        },
    },
    left_weight_dist => {
        unit => {
            ENGLISH => 'lbs.',
            METRIC  => 'N',
        },
        min => {
            ENGLISH => 300,
            METRIC  => 500,
        },
        max => {
            ENGLISH => 1300,
            METRIC  => 5500,
        },
        minorTickInterval => {
            ENGLISH => 50,
            METRIC  => 500,
        },
    },
    ballast => {
        unit => {
            ENGLISH => 'inch',
            METRIC  => 'mm',
        },
        min => {
            ENGLISH => 0,
            METRIC  => 0,
        },
        max => {
            ENGLISH => 48,
            METRIC  => 1220,
        },
        tickInterval => {
            ENGLISH => 10,
            METRIC  => 500,
        },
        minorTickInterval => {
            ENGLISH => 5,
            METRIC  => 100,
        },
    },
    right_weight_dist => {
        unit => {
            ENGLISH => 'lbs.',
            METRIC  => 'N',
        },
        min => {
            ENGLISH => 300,
            METRIC  => 500,
        },
        max => {
            ENGLISH => 1300,
            METRIC  => 5500,
        },
        minorTickInterval => {
            ENGLISH => 50,
            METRIC  => 500,
        },
    },
    left_spring_package => {
        unit => {
            ENGLISH => 'lbs/in',
            METRIC  => 'N/mm',
        },
        min => {
            ENGLISH => 200,
            METRIC  => 35,
        },
        max => {
            ENGLISH => 10000,	# actual max is 10,000.
            METRIC  => 1750,
        },
        minorTickInterval => {
            ENGLISH => 500,
            METRIC  => 100,
        },
    },
    right_spring_package => {
        unit => {
            ENGLISH => 'lbs/in',
            METRIC  => 'N/mm',
        },
        min => {
            ENGLISH => 200,
            METRIC  => 35,
        },
        max => {
            ENGLISH => 10000,	# actual max is 10,000.
            METRIC  => 1750,
        },
        minorTickInterval => {
            ENGLISH => 500,
            METRIC  => 100,
        },
    },
    front_tiretemp => {
        unit => {
            ENGLISH => 'F',
            METRIC  => 'C',
        },
        min => {
            ENGLISH => 100,
            METRIC  => 35,
        },
        max => {
            ENGLISH => 300,
            METRIC  => 150,
        },
        minorTickInterval => {
            ENGLISH => 10,
            METRIC  => 10,
        },
    },
    front_camber => {
        unit => {
            ENGLISH => 'deg.',
            METRIC  => 'deg.',
        },
        min => {
            ENGLISH => -8,
            METRIC  => -8,
        },
        max => {
            ENGLISH => 8,
            METRIC  => 8,
        },
        minorTickInterval => {
            ENGLISH => 1,
            METRIC  => 1,
        },
    },
    rear_tiretemp => {
        unit => {
            ENGLISH => 'F',
            METRIC  => 'C',
        },
        min => {
            ENGLISH => 100,
            METRIC  => 35,
        },
        max => {
            ENGLISH => 300,
            METRIC  => 150,
        },
        minorTickInterval => {
            ENGLISH => 10,
            METRIC  => 10,
        },
    },
    rear_camber => {
        unit => {
            ENGLISH => 'deg.',
            METRIC  => 'deg.',
        },
        min => {
            ENGLISH => -3.6,
            METRIC  => -3.6,
        },
        max => {
            ENGLISH => 3.6,
            METRIC  => 3.6,
        },
        minorTickInterval => {
            ENGLISH => 1,
            METRIC  => 1,
        },
    },
    left_tiretemp_avg => {
        unit => {
            ENGLISH => 'F',
            METRIC  => 'C',
        },
        min => {
            ENGLISH => 100,
            METRIC  => 35,
        },
        max => {
            ENGLISH => 300,
            METRIC  => 150,
        },
        minorTickInterval => {
            ENGLISH => 10,
            METRIC  => 10,
        },
    },
    right_tiretemp_avg => {
        unit => {
            ENGLISH => 'F',
            METRIC  => 'C',
        },
        min => {
            ENGLISH => 100,
            METRIC  => 35,
        },
        max => {
            ENGLISH => 300,
            METRIC  => 150,
        },
        minorTickInterval => {
            ENGLISH => 10,
            METRIC  => 10,
        },
    },
    front_tread => {},
    rear_tread  => {},
};

my $GraphList = {
    latemodel => {
        front_rideheight => {
            unit => {
                ENGLISH => 'inch',
                METRIC  => 'mm',
            },
            min => {
                ENGLISH => 3.95,
                METRIC  => 100,
            },
            max => {
                ENGLISH => 4.55,
                METRIC  => 115,
            },
        },
        rear_rideheight => {
            unit => {
                ENGLISH => 'inch',
                METRIC  => 'mm',
            },
            min => {
                ENGLISH => 3.95,
                METRIC  => 100,
            },
            max => {
                ENGLISH => 4.55,
                METRIC  => 115,
            },
        },
        rideheight_relation => {
            unit => {
                ENGLISH => 'inch',
                METRIC  => 'mm',
            },
            min => {
                ENGLISH => 3.95,
                METRIC  => 100,
            },
            max => {
                ENGLISH => 4.55,
                METRIC  => 115,
            },
        },
        trackbar_height => {
            unit => {
                ENGLISH => 'inch',
                METRIC  => 'mm',
            },
            min => {
                ENGLISH => 6,
                METRIC  => 150,
            },
            max => {
                ENGLISH => 15,
                METRIC  => 435,
            },
        },
        left_weight_dist => {
            unit => {
                ENGLISH => 'lbs.',
                METRIC  => 'N',
            },
            min => {
                ENGLISH => 650,
                METRIC  => 2500,
            },
            max => {
                ENGLISH => 1000,
                METRIC  => 4500,
            },
            minorTickInterval => {
                ENGLISH => 50,
                METRIC  => 100,
            },
        },
        ballast => {
            unit => {
                ENGLISH => 'inch',
                METRIC  => 'mm',
            },
            min => {
                ENGLISH => -24,
                METRIC  => -1,    # XXX: seems iRacing bug
            },
            max => {
                ENGLISH => 36,
                METRIC  => 1,
            },
        },
        right_weight_dist => {
            unit => {
                ENGLISH => 'lbs.',
                METRIC  => 'N',
            },
            min => {
                ENGLISH => 650,
                METRIC  => 2500,
            },
            max => {
                ENGLISH => 1000,
                METRIC  => 4500,
            },
            minorTickInterval => {
                ENGLISH => 50,
                METRIC  => 100,
            },
        },
        left_spring_package => {
            unit => {
                ENGLISH => 'lbs/in',
                METRIC  => 'N/mm',
            },
            min => {
                ENGLISH => 100,
                METRIC  => 18,
            },
            max => {
                ENGLISH => 1000,
                METRIC  => 175,
            },
            minorTickInterval => {
                ENGLISH => 25,
                METRIC  => 5,
            },
        },
        right_spring_package => {
            unit => {
                ENGLISH => 'lbs/in',
                METRIC  => 'N/mm',
            },
            min => {
                ENGLISH => 100,
                METRIC  => 18,
            },
            max => {
                ENGLISH => 1000,
                METRIC  => 175,
            },
            minorTickInterval => {
                ENGLISH => 25,
                METRIC  => 5,
            },
        },
        front_tiretemp => {
            unit => {
                ENGLISH => 'F',
                METRIC  => 'C',
            },
            min => {
                ENGLISH => 100,
                METRIC  => 35,
            },
            max => {
                ENGLISH => 275,
                METRIC  => 140,
            },
            minorTickInterval => {
                ENGLISH => 10,
                METRIC  => 5,
            },
        },
        left_tiretemp_avg => {
            unit => {
                ENGLISH => 'F',
                METRIC  => 'C',
            },
            min => {
                ENGLISH => 100,
                METRIC  => 35,
            },
            max => {
                ENGLISH => 275,
                METRIC  => 140,
            },
            minorTickInterval => {
                ENGLISH => 10,
                METRIC  => 5,
            },
        },
        rear_tiretemp => {
            unit => {
                ENGLISH => 'F',
                METRIC  => 'C',
            },
            min => {
                ENGLISH => 100,
                METRIC  => 35,
            },
            max => {
                ENGLISH => 275,
                METRIC  => 140,
            },
            minorTickInterval => {
                ENGLISH => 10,
                METRIC  => 5,
            },
        },
        right_tiretemp_avg => {
            unit => {
                ENGLISH => 'F',
                METRIC  => 'C',
            },
            min => {
                ENGLISH => 100,
                METRIC  => 35,
            },
            max => {
                ENGLISH => 275,
                METRIC  => 140,
            },
            minorTickInterval => {
                ENGLISH => 10,
                METRIC  => 5,
            },
        },
        front_tread => {},
        rear_tread  => {},
    },
    'stockcars chevyss'     => { %$common_top_oval, },
    'stockcars fordfusion'  => { %$common_top_oval, },
    'stockcars toyotacamry' => { %$common_top_oval, },
    williamsfw31            => [
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
    front_camber => sub {
        my $s = shift;
        return (
            $s->data(
                component => [ 'CHASSIS' => 'LEFT FRONT' => 'Camber' ]
            ),
            $s->data(
                component => [ 'CHASSIS' => 'RIGHT FRONT' => 'Camber' ]
            ),
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
    rear_camber => sub {
        my $s = shift;
        return (
            $s->data(
                component => [ 'CHASSIS' => 'LEFT REAR' => 'Camber' ]
            ),
            $s->data(
                component => [ 'CHASSIS' => 'RIGHT REAR' => 'Camber' ]
            ),
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
    return keys %{ $GraphList->{$car} };
}

sub data {
    my ( $graph_name, @setups ) = @_;
    my $ret = [];
    foreach my $s (@setups) {
        my $name = $s->file_name;
        $name =~ tr/<>//d;    #XXX: dirty hack
        push @{$ret},
          +{
            name => $name,
            data => [ $GraphData->{$graph_name}->($s) ],
          };
    }
    return $ret;
}

sub GraphOption {
    my ( $car, $unit ) = @_;
    return sub {
        my ( $graph, $option ) = @_;
        return $GraphList->{$car}->{$graph}->{$option}->{$unit};
    };
}

1;
