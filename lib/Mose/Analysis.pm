# vim:set sw=4 ts=4 ft=perl:
package Mose::Analysis;
use Mojo::Base 'Mojolicious::Controller';
use Mose::Analysis::Graph;
use IRacing::Setup;

sub index {
    my $self = shift;
}

sub analysis {
    my $self       = shift;
    my $car        = $self->param('car');
    my @files = map {
        $self->stash->{config}->{setupdir} . '/' . $self->param('car') . $_;
    } $self->param('file_selected');
    my @setups;
    push @setups, IRacing::Setup->new($_) foreach @files;
    my $graph_data = {};
    foreach my $graph_name ( Mose::Analysis::Graph::available_graph($car) ) {
        $graph_data->{$graph_name} = $self->render(
            json    => Mose::Analysis::Graph::data( $graph_name, @setups ),
            partial => 1
        );
    }
    $self->render(
        "analysis/tab-analysis-$car",
        car        => $car,
        graph_data => $graph_data,
		setups     => \@setups
    );
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
