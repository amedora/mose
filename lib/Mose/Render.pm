# vim:set sw=4 ts=4 ft=perl:
package Mose::Render;
use Mojo::Base 'Mojolicious::Controller';
use File::Basename;
use File::Find::Rule;
use YAML;

use Mose::Util qw/laptime_in_milisec/;
use IRacing::Setup;

my $_files_verified = {};

my $render = {
    front_rideheight => {
        latemodel              => \&_render_front_rideheight,
        'stockcars fordfusion' => \&_render_front_rideheight,
        'stockcars chevyss'    => \&_render_front_rideheight,
    },
    rear_rideheight => {
        latemodel              => \&_render_rear_rideheight,
        'stockcars fordfusion' => \&_render_rear_rideheight,
        'stockcars chevyss'    => \&_render_rear_rideheight,
    },
    rideheight_relation => {
        latemodel              => \&_render_rideheight_relation,
        'stockcars fordfusion' => \&_render_rideheight_relation,
        'stockcars chevyss'    => \&_render_rideheight_relation,
    },
    trackbar_height => {
        latemodel              => \&_render_trackbar_height,
        'stockcars fordfusion' => \&_render_trackbar_height,
        'stockcars chevyss'    => \&_render_trackbar_height,
    },
    left_weight_dist => {
        latemodel              => \&_render_left_weight_dist,
        'stockcars fordfusion' => \&_render_left_weight_dist,
        'stockcars chevyss'    => \&_render_left_weight_dist,
    },
    right_weight_dist => {
        latemodel              => \&_render_right_weight_dist,
        'stockcars fordfusion' => \&_render_right_weight_dist,
        'stockcars chevyss'    => \&_render_right_weight_dist,
    },
    ballast => {
        latemodel              => \&_render_ballast,
        'stockcars fordfusion' => \&_render_ballast,
        'stockcars chevyss'    => \&_render_ballast,
    },
    left_spring_package => {
        latemodel              => \&_render_left_spring_package,
        'stockcars fordfusion' => \&_render_left_spring_package,
        'stockcars chevyss'    => \&_render_left_spring_package,
    },
    right_spring_package => {
        latemodel              => \&_render_right_spring_package,
        'stockcars fordfusion' => \&_render_right_spring_package,
        'stockcars chevyss'    => \&_render_right_spring_package,
    },
    front_tiretemp => {
        latemodel              => \&_render_front_tiretemp,
        'stockcars fordfusion' => \&_render_front_tiretemp,
        'stockcars chevyss'    => \&_render_front_tiretemp,
    },
    rear_tiretemp => {
        latemodel              => \&_render_rear_tiretemp,
        'stockcars fordfusion' => \&_render_rear_tiretemp,
        'stockcars chevyss'    => \&_render_rear_tiretemp,
    },
    left_tiretemp_avg => {
        latemodel              => \&_render_left_tiretemp_avg,
        'stockcars fordfusion' => \&_render_left_tiretemp_avg,
        'stockcars chevyss'    => \&_render_left_tiretemp_avg,
    },
    right_tiretemp_avg => {
        latemodel              => \&_render_right_tiretemp_avg,
        'stockcars fordfusion' => \&_render_right_tiretemp_avg,
        'stockcars chevyss'    => \&_render_right_tiretemp_avg,
    },
    front_tread => {
        latemodel              => \&_render_front_tread,
        'stockcars fordfusion' => \&_render_front_tread,
        'stockcars chevyss'    => \&_render_front_tread,
    },
    rear_tread => {
        latemodel              => \&_render_rear_tread,
        'stockcars fordfusion' => \&_render_rear_tread,
        'stockcars chevyss'    => \&_render_rear_tread,
    },
};

sub _render {
    my ( $graph, $car, @files ) = @_;
    my $ret = { series => [] };
    my @setups;
    push @setups, IRacing::Setup->new($_) foreach @files;
    foreach my $s (@setups) {
        push @{ $ret->{series} },
          +{
            name => $s->file_name,
            data => [ $render->{$graph}->{$car}->($s) ],
          };
    }
    return $ret;
}

sub _render_front_rideheight {
    my $s = shift;
    return (
        $s->data( component => [ 'CHASSIS' => 'LEFT FRONT' => 'Ride height' ] ),
        $s->data(
            component => [ 'CHASSIS' => 'RIGHT FRONT' => 'Ride height' ]
        )
    );
}

sub _render_rear_rideheight {
    my $s = shift;
    return (
        $s->data( component => [ 'CHASSIS' => 'LEFT REAR'  => 'Ride height' ] ),
        $s->data( component => [ 'CHASSIS' => 'RIGHT REAR' => 'Ride height' ] )
    );
}

sub _render_rideheight_relation {
    my $s = shift;
    return (
        (
            $s->data(
                component => [ 'CHASSIS' => 'LEFT FRONT' => 'Ride height' ]
              ) + $s->data(
                component => [ 'CHASSIS' => 'RIGHT FRONT' => 'Ride height' ]
              )
        ) / 2.000,
        (
            $s->data(
                component => [ 'CHASSIS' => 'LEFT REAR' => 'Ride height' ]
              ) + $s->data(
                component => [ 'CHASSIS' => 'RIGHT REAR' => 'Ride height' ]
              )
        ) / 2.000
    );
}

sub _render_trackbar_height {
    my $s = shift;
    return (
        $s->data(
            component => [ 'CHASSIS' => 'LEFT REAR' => 'Track bar height' ]
        ),
        $s->data(
            component => [ 'CHASSIS' => 'RIGHT REAR' => 'Track bar height' ]
        ),
    );
}

