# vim: set ts=4 sw=4:
package IRacing::Setup::Parser;
use File::Spec;
use HTML::TreeBuilder;
use Web::Scraper;
use YAML;

my $_setup_components = YAML::Load(
    do { local $/; <DATA> }
);

my $_setups = {};

sub new {
    my ( $class, $file ) = @_;

    my $self = {
        car_name  => '',
        file_name => '',
        tb        => {},
        scraper   => {},
        data      => [],
    };
    bless $self, $class;

    open my $fh, '<', $file or die "Can't open file: $!";
    my $content = do { local $/; <$fh> };
    close $fh;

    $self->_build_treebuilder($content);
    $self->_build_scraper();
    $self->_scrape();

	#$self->_analyze();
    return $self;
}

sub _build_treebuilder {
    my $self = shift;

    my $tb = HTML::TreeBuilder->new;
    $tb->ignore_unknown(0);
    $tb->parse( $_[0] );
    $tb->eof;
    $self->{tb} = $tb;
}

sub _build_scraper {
    my $self = shift;

    $self->{scraper} = scraper {

        # car name and setup file name
        process "/html/body/h2[1]", car => sub {
            my $elem = shift;
            my $text = $elem->as_trimmed_text;
            $text =~
              /iRacing\.com Motorsport Simulations (.*) setup:\s?(.*)track:/m;
            $self->{car_name} = $1;
            $self->{file_name} = $2 if $2;
        };

        # setup file name for some other cars
        # Silverado, Nationwide COT and others has a file name with brackets.
        process "/html/body/h2[1]/*[last()]", setup => sub {
            my $text = shift->tag;
            $self->{file_name} = $text if $text ne 'br';
        };

        my $yaml;
        foreach my $d (@INC) {
            $yaml = File::Spec->catfile(
                $d,
                qw/IRacing Setup Parser/,
                $self->{car_name} . '.yaml'
            );
            last if -f $yaml;
            $yaml = undef;
        }

        unless ($yaml) {
            die "Can't find a setup component list for $self->{car_name}: $!";
        }

        foreach my $l ( @{ YAML::LoadFile($yaml) } ) {
            process $l->[3], component => sub {
                push @{ $self->{data} },
                  [ $l->[0], $l->[1], $l->[2], shift->as_trimmed_text ];
            };
        }
    };
}

sub _scrape {
    my $self = shift;

	$self->{scraper}->scrape($self->{tb}->elementify);
}

=pod
sub categories {
    my $self = shift;
    return keys %{ $self->{data} };
}

sub sections {
    my $self = shift;
    my $c    = shift;
    return keys %{ $self->{data}->{$c} };
}

sub components {
    my $self = shift;
    my ( $c, $s ) = @_;
    return keys %{ $self->{data}->{$c}->{$s} };
}
=cut

sub data {
    my $self = shift;
	return $self->{data};
}


sub car_name {
    my $self = shift;
    return $self->{car_name};
}

