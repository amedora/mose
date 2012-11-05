# vim:set sw=4 ts=4 ft=perl:
package Mose::Analysis;
use Mojo::Base 'Mojolicious::Controller';

use IRacing::Setup::Parser;

sub index {
	my $self = shift;
}

sub home {
    my $self      = shift;
    my $car       = $self->param('car');
	$self->stash->{setups} = $self->app->setups($car);
	$self->stash->{car} = $car;
}

sub datatable {
    my $self  = shift;
    my @files = map {
        $self->stash->{config}->{setupdir} . '/' . $self->param('car') . $_;
    } $self->param('file_selected');
    my @setups;
    push @setups, IRacing::Setup::Parser->new($_) foreach @files;
	$self->stash->{setups} = \@setups;
}

1;
