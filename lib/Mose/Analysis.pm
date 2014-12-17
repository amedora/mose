# vim:set sw=4 ts=4 ft=perl:
package Mose::Analysis;
use Mojo::Base 'Mojolicious::Controller';
use Mose::Analysis::Graph;
use IRacing::Setup;
use Data::Dumper;

sub analyze_from_file {
    my $c     = shift;
    my @files = ();

    # get content of all files
    foreach my $i ( 0 .. 2 ) {
        if ( my $s = $c->param( "file" . $i ) ) {
            if ( $s->asset->{content} ) {
                push @files, $s;
            }
        }
    }

    return $c->render( 'root/index',
        error_message => "No files are specified." )
      unless @files;

    # convert them to IRacing::Setup
    my @setups;
    foreach my $file (@files) {
        my $setup = IRacing::Setup->new( $file->asset->{content} );
        if ( !$setup ) {
            return $c->render( 'root/index',
                error_message => $file->filename . " is invalid." );
        }
        push @setups, $setup;
    }

    return $c->render( 'root/index',
        error_message => "Not same cars are specified." )
      unless IRacing::Setup::is_same_cars(@setups);

    $c->render('root/index');

}

sub analyze_from_db {
    my $self = shift;
}

sub analyze {
    my $self = shift;

    my @setups;

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