sub file_name {
    my $self = shift;
    return $self->{file_name};
}
__DATA__
---
TIRE:
  LEFT FRONT:
    Cold pressure:
      latemodel: '/html/body/u[1]'
      trucks silverado: '/html/body/u[1]'
      stockcars2 chevy cot: '/html/body/u[1]'
    Last hot pressure:
      latemodel: '/html/body/u[2]'
      trucks silverado: '/html/body/u[2]'
      stockcars2 chevy cot: '/html/body/u[2]'
    Last temps O:
      latemodel: '/html/body/u[3]'
      trucks silverado: '/html/body/u[3]'
      stockcars2 chevy cot: '/html/body/u[3]'
    Last temps M:
      latemodel: '/html/body/u[4]'
      trucks silverado: '/html/body/u[4]'
      stockcars2 chevy cot: '/html/body/u[4]'
    Last temps I:
      latemodel: '/html/body/u[5]'
      trucks silverado: '/html/body/u[5]'
      stockcars2 chevy cot: '/html/body/u[5]'
    Tread remaining O:
      latemodel: '/html/body/u[6]'
      trucks silverado: '/html/body/u[6]'
      stockcars2 chevy cot: '/html/body/u[6]'
    Tread remaining M:
      latemodel: '/html/body/u[7]'
      trucks silverado: '/html/body/u[7]'
      stockcars2 chevy cot: '/html/body/u[7]'
    Tread remaining I:
      latemodel: '/html/body/u[8]'
      trucks silverado: '/html/body/u[8]'
      stockcars2 chevy cot: '/html/body/u[8]'
  LEFT REAR:
    Cold pressure:
      latemodel: '/html/body/u[9]'
      trucks silverado: '/html/body/u[9]'
      stockcars2 chevy cot: '/html/body/u[9]'
    Last hot pressure:
      latemodel: '/html/body/u[10]'
      trucks silverado: '/html/body/u[10]'
      stockcars2 chevy cot: '/html/body/u[10]'
    Last temps O:
      latemodel: '/html/body/u[11]'
      trucks silverado: '/html/body/u[11]'
      stockcars2 chevy cot: '/html/body/u[11]'
    Last temps M:
      latemodel: '/html/body/u[12]'
      trucks silverado: '/html/body/u[12]'
      stockcars2 chevy cot: '/html/body/u[12]'
    Last temps I:
      latemodel: '/html/body/u[13]'
      trucks silverado: '/html/body/u[13]'
      stockcars2 chevy cot: '/html/body/u[13]'
    Tread remaining O:
      latemodel: '/html/body/u[14]'
      trucks silverado: '/html/body/u[14]'
      stockcars2 chevy cot: '/html/body/u[14]'
    Tread remaining M:
      latemodel: '/html/body/u[15]'
      trucks silverado: '/html/body/u[15]'
      stockcars2 chevy cot: '/html/body/u[15]'
    Tread remaining I:
      latemodel: '/html/body/u[16]'
      trucks silverado: '/html/body/u[16]'
      stockcars2 chevy cot: '/html/body/u[16]'
  RIGHT FRONT:
    Cold pressure:
      latemodel: '/html/body/u[17]'
      trucks silverado: '/html/body/u[17]'
      stockcars2 chevy cot: '/html/body/u[17]'
    Last hot pressure:
      latemodel: '/html/body/u[18]'
      trucks silverado: '/html/body/u[18]'
      stockcars18 chevy cot: '/html/body/u[18]'
    Last temps O:
      latemodel: '/html/body/u[19]'
      trucks silverado: '/html/body/u[19]'
      stockcars2 chevy cot: '/html/body/u[19]'
    Last temps M:
      latemodel: '/html/body/u[20]'
      trucks silverado: '/html/body/u[20]'
      stockcars2 chevy cot: '/html/body/u[20]'
    Last temps I:
      latemodel: '/html/body/u[21]'
      trucks silverado: '/html/body/u[21]'
      stockcars2 chevy cot: '/html/body/u[21]'
    Tread remaining O:
      latemodel: '/html/body/u[22]'
      trucks silverado: '/html/body/u[22]'
      stockcars2 chevy cot: '/html/body/u[22]'
    Tread remaining M:
      latemodel: '/html/body/u[23]'
      trucks silverado: '/html/body/u[23]'
      stockcars2 chevy cot: '/html/body/u[23]'
    Tread remaining I:
      latemodel: '/html/body/u[24]'
      trucks silverado: '/html/body/u[24]'
      stockcars2 chevy cot: '/html/body/u[24]'
    Stagger:
      latemodel: '/html/body/u[25]'
  RIGHT REAR:
    Cold pressure:
      latemodel: '/html/body/u[26]'
      trucks silverado: '/html/body/u[25]'
      stockcars2 chevy cot: '/html/body/u[25]'
    Last hot pressure:
      latemodel: '/html/body/u[27]'
      trucks silverado: '/html/body/u[26]'
      stockcars2 chevy cot: '/html/body/u[26]'
    Last temps O:
      latemodel: '/html/body/u[28]'
      trucks silverado: '/html/body/u[27]'
      stockcars2 chevy cot: '/html/body/u[27]'
    Last temps M:
      latemodel: '/html/body/u[29]'
      trucks silverado: '/html/body/u[28]'
      stockcars2 chevy cot: '/html/body/u[28]'
    Last temps I:
      latemodel: '/html/body/u[30]'
      trucks silverado: '/html/body/u[29]'
      stockcars2 chevy cot: '/html/body/u[29]'
    Tread remaining O:
      latemodel: '/html/body/u[31]'
      trucks silverado: '/html/body/u[30]'
      stockcars2 chevy cot: '/html/body/u[30]'
    Tread remaining M:
      latemodel: '/html/body/u[32]'
      trucks silverado: '/html/body/u[31]'
      stockcars2 chevy cot: '/html/body/u[31]'
    Tread remaining I:
      latemodel: '/html/body/u[33]'
      trucks silverado: '/html/body/u[32]'
      stockcars2 chevy cot: '/html/body/u[32]'
    Stagger:
      latemodel: '/html/body/u[34]'
