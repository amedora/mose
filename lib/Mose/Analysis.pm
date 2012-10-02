# vim:set sw=4 ts=4 ft=perl:
package Mose::Analysis;
use Mojo::Base 'Mojolicious::Controller';

get '/analysis/:car' => sub {
    my $self      = shift;
    my $car       = $self->param('car');
    my $searchdir = $self->stash('config')->{setupdir} . '/' . $car;
    my @files     = File::Find::Rule->file()->name('*.htm')->in($searchdir);
    my @setups    = map {
        my $fullpath = $_;
        my ( $filename, $dir ) = fileparse($fullpath);
        $dir =~ s/.*?$car//;
        +{
            filename => $filename,
            dir      => $dir,
            fullpath => $fullpath
        };
    } @files;

    $self->render( 'analysis', setups => \@setups, car => $car );
};

1;
