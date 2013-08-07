# vim:set sw=4 ts=4 ft=perl:
package Mose::Laptime;
use Mojo::Base 'Mojolicious::Controller';
use File::Basename;
use File::Find::Rule;
use YAML;

use Mose::Util qw/laptime_in_milisec/;

sub manager {
    my $self = shift;
    my $car  = $self->param('car');

    $self->stash->{setups} = $self->app->setups($car);
    $self->stash->{car}    = $car;
}

sub list {
    my $self   = shift;
    my $record = {};
    $self->session->{file_selected} = $self->param('file_selected');
    my $laptimefile =
        $self->stash('config')->{laptimedir} . '/'
      . $self->param('car') . '/'
      . $self->param('file_selected') . '.laps';
    $self->app->log->debug("Loading: $laptimefile");
    $record = YAML::LoadFile($laptimefile) if -f $laptimefile;
    $self->render(
        'laptime/list',
        car    => $self->param('car'),
        record => $record
    );
}

1;