CHASSIS:
  FRONT:
    Ballast forward:
      latemodel: '/html/body/u[35]'
      trucks silverado: '/html/body/u[33]'
      stockcars2 chevy cot: '/html/body/u[33]'
    Nose weight:
      latemodel: '/html/body/u[36]'
      trucks silverado: '/html/body/u[34]'
      stockcars2 chevy cot: '/html/body/u[34]'
    Cross weight:
      latemodel: '/html/body/u[37]'
    Toe-in:
      latemodel: '/html/body/u[38]'
    Steering ratio:
      latemodel: '/html/body/u[39]'
    Front brake bias:
      latemodel: '/html/body/u[40]'
    Sway bar size:
      latemodel: '/html/body/u[41]'
    Sway bar arm length:
      latemodel: '/html/body/u[42]'
    Left bar end clearance:
      latemodel: '/html/body/u[43]'
    Attach left side:
      latemodel: '/html/body/u[44]'
    Tape Configuration:
      latemodel: '/html/body/u[45]'
  LEFT FRONT:
    Corner weight:
      latemodel: '/html/body/u[46]'
    Ride height:
      latemodel: '/html/body/u[47]'
    Shock deflection:
    Shock deflection (of):
    Spring deflection:
    Spring deflection (of):
    Shock collar offset:
      latemodel: '/html/body/u[48]'
    Spring perch offset:
    Spring rate:
      latemodel: '/html/body/u[49]'
    Bumpstop:
    Packer:
    Bump stiffness:
      latemodel: '/html/body/u[50]'
    Rebound stiffness:
      latemodel: '/html/body/u[51]'
    Camber:
      latemodel: '/html/body/u[52]'
    Caster:
      latemodel: '/html/body/u[53]'
    Toe-in:
  LEFT REAR:
    Corner weight:
      latemodel: '/html/body/u[54]'
    Ride height:
      latemodel: '/html/body/u[55]'
    Shock deflection:
    Shock deflection (of):
    Spring deflection:
    Spring deflection (of):
    Shock collar offset:
      latemodel: '/html/body/u[56]'
    Spring perch offset:
    Spring rate:
      latemodel: '/html/body/u[57]'
    Bump stiffness:
      latemodel: '/html/body/u[58]'
    Rebound stiffness:
      latemodel: '/html/body/u[59]'
    Camber:
    Toe-in:
    Track bar height:
      latemodel: '/html/body/u[60]'
    Truck arm mount:
      latemodel: '/html/body/u[61]'
  FRONT ARB:
    Diameter:
    Arm asynmetry:
    Preload:
    Attach:
  RIGHT FRONT:
    Corner weight:
      latemodel: '/html/body/u[62]'
    Ride height:
      latemodel: '/html/body/u[63]'
    Shock deflection:
    Shock deflection (of):
    Spring deflection:
    Spring deflection (of):
    Shock collar offset:
      latemodel: '/html/body/u[64]'
    Spring perch offset:
    Spring rate:
      latemodel: '/html/body/u[65]'
    Bumpstop:
    Packer:
    Bump stiffness:
      latemodel: '/html/body/u[66]'
    Rebound stiffness:
      latemodel: '/html/body/u[67]'
    Camber:
      latemodel: '/html/body/u[68]'
    Caster:
      latemodel: '/html/body/u[69]'
    Toe-in:
  RIGHT REAR:
    Corner weight:
      latemodel: '/html/body/u[70]'
    Ride height:
      latemodel: '/html/body/u[71]'
    Shock deflection:
    Shock deflection (of):
    Spring deflection:
    Spring deflection (of):
    Shock collar offset:
      latemodel: '/html/body/u[72]'
    Spring perch offset:
    Spring rate:
      latemodel: '/html/body/u[73]'
    Bump stiffness:
      latemodel: '/html/body/u[74]'
    Rebound stiffness:
      latemodel: '/html/body/u[75]'
    Camber:
    Toe-in:
    Track bar height:
      latemodel: '/html/body/u[76]'
    Truck arm mount:
      latemodel: '/html/body/u[77]'
    Truck arm preload:
      latemodel: '/html/body/u[78]'
  REAR:
    Fuel Fill To:
      latemodel: '/html/body/u[79]'
    Rear end ratio:
      latemodel: '/html/body/u[80]'

