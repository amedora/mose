# vim:set sw=4 ts=4 ft=perl:
package Mose::Root;
use Mojo::Base 'Mojolicious::Controller';

sub index {
	my $self = shift;
}

sub setuplist {
    my $self = shift;

    $self->render(
        'setuplist',
		car    => $self->param('car'),
        setups => $self->app->setupfiles_by_car( $self->param('car') ),
        st     => $self->param('st')
    );
}

1;
