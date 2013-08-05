# vim:set sw=4 ts=4 ft=perl:
package Mose::Util::LaptimeFile;
use File::Basename 'fileparse';
use File::Spec::Functions qw/catdir/;
use File::Path 'make_path';
use List::Util qw/minstr sum/;
use YAML;

use Mose::Util qw/laptime_in_milisec/;

sub new {
    my $proto = shift;
    my $class = ref $proto || $proto;
    my $self  = ref $_[0] eq 'HASH' ? $_[0] : {@_};

    return bless $self, $class;
}

sub basedir {
    my $self = shift;
    $self->{basedir} = $_[0] if $_[0];
    return $self->{basedir};
}

sub save_record {
    my $self = shift;
    my $arg  = {@_};
    my @new_laptimes = @{ $arg->{laptime} };
    my $record       = {};

    # Clear 'mark' on previous records.
    if ( -f $self->_filename ) {
        $record = YAML::LoadFile( $self->_filename );
        $_->{mark} = 0 foreach ( values %$record );
    }
    my $average =
      int( sum( map { laptime_in_milisec($_) } @new_laptimes ) /
          ( $#new_laptimes + 1 ) );
    my $minutes = sprintf "%02d", int( $average / 60000 );    # 1000(ms) * 60(s)
    $average -= $minutes * 60000;
    my $seconds = $average / 1000;

    # save them!
    $record->{ $arg->{subsessionid} } = {
        laptime => [@new_laptimes],
        fastest => minstr( map { $_ . "" } @new_laptimes ),
        average => "$minutes:$seconds",
        url     => $arg->{url},
        mark    => 1,
    };
    my $dir = ( fileparse( $self->_filename ) )[1];
    make_path($dir) unless -d $dir;
    YAML::DumpFile( $self->_filename, $record );
    return 1;
}

sub _filename {
    my $self = shift;
    my $filename = catdir( $self->{basedir}, $self->{car}, $self->{setup} . '.laps' );
	#$filename =~ s/\.htm$/.laps/;
    return $filename;
}

1;
