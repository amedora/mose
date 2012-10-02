# vim:set sw=4 ts=4 ft=perl:
package Mose;
use Mojo::Base 'Mojolicious';

sub startup {
	my $self = shift;

	$self->secret('mose');
	plugin Config => { file => 'mose.conf' };

	my $r = $self->routes;
	# TODO: define routes here
}

get '/' => sub {
    my $self = shift;

    #$self->render('index');
    $self->redirect_to('analysis/latemodel');
};

1;
