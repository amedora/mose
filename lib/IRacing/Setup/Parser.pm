# vim: set ts=4 sw=4:
package IRacing::Setup::Parser;
use File::Spec;
use HTML::TreeBuilder;
use Web::Scraper;
use YAML;

sub new {
    my ( $class, $content ) = @_;

    my $self = {
        car_name  => '',
        file_name => '',
        tb        => {},
        scraper   => {},
        data      => [],
    };
    bless $self, $class;

    $self->_build_treebuilder($content);
    $self->_build_scraper();
    $self->_scrape();

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
            die "Can't find a setup component list for [$self->{car_name}]: $!";
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

1;
__DATA__
---
TIRE:
  LEFT FRONT:
    Cold pressure:
      trucks silverado: '/html/body/u[1]'
      stockcars2 chevy cot: '/html/body/u[1]'
    Last hot pressure:
      trucks silverado: '/html/body/u[2]'
      stockcars2 chevy cot: '/html/body/u[2]'
    Last temps O:
      trucks silverado: '/html/body/u[3]'
      stockcars2 chevy cot: '/html/body/u[3]'
    Last temps M:
      trucks silverado: '/html/body/u[4]'
      stockcars2 chevy cot: '/html/body/u[4]'
    Last temps I:
      trucks silverado: '/html/body/u[5]'
      stockcars2 chevy cot: '/html/body/u[5]'
    Tread remaining O:
      trucks silverado: '/html/body/u[6]'
      stockcars2 chevy cot: '/html/body/u[6]'
    Tread remaining M:
      trucks silverado: '/html/body/u[7]'
      stockcars2 chevy cot: '/html/body/u[7]'
    Tread remaining I:
      trucks silverado: '/html/body/u[8]'
      stockcars2 chevy cot: '/html/body/u[8]'
  LEFT REAR:
    Cold pressure:
      trucks silverado: '/html/body/u[9]'
      stockcars2 chevy cot: '/html/body/u[9]'
    Last hot pressure:
      trucks silverado: '/html/body/u[10]'
      stockcars2 chevy cot: '/html/body/u[10]'
    Last temps O:
      trucks silverado: '/html/body/u[11]'
      stockcars2 chevy cot: '/html/body/u[11]'
    Last temps M:
      trucks silverado: '/html/body/u[12]'
      stockcars2 chevy cot: '/html/body/u[12]'
    Last temps I:
      trucks silverado: '/html/body/u[13]'
      stockcars2 chevy cot: '/html/body/u[13]'
    Tread remaining O:
      trucks silverado: '/html/body/u[14]'
      stockcars2 chevy cot: '/html/body/u[14]'
    Tread remaining M:
      trucks silverado: '/html/body/u[15]'
      stockcars2 chevy cot: '/html/body/u[15]'
    Tread remaining I:
      trucks silverado: '/html/body/u[16]'
      stockcars2 chevy cot: '/html/body/u[16]'
  RIGHT FRONT:
    Cold pressure:
      trucks silverado: '/html/body/u[17]'
      stockcars2 chevy cot: '/html/body/u[17]'
    Last hot pressure:
      trucks silverado: '/html/body/u[18]'
      stockcars18 chevy cot: '/html/body/u[18]'
    Last temps O:
      trucks silverado: '/html/body/u[19]'
      stockcars2 chevy cot: '/html/body/u[19]'
    Last temps M:
      trucks silverado: '/html/body/u[20]'
      stockcars2 chevy cot: '/html/body/u[20]'
    Last temps I:
      trucks silverado: '/html/body/u[21]'
      stockcars2 chevy cot: '/html/body/u[21]'
    Tread remaining O:
      trucks silverado: '/html/body/u[22]'
      stockcars2 chevy cot: '/html/body/u[22]'
    Tread remaining M:
      trucks silverado: '/html/body/u[23]'
      stockcars2 chevy cot: '/html/body/u[23]'
    Tread remaining I:
      trucks silverado: '/html/body/u[24]'
      stockcars2 chevy cot: '/html/body/u[24]'
  RIGHT REAR:
    Cold pressure:
      trucks silverado: '/html/body/u[25]'
      stockcars2 chevy cot: '/html/body/u[25]'
    Last hot pressure:
      trucks silverado: '/html/body/u[26]'
      stockcars2 chevy cot: '/html/body/u[26]'
    Last temps O:
      trucks silverado: '/html/body/u[27]'
      stockcars2 chevy cot: '/html/body/u[27]'
    Last temps M:
      trucks silverado: '/html/body/u[28]'
      stockcars2 chevy cot: '/html/body/u[28]'
    Last temps I:
      trucks silverado: '/html/body/u[29]'
      stockcars2 chevy cot: '/html/body/u[29]'
    Tread remaining O:
      trucks silverado: '/html/body/u[30]'
      stockcars2 chevy cot: '/html/body/u[30]'
    Tread remaining M:
      trucks silverado: '/html/body/u[31]'
      stockcars2 chevy cot: '/html/body/u[31]'
    Tread remaining I:
      trucks silverado: '/html/body/u[32]'
      stockcars2 chevy cot: '/html/body/u[32]'
CHASSIS:
  FRONT:
    Ballast forward:
      trucks silverado: '/html/body/u[33]'
      stockcars2 chevy cot: '/html/body/u[33]'
    Nose weight:
      trucks silverado: '/html/body/u[34]'
      stockcars2 chevy cot: '/html/body/u[34]'
