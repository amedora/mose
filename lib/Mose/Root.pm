# vim:set sw=4 ts=4 ft=perl:
package Mose::Root;
use Mojo::Base 'Mojolicious::Controller';

sub index {
    my $self = shift;

    # XXX: show latemodel setting as default
    $self->redirect_to('analysis/home/latemodel');
}

sub setuplist {
    my $self = shift;

    $self->render(
        'setuplist',
        setups => $self->app->setups( $self->param('car') ),
        st     => $self->param('st')
    );
}

1;
