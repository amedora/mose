# vim:set sw=4 ts=4 ft=perl:
package Mose;
use Mojo::Base 'Mojolicious';
use File::Basename;
use File::Spec::Functions qw/catdir/;
use FindBin;

our $VERSION = '0.2';

sub startup {
    my $self = shift;

    $self->secrets( ['mose'] );

    #
    # Helpers
    $self->plugin('Mose::Helper');
    #
    # Routes
    my $r = $self->routes;
    $r->get('/')->to('root#index');

    $r->get('/ajax/setuplist/:car')->to('root#setuplist');

    # Analysis
	#$r->get('/analysis')->to('analysis#index');
    $r->get('/analysis/analysis/:car')->to('analysis#analysis');
    $r->get('/analysis/datatable')->to('analysis#datatable');
}

1;
