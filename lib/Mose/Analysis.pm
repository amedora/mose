# vim:set sw=4 ts=4 ft=perl:
package Mose::Analysis;
use Mojo::Base 'Mojolicious::Controller';

use IRacing::Setup;

sub index {
    my $self = shift;
}

sub analysis {
    my $self = shift;
    my $car  = $self->param('car');
    $self->render( "analysis/tab-analysis-$car", car => $car );
}

sub datatable {
    my $self  = shift;
    my @files = map {
        $self->stash->{config}->{setupdir} . '/' . $self->param('car') . $_;
    } $self->param('file_selected');
    my @setups;
    push @setups, IRacing::Setup->new($_) foreach @files;
    $self->stash->{setups} = \@setups;
}

1;
