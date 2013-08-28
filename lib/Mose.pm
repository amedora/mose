# vim:set sw=4 ts=4 ft=perl:
package Mose;
use Mojo::Base 'Mojolicious';
use File::Basename;
use File::Spec::Functions qw/catdir/;
use FindBin;

use Mose::Util::LaptimeFile;

our $VERSION = '0.2';

sub production_mode {
    my $log = "$FindBin::Bin/mose.log";
    -f $log && unlink $log;
    shift->log->path($log);
}

sub startup {
    my $self = shift;

    $self->secret('mose');

    my $config =
      $self->plugin( 'Config', { file => "$FindBin::Bin/mose.ini" } );
    $self->home->parse( catdir( dirname(__FILE__), 'Mose' ) );
    $self->static->paths->[0]   = $self->home->rel_dir('public');
    $self->renderer->paths->[0] = $self->home->rel_dir('templates');

    #
    # Helpers
    $self->plugin('Mose::Helper');
    #
    # Routes
    my $r = $self->routes;
    $r->get('/')->to('analysis#index');

    $r->get('/ajax/setuplist/:car')->to('root#setuplist');

    # Analysis
    $r->get('/analysis')->to('analysis#index');
    $r->get('/analysis/analysis/:car')->to('analysis#analysis');
    $r->get('/analysis/datatable')->to('analysis#datatable');

    # Render
    $r->get('/render/laptime/:car')->to('render#laptime');

    # Laptime
    $r->get('/laptime/manager/:car')->to('laptime#manager');
    $r->get('/laptime/list')->to('laptime#list');

    # Laptime gather
    $r->post('/laptime/importer/prepare')->to('laptime-importer#prepare');
    $r->get('/laptime/importer/import')->to('laptime-importer#import');
}

1;
