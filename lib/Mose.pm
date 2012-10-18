# vim:set sw=4 ts=4 ft=perl:
package Mose;
use Mojo::Base 'Mojolicious';
use File::Basename 'dirname';
use File::Spec::Functions 'catdir';
use FindBin;

our $VERSION = '1.0';

sub startup {
    my $self = shift;

    $self->secret('mose');

    $self->plugin( 'Config', { file => "$FindBin::Bin/mose.conf" } );

    $self->home->parse( catdir( dirname(__FILE__), 'Mose' ) );
    $self->static->paths->[0]   = $self->home->rel_dir('public');
    $self->renderer->paths->[0] = $self->home->rel_dir('templates');

    my $r = $self->routes;
    $r->get('/')->to('root#index');

    # Analysis
    $r->get('/analysis/home/:car')->to('analysis#home');
	$r->get('/analysis/datatable')->to('analysis#datatable');

	# Render
	$r->get('/render/graph/:graph_type/:car')->to('render#graph');
	$r->get('/render/laptime/:car')->to('render#laptime');
}

1;