sub _render_front_tiretemp {
    my $s = shift;
    return (
        $s->data( component => [ 'TIRE' => 'LEFT FRONT'  => 'Last temps O' ] ),
        $s->data( component => [ 'TIRE' => 'LEFT FRONT'  => 'Last temps M' ] ),
        $s->data( component => [ 'TIRE' => 'LEFT FRONT'  => 'Last temps I' ] ),
        $s->data( component => [ 'TIRE' => 'RIGHT FRONT' => 'Last temps I' ] ),
        $s->data( component => [ 'TIRE' => 'RIGHT FRONT' => 'Last temps M' ] ),
        $s->data( component => [ 'TIRE' => 'RIGHT FRONT' => 'Last temps O' ] )
    );
}

sub _render_rear_tiretemp {
    my $s = shift;
    return (
        $s->data( component => [ 'TIRE' => 'LEFT REAR'  => 'Last temps O' ] ),
        $s->data( component => [ 'TIRE' => 'LEFT REAR'  => 'Last temps M' ] ),
        $s->data( component => [ 'TIRE' => 'LEFT REAR'  => 'Last temps I' ] ),
        $s->data( component => [ 'TIRE' => 'RIGHT REAR' => 'Last temps I' ] ),
        $s->data( component => [ 'TIRE' => 'RIGHT REAR' => 'Last temps M' ] ),
        $s->data( component => [ 'TIRE' => 'RIGHT REAR' => 'Last temps O' ] )
    );
}

sub _render_front_tread {
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
}

sub _render_rear_tread {
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
}

sub _render_left_weight_dist {
    my $s = shift;
    return (
        $s->data(
            component => [ 'CHASSIS' => 'LEFT FRONT' => 'Corner weight' ]
        ),
        $s->data(
            component => [ 'CHASSIS' => 'LEFT REAR' => 'Corner weight' ]
        )
    );
}

sub _render_right_weight_dist {
    my $s = shift;
    return (
        $s->data(
            component => [ 'CHASSIS' => 'RIGHT FRONT' => 'Corner weight' ]
        ),
        $s->data(
            component => [ 'CHASSIS' => 'RIGHT REAR' => 'Corner weight' ]
        )
    );
}

sub _render_ballast {
    my $s = shift;
    return (
        [
            1,
            $s->data(
                component => [ 'CHASSIS' => 'FRONT' => 'Ballast forward' ]
            )
        ]
    );
}

sub _render_left_spring_package {
    my $s = shift;
    return (
        $s->data( component => [ 'CHASSIS' => 'LEFT FRONT' => 'Spring rate' ] ),
        $s->data( component => [ 'CHASSIS' => 'LEFT REAR'  => 'Spring rate' ] )
    );
}

sub _render_right_spring_package {
    my $s = shift;
    return (
        $s->data(
            component => [ 'CHASSIS' => 'RIGHT FRONT' => 'Spring rate' ]
        ),
        $s->data( component => [ 'CHASSIS' => 'RIGHT REAR' => 'Spring rate' ] )
    );
}

sub _render_left_tiretemp_avg {
    my $s = shift;
    return (
        $s->data( component => [ 'ANALYSIS' => 'Avg. temps' => 'LEFT FRONT' ] ),
        $s->data( component => [ 'ANALYSIS' => 'Avg. temps' => 'LEFT REAR' ] ),
        int(
            (
                $s->data(
                    component => [ 'ANALYSIS' => 'Avg. temps' => 'LEFT FRONT' ]
                  ) + $s->data(
                    component => [ 'ANALYSIS' => 'Avg. temps' => 'LEFT REAR' ]
                  )
            ) / 2
        )
    );
}

sub _render_right_tiretemp_avg {
    my $s = shift;
    return (
        $s->data(
            component => [ 'ANALYSIS' => 'Avg. temps' => 'RIGHT FRONT' ]
        ),
        $s->data( component => [ 'ANALYSIS' => 'Avg. temps' => 'RIGHT REAR' ] ),
        int(
            (
                $s->data(
                    component => [ 'ANALYSIS' => 'Avg. temps' => 'RIGHT FRONT' ]
                  ) + $s->data(
                    component => [ 'ANALYSIS' => 'Avg. temps' => 'RIGHT REAR' ]
                  )
            ) / 2
        )
    );
}

sub _render_laptime {
    my ( $dir, $car, @files ) = @_;
    my $ret = { series => [] };
    foreach my $filename (@files) {
        $filename = ( fileparse($filename) )[0] . '.laps';
        my $fullpath = $dir . '/' . $car . '/' . $filename;
        if ( !-f $fullpath ) {
            push @{ $ret->{series} },
              +{
                name => $filename,
                data => [],
              };
        }
        else {
            my $record = YAML::LoadFile($fullpath);
            while ( my ( $s, $r ) = each %{$record} ) {
                next unless $r->{mark};
                push @{ $ret->{series} },
                  +{
                    name => $filename,
                    data =>
                      [ map { laptime_in_milisec($_) } @{ $r->{laptime} } ],
                  };
                last;
            }
        }
    }
    return $ret;
}

sub _render_undef {
}

sub laptime {
    my $self = shift;
    $self->render(
        json => _render_laptime(
            $self->stash('config')->{laptimedir}, $self->param('car'),
            $self->param('file_selected')
        )
    );
}

sub graph {
    my $self = shift;
    $self->render(
        json => _render(
            $self->param('graph_type'),
            $self->param('car'),
            map {
                    $self->stash('config')->{setupdir} . '/'
                  . $self->param('car')
                  . $_;
            } $self->param('file_selected')
        )
    );
}

1;
