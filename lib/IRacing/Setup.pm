# vim: set ts=4 sw=4:
package IRacing::Setup;

use File::Basename qw/basename/;
use IRacing::Setup::Parser;

my $Cache = {};

sub new {
    my ( $class, $file ) = @_;
	my $f = basename($file);
	return $Cache->{$f} if $Cache->{$f};
    my $self = {
        car_name  => '',
        file_name => $f,
        data      => [],
        data_hash => {},
        parser    => IRacing::Setup::Parser->new($file),
    };
    bless $self, $class;

    $self->_parse();
    $self->_make_data_hash();
	$Cache->{$f} = $self;
    return $self;
}

sub _parse {
    my $self = shift;
    $self->{car_name} = $self->{parser}->car_name;
    $self->{data}     = $self->{parser}->data;
}

sub _make_data_hash {
    my $self = shift;
    foreach my $i ( @{ $self->{data} } ) {
        $self->{data_hash}->{ $i->[0] . $i->[1] . $i->[2] } = $i->[3];
    }
}

sub car_name {
    my $self = shift;
    return $self->{car_name};
}

sub file_name {
    my $self = shift;
    return $self->{file_name};
}

sub data {
    my $self = shift;

    my $arg = ref $_[0] eq 'HASH' ? $_[0] : {@_};

    # return all data if no component specified.
    return $self->{data} unless $arg->{component};

    my @c     = @{ $arg->{component} };
    my $value = $self->{data_hash}->{ $c[0] . $c[1] . $c[2] };

    return "not available" unless $value;

    if ( $value =~ m/(top|midle|bottom)/ ) {
        return $value;
    }

    $arg->{unit} = 0 unless defined( $arg->{unit} );
    if ( $arg->{unit} == 0 ) {
        $value =~ m/(-?[^a-zA-Z\s]+)/;
        return $1 + 0;
    }
    else {
        return $value;
    }
}

1;
