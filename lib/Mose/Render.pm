# vim:set sw=4 ts=4 ft=perl:
package Mose::Render;
use Mojo::Base 'Mojolicious::Controller';
use List::Util qw/minstr sum/;
use File::Basename;
use File::Find::Rule;
use YAML;

use IRacing::Setup::Parser;

my $_files_verified = {};

my $render = {
    front_rideheight     => { latemodel => \&_render_front_rideheight, },
    rear_rideheight      => { latemodel => \&_render_rear_rideheight, },
    rideheight_relation  => { latemodel => \&_render_rideheight_relation, },
    trackbar_height      => { latemodel => \&_render_trackbar_height, },
    left_weight_dist     => { latemodel => \&_render_left_weight_dist, },
    right_weight_dist    => { latemodel => \&_render_right_weight_dist, },
    ballast              => { latemodel => \&_render_ballast, },
    left_spring_package  => { latemodel => \&_render_left_spring_package, },
    right_spring_package => { latemodel => \&_render_right_spring_package, },
    front_tiretemp       => { latemodel => \&_render_front_tiretemp, },
    rear_tiretemp        => { latemodel => \&_render_rear_tiretemp, },
    left_tiretemp_avg    => { latemodel => \&_render_left_tiretemp_avg, },
    right_tiretemp_avg   => { latemodel => \&_render_right_tiretemp_avg, },
    front_tread          => { latemodel => \&_render_front_tread, },
    rear_tread           => { latemodel => \&_render_rear_tread, },
};

sub _render {
    my ( $graph, $car, @files ) = @_;
    my $ret = { series => [] };
    my @setups;
    push @setups, IRacing::Setup::Parser->new($_) foreach @files;
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
        $s->data_wou( 'CHASSIS' => 'LEFT FRONT'  => 'Ride height' ),
        $s->data_wou( 'CHASSIS' => 'RIGHT FRONT' => 'Ride height' )
    );
}

sub _render_rear_rideheight {
    my $s = shift;
    return (
        $s->data_wou( 'CHASSIS' => 'LEFT REAR'  => 'Ride height' ),
        $s->data_wou( 'CHASSIS' => 'RIGHT REAR' => 'Ride height' )
    );
}

sub _render_rideheight_relation {
    my $s = shift;
    return (
        (
            $s->data_wou( 'CHASSIS' => 'LEFT FRONT' => 'Ride height' ) +
              $s->data_wou( 'CHASSIS' => 'RIGHT FRONT' => 'Ride height' )
        ) / 2.000,
        (
            $s->data_wou( 'CHASSIS' => 'LEFT REAR' => 'Ride height' ) +
              $s->data_wou( 'CHASSIS' => 'RIGHT REAR' => 'Ride height' )
          ) / 2.000
    );
}

sub _render_trackbar_height {
    my $s = shift;
    return (
        $s->data_wou( 'CHASSIS' => 'LEFT REAR'  => 'Track bar height' ),
        $s->data_wou( 'CHASSIS' => 'RIGHT REAR' => 'Track bar height' ),
    );
}

sub _render_front_tiretemp {
    my $s = shift;
    return (
        $s->data_wou( 'TIRE' => 'LEFT FRONT'  => 'Last temps O' ),
        $s->data_wou( 'TIRE' => 'LEFT FRONT'  => 'Last temps M' ),
        $s->data_wou( 'TIRE' => 'LEFT FRONT'  => 'Last temps I' ),
        $s->data_wou( 'TIRE' => 'RIGHT FRONT' => 'Last temps I' ),
        $s->data_wou( 'TIRE' => 'RIGHT FRONT' => 'Last temps M' ),
        $s->data_wou( 'TIRE' => 'RIGHT FRONT' => 'Last temps O' )
    );
}

sub _render_rear_tiretemp {
    my $s = shift;
    return (
        $s->data_wou( 'TIRE' => 'LEFT REAR'  => 'Last temps O' ),
        $s->data_wou( 'TIRE' => 'LEFT REAR'  => 'Last temps M' ),
        $s->data_wou( 'TIRE' => 'LEFT REAR'  => 'Last temps I' ),
        $s->data_wou( 'TIRE' => 'RIGHT REAR' => 'Last temps I' ),
        $s->data_wou( 'TIRE' => 'RIGHT REAR' => 'Last temps M' ),
        $s->data_wou( 'TIRE' => 'RIGHT REAR' => 'Last temps O' )
    );
}

sub _render_front_tread {
    my $s = shift;
    return (
        $s->data_wou( 'TIRE' => 'LEFT FRONT'  => 'Tread remaining O' ),
        $s->data_wou( 'TIRE' => 'LEFT FRONT'  => 'Tread remaining M' ),
        $s->data_wou( 'TIRE' => 'LEFT FRONT'  => 'Tread remaining I' ),
        $s->data_wou( 'TIRE' => 'RIGHT FRONT' => 'Tread remaining I' ),
        $s->data_wou( 'TIRE' => 'RIGHT FRONT' => 'Tread remaining M' ),
        $s->data_wou( 'TIRE' => 'RIGHT FRONT' => 'Tread remaining O' )
    );
}

