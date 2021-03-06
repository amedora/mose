# vim:set sw=4 ts=4 ft=perl:
package Mose::Analysis;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::IOLoop;
use Mojo::JSON;
use Mose::Analysis::Graph;
use IRacing::Setup;

sub analyze_from_file {
    my $c = shift;

    my @files =
      _get_all_contents( $c->param( [qw/file0 file1 file2 file3 file4/] ) );
    return $c->render( json => _error_json('No files are specified') )
      unless @files;

    # convert them to IRacing::Setup
    my @setups;
    foreach my $file (@files) {
        my $setup;
        eval { $setup = IRacing::Setup->new( $file->asset->{content} ); };
        return $c->render(
            json => _error_json( $file->filename . ' is invalid.' ) )
          if $@;
        push @setups, $setup;
    }

    return $c->render(
        json => _error_json('Not same cars or units are specified.') )
      unless IRacing::Setup::is_same_cars(@setups);

    $c->delay(
        sub {
            my $delay    = shift;
            my $cb_sheet = $delay->begin(0);
            my $cb_graph = $delay->begin(0);
            Mojo::IOLoop->timer(
                0 => sub {
                    $cb_sheet->( _generate_sheethtml(@setups) );
                }
            );
            Mojo::IOLoop->timer(
                0 => sub {
                    $cb_graph->( $c->_generate_graphhtml(@setups) );
                }
            );
        },
        sub {
            my $delay = shift;
            my ( $sheet, $graph ) = @_;

            return $c->render(
                json => _error_json("Can't analyze your setup.") )
              unless $graph;

            $c->render( json =>
                  { data => { sheetdata => $sheet, graphhtml => $graph } } );
        },
    );

}

sub analyze_from_db {
    my $self = shift;
}

sub _get_all_contents {
    my @params       = @_;
    my @uploaded_obj = ();

    foreach my $p (@params) {
        last unless ref $p eq 'Mojo::Upload';
        last unless $p->asset->{content};
        push @uploaded_obj, $p;
    }

    return @uploaded_obj;
}

sub _error_json {
    my $errmsg = shift;
    return +{ error => { message => $errmsg, code => 400 } };
}

sub _generate_sheethtml {
    my @setups = @_;

    # We have to set the first row as column header.
    my $sheet = [ [ 'Category', 'Section', 'Component', map {$_->file_name} @setups ] ];

    for ( my $i_setup = 0 ; $i_setup <= $#setups ; $i_setup++ ) {
        for ( my $i_row = 0 ; $i_row < $setups[$i_setup]->num_rows ; $i_row++ )
        {
            if ( $i_setup == 0 ) {
                push @{$sheet}, $setups[$i_setup]->data->[$i_row];
            }
            else {
                # Remember, the first row is a column header.
                push @{ $sheet->[ $i_row + 1 ] },
                  $setups[$i_setup]->data->[$i_row]->[3];
            }
        }
    }

    return $sheet;
}

sub _generate_graphhtml {
    my $c      = shift;
    my @setups = @_;

    my $car        = $setups[0]->car_name;
    my $unit       = $setups[0]->unit;
    my $graph_data = {};
    foreach my $graph_name ( Mose::Analysis::Graph::available_graph($car) ) {
        $graph_data->{$graph_name} = $c->render_to_string(
            json => Mose::Analysis::Graph::data( $graph_name, @setups ), );
    }

    return $c->render_to_string(
        "analysis/car/$car",
        graph_data => $graph_data,
        setups     => \@setups,
        graphopt   => Mose::Analysis::Graph::GraphOption( $car, $unit )
    );
}

1;
