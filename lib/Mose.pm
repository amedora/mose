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
    $self->helper(
        psession => sub {
            my $self = shift;
            my $env  = $self->req->env;
            return $env->{'psgix.session'};
        }
    );
    #
    # Routes
    my $r = $self->routes;
    $r->get('/')->to('root#index');

	#
    # Analysis
    $r->post('/analyze')->to('analysis#analyze_from_file');
    $r->get('/analyze/:id')->to('analysis#analyze_from_db');
    $r->get('/datasheet')->to('analysis#datasheet');
    $r->get('/graph')->to('analysis#graph');
}

1;
