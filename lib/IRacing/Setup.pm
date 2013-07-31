# vim: set ts=4 sw=4:
package IRacing::Setup;

use File::Basename qw/basename/;
use IRacing::Setup::Parser;

sub new {
    my ( $class, $file ) = @_;

    my $self = {
        car_name  => '',
        file_name => basename($file),
        data      => [],
        parser    => IRacing::Setup::Parser->new($file),
    };
    bless $self, $class;

    $self->_parse();

    return $self;
}

sub _parse {
    my $self = shift;
    $self->{car_name} = $self->{parser}->car_name;
    $self->{data}     = $self->{parser}->data;
}

sub car_name {
    my $self = shift;
	return $self->{car_name};
}

sub data {
    my $self = shift;
	return $self->{data};
}

1;
