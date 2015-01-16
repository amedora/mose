# vim:set sw=4 ts=4 ft=perl:
package Mose::Analysis;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON;
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

    return $c->render(
        json => {
            error => {
                message => "No files are specified.",
                code    => 400,
            },
        },

        #status => 400,
    ) unless @files;

    # convert them to IRacing::Setup
    my @setups;
    foreach my $file (@files) {
        my $setup = IRacing::Setup->new( $file->asset->{content} );
        if ( !$setup ) {
            return $c->render(
                json => {
                    error => {
                        message => $file->filename . " is invalid.",
                        code    => 400,
                    }
                },

                #status => 400,
            );
        }
        push @setups, $setup;
    }

    return $c->render(
        json => {
            error => {
                message => "Not same cars are specified.",
                code    => 400,
            },
        },

        #status => 400,
    ) unless IRacing::Setup::is_same_cars(@setups);

    # We have to set the first row as column header.
    my $response = { data => [ [ 'Category', 'Section', 'Component' ] ] };
    foreach my $setup (@setups) {
        push @{ $response->{data}->[0] }, $setup->file_name;
    }

    for ( my $i_setup = 0 ; $i_setup <= $#setups ; $i_setup++ ) {
        for ( my $i_row = 0 ; $i_row < $setups[$i_setup]->num_rows ; $i_row++ )
        {
            if ( $i_setup == 0 ) {
                push @{ $response->{data} }, $setups[$i_setup]->data->[$i_row];
            }
            else {
                # Remember, the first row is a column header.
                push @{ $response->{data}->[ $i_row + 1 ] },
                  $setups[$i_setup]->data->[$i_row]->[3];
            }
        }
    }

    $c->render( json => $response );
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

1;
