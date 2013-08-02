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
        parser    => IRacing::Setup::Parser->new($file),
    };
    bless $self, $class;

    $self->_parse();
    $self->_analyze();
    $Cache->{$f} = $self;
    return $self;
}

sub _parse {
    my $self = shift;
    $self->{car_name} = $self->{parser}->car_name;
    $self->{data}     = $self->{parser}->data;
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

1;
