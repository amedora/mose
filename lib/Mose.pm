# vim:set sw=4 ts=4 ft=perl:
package Mose;
use Mojo::Base 'Mojolicious';
use File::Basename;
use File::Find::Rule;
use File::Spec::Functions qw/catdir rel2abs/;
use FindBin;

use Mose::Util qw/graph_list/;
use Mose::Util::LaptimeFile;

our $VERSION = '1.0';

sub startup {
    my $self = shift;

    $self->secret('mose');

    my $config =
      $self->plugin( 'Config', { file => "$FindBin::Bin/mose.conf" } );

    $self->home->parse( catdir( dirname(__FILE__), 'Mose' ) );
    $self->static->paths->[0]   = $self->home->rel_dir('public');
    $self->renderer->paths->[0] = $self->home->rel_dir('templates');

    #
    # Helpers
    $self->helper(
        setups => sub {
            my $self           = shift;
            my $car            = shift;
            my $search_basedir = catdir( $config->{setupdir}, $car );
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
    );
    $self->helper(
        laptimefile => sub {
            my $self = shift;
            my $arg  = {@_};
            $arg->{basedir} =
              rel2abs( catdir( dirname(__FILE__), '..\laptime' ) );
            my $laptimefile = Mose::Util::LaptimeFile->new($arg);
            return $laptimefile;
        }
    );
	$self->helper(
		graph_list => sub {
			my $self = shift;
			my $car = shift;
			return graph_list($car);
		}
	);
    #
    # Routes
    my $r = $self->routes;
    $r->get('/')->to('analysis#index');

    $r->get('/ajax/setuplist/:car')->to('root#setuplist');

    # Analysis
    $r->get('/analysis')->to('analysis#index');
    $r->get('/analysis/datatable')->to('analysis#datatable');

    # Render
    $r->get('/render/graphindex/:car')->to('render#graphindex');
    $r->get('/render/graph/:graph_type/:car')->to('render#graph');
    $r->get('/render/laptime/:car')->to('render#laptime');

    # Laptime
    $r->get('/laptime/manager/:car')->to('laptime#manager');
    $r->get('/laptime/list')->to('laptime#list');

    # Laptime gather
    $r->post('/laptime/importer/prepare')->to('laptime-importer#prepare');
    $r->get('/laptime/importer/import')->to('laptime-importer#import');
}

1;
