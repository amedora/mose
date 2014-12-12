# vim:set sw=4 ts=4 ft=perl:
package Mose::Analysis;
use Mojo::Base 'Mojolicious::Controller';
use Mose::Analysis::Graph;
use IRacing::Setup;
use Data::Dumper;

sub index {
    my $self = shift;
}

sub analyze {
    my $self  = shift;
    my @files = ();

    foreach my $i ( 0 .. 2 ) {
        if ( my $s = $self->param( "file" . $i ) ) {
            if ( $s->asset->{content} ) {
                push @files, $s;
            }
        }
    }

    unless (@files) {

        # TODO: no files specified
        $self->app->log->debug("no files specified");
    }
	my @setups;
	foreach (@files) {
		push @setups, IRacing::Setup->new($_);
	}
    $self->render('root/index');

  #    my $car        = $self->param('car');
  #    my @files = map {
  #        $self->stash->{config}->{setupdir} . '/' . $self->param('car') . $_;
  #    } $self->param('file_selected');
  #    my @setups;
  #    push @setups, IRacing::Setup->new($_) foreach @files;
  #    my $graph_data = {};
  #    foreach my $graph_name ( Mose::Analysis::Graph::available_graph($car) ) {
  #        $graph_data->{$graph_name} = $self->render_to_string(
  #            json    => Mose::Analysis::Graph::data( $graph_name, @setups ),
  #        );
  #    }
  #    $self->render(
  #        "analysis/analysis/$car",
  #        car        => $car,
  #        graph_data => $graph_data,
  #		setups     => \@setups
  #    );
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
