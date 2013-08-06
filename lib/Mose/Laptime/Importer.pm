# vim:set sw=4 ts=4 ft=perl:
package Mose::Laptime::Importer;
use Mojo::Base 'Mojolicious::Controller';

use Mojo::DOM;

sub prepare {
    my $self = shift;
    my $dom  = Mojo::DOM->new( $self->param('pagecontent') );

    # Retrieve original page URL
    $self->stash->{url} = $self->param('url');

    # Retrieve subsessionid
    $dom->find('table')->[0]->find('div')->[3]->text =~ m!/(\d+)!;
    $self->stash->{subsessionid} = $1;

    # Retrieve laptimes
    my $skip_count = 2;    # 0 = table header, 1 = lap 0
    my @laptimes;
    for my $l ( $dom->find('table')->[1]->find('tr')->each ) {
        if ( $skip_count > 0 ) {
            $skip_count--;
            next;
        }
        push @laptimes,
          {
            lap_no  => $l->td->[0]->text,
            laptime => $l->td->[1]->text,
            inc     => $l->td->[2]->text,
          };
    }
    $self->stash->{laptimes} = \@laptimes;
}

sub import {
    my $self = shift;
    my $laptimefile = $self->app->laptimefile(
        car   => $self->param('car'),
        setup => $self->param('setup'),
    );
    my $message;
    if (
        $laptimefile->save_record(
            subsessionid => $self->param('subsessionid'),
            url          => $self->param('url'),
            laptime      => [$self->param('laptime[]')]
        )
      )
    {
        $message = '<p class="text-success lead">Import succeed.</p>';
    }
    else {
        $message = '<p class="text-error lead">Import failed.</p>';
    }

    $self->render( inline => "<div id='importResult'>$message</div>" );
}

1;
