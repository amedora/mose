# vim:set sw=4 ts=4 ft=perl:
package Mose::Laptime::Importer;
use Mojo::Base 'Mojolicious::Controller';

use Mojo::DOM;

sub prepare {
    my $self = shift;
    my $dom  = Mojo::DOM->new( $self->param('pagecontent') );

    # Retrieve subsessionid
    $dom->find('table')->[0]->find('div')->[3]->text =~ m!/(\d+)!;
    $self->stash->{subsessionid} = $1;

    # Retrieve laptimes
    my $skip_count = 2;
    my @laptimes;
    for my $l ( $dom->find('table')->[1]->find('tr')->each ) {
        if ( $skip_count > 0 ) {
            $skip_count--;
            next;
        }
        push @laptimes,
          {
            lap  => $l->td->[0]->text,
            time => $l->td->[1]->text,
            inc  => $l->td->[2]->text,
          };
    }
    $self->stash->{laptimes} = \@laptimes;
}

sub import {
    my $self = shift;

}

1;
