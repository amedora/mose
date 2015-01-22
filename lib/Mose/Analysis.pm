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
    foreach my $i ( 0 .. 4 ) {
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
    my $sheetdata = [ [ 'Category', 'Section', 'Component' ] ];
    foreach my $setup (@setups) {
        push @{ $sheetdata->[0] }, $setup->file_name;
    }

    for ( my $i_setup = 0 ; $i_setup <= $#setups ; $i_setup++ ) {
        for ( my $i_row = 0 ; $i_row < $setups[$i_setup]->num_rows ; $i_row++ )
        {
            if ( $i_setup == 0 ) {
                push @{$sheetdata}, $setups[$i_setup]->data->[$i_row];
            }
            else {
                # Remember, the first row is a column header.
                push @{ $sheetdata->[ $i_row + 1 ] },
                  $setups[$i_setup]->data->[$i_row]->[3];
            }
        }
    }

    my $graphhtml = $c->_generate_graphhtml(@setups);
    unless ($graphhtml) {
        return $c->render(
            json => {
                error => {
                    message => "Can't anayze your setup.",
                    code    => 400,
                },
            },

            #status => 400,
        );
    }

    $c->render( json =>
          { data => { sheetdata => $sheetdata, graphhtml => $graphhtml } } );
}

sub analyze_from_db {
    my $self = shift;
}

sub _generate_graphhtml {
    my $c      = shift;
    my @setups = @_;

    my $car        = $setups[0]->car_name;
    my $graph_data = {};
    foreach my $graph_name ( Mose::Analysis::Graph::available_graph($car) ) {
        $graph_data->{$graph_name} = $c->render_to_string(
            json => Mose::Analysis::Graph::data( $graph_name, @setups ), );
    }

    return $c->render_to_string(
        "analysis/analysis/$car",
        graph_data => $graph_data,
        setups     => \@setups
    );
}

1;
