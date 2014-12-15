# vim:set sw=4 ts=4 ft=perl:
package Mose;
use Mojo::Base 'Mojolicious';

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

    # Analysis
    $r->post('/analysis/analysis')->to('analysis#analyze');
    $r->get('/analysis/datatable')->to('analysis#datatable');
}

1;
