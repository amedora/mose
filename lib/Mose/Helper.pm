# vim:set sw=4 ts=4 ft=perl:
package Mose::Helper;
use Mojo::Base 'Mojolicious::Plugin';
use Mose::Util qw/graph_list/;
use File::Basename;
use File::Find::Rule;
use File::Spec::Functions qw/catdir/;

sub register {
    my ( $self, $app ) = @_;

    $app->helper( setups      => \&_setups );
    $app->helper( laptimefile => \&_laptimefile );
    $app->helper( graph_list  => \&_graph_list );
}

sub _setups {
    my $self           = shift;
    my $car            = shift;
    my $search_basedir = catdir( $self->config->{setupdir}, $car );
    my @files =
      File::Find::Rule->file()->name('*.htm')->in($search_basedir);
    my @setups = map {
        my $fullpath = $_;
        my ( $filename, $dir ) = fileparse($fullpath);
        $dir =~ s/.*?$car//;
        +{
            filename => $filename,
            dir      => $dir,
            fullpath => $fullpath
        };
    } @files;
    return \@setups;
}

sub _laptimefile {
    my $self = shift;
    my $arg  = {@_};
    $arg->{basedir} = $self->config->{laptimedir};
    my $laptimefile = Mose::Util::LaptimeFile->new($arg);
    return $laptimefile;
}

sub _graph_list {
    my $self = shift;
    my $car  = shift;
    return graph_list($car);
}

1;
