# vim:set sw=4 ts=4 ft=perl:
package Mose::Util::LaptimeFile;
use File::Spec::Functions qw/catdir/;
use List::Util qw/minstr sum/;
use YAML;

use Mose::Util qw/laptime_in_milisec/;
use Data::Dumper;

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
    print Dumper $arg;
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
    YAML::DumpFile( $self->_filename, $record );
    return 1;
}

sub _filename {
    my $self = shift;
    my $filename = catdir( $self->{basedir}, $self->{car}, $self->{setup} );
    $filename =~ s/\.htm$/.laps/;
    return $filename;
}

1;
