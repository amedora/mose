# vim:set sw=4 ts=4 ft=perl:
package Mose::Root;
use Mojo::Base 'Mojolicious::Controller';

sub setuplist {
    my $self = shift;

    $self->render(
        'setuplist',
        setups => $self->app->setups( $self->param('car') ),
        st     => $self->param('st')
    );
}

1;