sub _render_rear_tread {
    my $s = shift;
    return (
        $s->data_wou( 'TIRE' => 'LEFT REAR'  => 'Tread remaining O' ),
        $s->data_wou( 'TIRE' => 'LEFT REAR'  => 'Tread remaining M' ),
        $s->data_wou( 'TIRE' => 'LEFT REAR'  => 'Tread remaining I' ),
        $s->data_wou( 'TIRE' => 'RIGHT REAR' => 'Tread remaining I' ),
        $s->data_wou( 'TIRE' => 'RIGHT REAR' => 'Tread remaining M' ),
        $s->data_wou( 'TIRE' => 'RIGHT REAR' => 'Tread remaining O' )
    );
}

sub _render_left_weight_dist {
    my $s = shift;
    return (
        $s->data_wou( 'CHASSIS' => 'LEFT FRONT' => 'Corner weight' ),
        $s->data_wou( 'CHASSIS' => 'LEFT REAR'  => 'Corner weight' )
    );
}

sub _render_right_weight_dist {
    my $s = shift;
    return (
        $s->data_wou( 'CHASSIS' => 'RIGHT FRONT' => 'Corner weight' ),
        $s->data_wou( 'CHASSIS' => 'RIGHT REAR'  => 'Corner weight' )
    );
}

sub _render_ballast {
    my $s = shift;
    return ( [ 1, $s->data_wou( 'CHASSIS' => 'FRONT' => 'Ballast forward' ) ] );
}

sub _render_left_spring_package {
    my $s = shift;
    return (
        $s->data_wou( 'CHASSIS' => 'LEFT FRONT' => 'Spring rate' ),
        $s->data_wou( 'CHASSIS' => 'LEFT REAR'  => 'Spring rate' )
    );
}

sub _render_right_spring_package {
    my $s = shift;
    return (
        $s->data_wou( 'CHASSIS' => 'RIGHT FRONT' => 'Spring rate' ),
        $s->data_wou( 'CHASSIS' => 'RIGHT REAR'  => 'Spring rate' )
    );
}

sub _render_left_tiretemp_avg {
    my $s = shift;
    return (
        $s->data_wou( 'ANALYSIS' => 'Avg. temps' => 'LEFT FRONT' ),
        $s->data_wou( 'ANALYSIS' => 'Avg. temps' => 'LEFT REAR' ),
        int(
            (
                $s->data_wou( 'ANALYSIS' => 'Avg. temps' => 'LEFT FRONT' ) +
                  $s->data_wou( 'ANALYSIS' => 'Avg. temps' => 'LEFT REAR' )
            ) / 2
        )
    );
}

sub _render_right_tiretemp_avg {
    my $s = shift;
    return (
        $s->data_wou( 'ANALYSIS' => 'Avg. temps' => 'RIGHT FRONT' ),
        $s->data_wou( 'ANALYSIS' => 'Avg. temps' => 'RIGHT REAR' ),
        int(
            (
                $s->data_wou( 'ANALYSIS' => 'Avg. temps' => 'RIGHT FRONT' ) +
                  $s->data_wou( 'ANALYSIS' => 'Avg. temps' => 'RIGHT REAR' )
            ) / 2
        )
    );
}

sub _laptime_in_milisec {
    my $format = shift;
    my ( $min, $sec ) = split /:/, $format;
    $min = $min * 60 * 1000;
    $sec = $sec * 1000;
    return $min + $sec;
}

sub _render_laptime {
    my ( $dir, $car, @files ) = @_;
    my $ret = { series => [] };
    foreach my $filename (@files) {
        $filename = ( fileparse($filename) )[0] . '.yaml';
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
                      [ map { _laptime_in_milisec($_) } @{ $r->{laptime} } ],
                  };
                last;
            }
        }
    }
    return $ret;
}

sub _render_undef {
}

any '/render_laptime' => sub {
    my $self = shift;
    $self->render(
        json => _render_laptime(
            $self->stash('config')->{laptimedir}, $self->param('car'),
            $self->param('file_selected')
        )
    );
};

any '/render/:graph' => sub {
    my $self = shift;
    $self->render(
        json => _render(
            $self->param('graph'),
            $self->param('car'),
            map {
                    $self->stash('config')->{setupdir} . '/'
                  . $self->param('car')
                  . $_;
              } $self->param('file_selected')
        )
    );
};

get '/datatable' => sub {
    my $self  = shift;
    my @files = map {
        $self->stash('config')->{setupdir} . '/' . $self->param('car') . $_;
    } $self->param('file_selected');
    my @setups;
    push @setups, IRacing::Setup::Parser->new($_) foreach @files;
    $self->render( setups => \@setups );
};

1;