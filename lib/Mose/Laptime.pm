# vim:set sw=4 ts=4 ft=perl:
package Mose::Laptime;
use Mojo::Base 'Mojolicious::Controller';
use File::Basename;
use File::Find::Rule;
use List::Util qw/minstr sum/;
use YAML;

use Mose::Util qw/laptime_in_milisec/;

sub manager {
    my $self      = shift;
    my $car       = $self->param('car');
	$self->session->{car} = $car if $self->session->{car} ne $car;
    my $searchdir = $self->stash('config')->{setupdir} . '/' . $car;
    my @files     = File::Find::Rule->file()->name('*.htm')->in($searchdir);
    my $i;
    my @setups = map {
        my $fullpath = $_;
        my ( $filename, $dir ) = fileparse($fullpath);
        $dir =~ s/.*?$car//;
        +{
            id       => $i++,
            filename => $filename,
            dir      => $dir,
            fullpath => $fullpath
        };
    } @files;

	$self->stash->{setups} = \@setups;
	$self->stash->{car} = $car;
}

sub list {
    my $self   = shift;
    my $record = {};
	$self->session->{file_selected} = $self->param('file_selected');
    my $laptimefile =
        $self->stash('config')->{laptimedir} . '/'
      . $self->param('car') . '/'
      . $self->param('file_selected') . '.yaml';
    $record = YAML::LoadFile($laptimefile) if -f $laptimefile;
    $self->render(
        'laptime/list',
        car    => $self->param('car'),
        record => $record
    );
}

sub importer {
    my $self = shift;
    $self->respond_to(
        js  => { template => 'laptime/importer' },
        any => { text     => '', status => 204 },
    );
}

sub modal {
    my $self = shift;
    $self->res->headers->header( 'Access-Control-Allow-Origin' => '*' );
}

sub autocomplete {
    my $self      = shift;
    my $car       = $self->param('car');
    my $term      = $self->param('term');
    my $searchdir = $self->stash('config')->{setupdir} . '/' . $car;
    my @files = File::Find::Rule->file()->name("*$term*.htm")->in($searchdir);
    my $ret   = [];
    @$ret = map { ( fileparse($_) )[0] } @files;
    $self->res->headers->header( 'Access-Control-Allow-Origin' => '*' );
    $self->render( json => $ret );
}

#XXX: change function name 'import' to another.
sub doimport {
    my $self   = shift;
    my $record = {};
    my $laptimefile =
        $self->stash('config')->{laptimedir} . '/'
      . $self->param('car') . '/'
      . $self->param('setup') . '.yaml';

    # Exctract subsession id
    $self->param('url') =~ /subsessionid=(\d+)/m;
    my $subsessionid = $1;

    # Clear 'mark' if laptimes are recorded already.
    if ( -f $laptimefile ) {
        $record = YAML::LoadFile($laptimefile);
        $_->{mark} = 0 foreach ( values %$record );
    }
    my @lap = $self->param('laptime');
    my $avg =
      int( sum( map { laptime_in_milisec($_) } @lap ) / ( $#lap + 1 ) );
    my $min = sprintf "%02d", int( $avg / 60000 );
    $avg -= $min * 60000;
    my $sec = $avg / 1000;
    $record->{$subsessionid} = {
        laptime => [@lap],
        fastest => minstr( map { $_ . "" } @lap ),
        average => "$min:$sec",
        mark    => 1,
    };
    YAML::DumpFile( $laptimefile, $record );
    $self->render( text => 'finish' );
}

sub savemark {
    my $self   = shift;
	my $record = {};
	my $sid = $self->param('record_selected');
	$self->app->log->debug("SID: $sid");
    my $laptimefile =
        $self->stash('config')->{laptimedir} . '/'
      . $self->session('car') . '/'
      . $self->session('file_selected') . '.yaml';
    if ( -f $laptimefile ) {
        $record = YAML::LoadFile($laptimefile);
        $_->{mark} = 0 foreach ( values %$record );
    } else {
		die "Can't find file $laptimefile.: $!";
	}
	$record->{$sid}->{mark} = 1;
    YAML::DumpFile( $laptimefile, $record );
    $self->render(
        'laptime/list',
        car    => $self->session('car'),
        record => $record
    );
}

1;
