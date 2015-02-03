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
              /iRacing\.com Motorsport Simulations (.*) setup:\s?(.*)\strack:/m;
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
