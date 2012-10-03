# vim:set sw=4 ts=4 ft=perl:
package Mose::Root;
use Mojo::Base 'Mojolicious::Controller';

sub index {
    my $self = shift;

    # XXX: show latemodel setting as default
    $self->redirect_to('analysis/latemodel');
}

1;
