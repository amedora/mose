# vim: set ts=4 sw=4:
package IRacing::Setup;

use File::Basename qw/basename/;
use IRacing::Setup::Parser;

my $Cache = {};

sub new {
    my ( $class, $file_content ) = @_;
    my $self = {
        car_name  => '',
        file_name => '',
        data      => [],
        parser    => IRacing::Setup::Parser->new($file_content),
    };
    bless $self, $class;

    $self->_parse();
    $self->_analyze();
    return $self;
}

sub _parse {
    my $self = shift;
    $self->{car_name} = $self->{parser}->car_name;
    $self->{file_name} = $self->{parser}->file_name;
    $self->{data}     = $self->{parser}->data;
    $self->{unit}     = $self->_get_unit;
}

sub _analyze {
    my $self = shift;
    my @analyzed_data;
    my %temp;
    my %avgtemp;
    #
    # Tire temps

    foreach
      my $tire ( ( 'LEFT FRONT', 'RIGHT FRONT', 'LEFT REAR', 'RIGHT REAR' ) )
    {
        $temp{$tire} = int(
            (
                $self->data(
                    component => [ 'TIRE' => $tire => 'Last temps I' ]
                  ) + $self->data(
                    component => [ 'TIRE' => $tire => 'Last temps M' ]
                  ) + $self->data(
                    component => [ 'TIRE' => $tire => 'Last temps O' ]
                  )
            ) / 3
        );
        push @analyzed_data,
          [ 'ANALYSIS', 'Avg. temps', $tire, $temp{$tire} . 'F' ];
    }

    foreach my $side ( ( 'LEFT', 'RIGHT' ) ) {
        my $avgtemp = int(
            ( ( $temp{ $side . ' FRONT' } + $temp{ $side . ' REAR' } ) ) / 2 );
        push @analyzed_data,
          [ 'ANALYSIS', 'Avg. temps', $side . ' SIDE', $avgtemp . 'F' ];
    }
    #
    # available shock/spring travel
    # only for Top3 NASCAR cars
    if ( $self->car_name =~ /stockcars|silverado/ ) {
        foreach my $side ( ( 'LEFT', 'RIGHT' ) ) {
            my $travel =
              $self->data( component =>
                  [ 'CHASSIS' => "$side FRONT" => 'Shock deflection (of)' ] ) -
              $self->data( component =>
                  [ 'CHASSIS' => "$side FRONT" => 'Shock deflection' ] );
            push @analyzed_data,
              [
                'ANALYSIS',       'Available shock travel',
                $side . ' FRONT', $travel
              ];
        }
        foreach my $side ( ( 'LEFT', 'RIGHT' ) ) {
            my $travel =
              $self->data( component =>
                  [ 'CHASSIS' => "$side FRONT" => 'Spring deflection (of)' ] )
              - $self->data( component =>
                  [ 'CHASSIS' => "$side FRONT" => 'Spring deflection' ] );
            push @analyzed_data,
              [
                'ANALYSIS',       'Available spring travel',
                $side . ' FRONT', $travel
              ];
        }
    }
    unshift @{ $self->{data} }, @analyzed_data;
}

sub _get_unit {
    my $self = shift;

    # All cars should have left front tire.
    my $pressure = $self->data(
        component => [ 'TIRE' => 'LEFT FRONT' => 'Cold pressure' ],
        unit      => 1
    );
    if ( $pressure =~ /psi/ ) {
        $self->{unit} = 'ENGLISH';
    }
    else {
        $self->{unit} = 'METRIC';
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

sub unit {
    my $self = shift;
    return $self->{unit};
}

sub data {
    my $self = shift;

    my $arg = ref $_[0] eq 'HASH' ? $_[0] : {@_};

    # return all data if no component specified.
    return $self->{data} unless $arg->{component};

    my @d = grep {
             $_->[0] eq $arg->{component}->[0]
          && $_->[1] eq $arg->{component}->[1]
          && $_->[2] eq $arg->{component}->[2]
    } @{ $self->{data} };
    my $value = $d[0]->[3];

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

sub is_same_cars {
	my @setups = @_;

	for (@setups) {
		return 0 if ref $_ ne 'IRacing::Setup';
	}

	return 0 unless my $car_name = $setups[0]->car_name;
	return 0 unless my $unit = $setups[0]->unit;

	foreach my $setup (@setups) {
		return 0 unless $car_name eq $setup->car_name;
		return 0 unless $unit eq $setup->unit;
	}
	
	return 1;
}

1;
