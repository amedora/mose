# vim:set sw=4 ts=4 ft=perl:
package Mose::Render;
use Mojo::Base 'Mojolicious::Controller';
use File::Basename;
use File::Find::Rule;
use YAML;

use Mose::Util qw/laptime_in_milisec/;
use IRacing::Setup;

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

sub laptime {
    my $self = shift;
    $self->render(
        json => _render_laptime(
            $self->stash('config')->{laptimedir}, $self->param('car'),
            $self->param('file_selected')
        )
    );
}

1;
