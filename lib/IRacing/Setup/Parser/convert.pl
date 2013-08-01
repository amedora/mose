use YAML qw/LoadFile DumpFile/;
use Data::Dumper;
my $new = [];

my $orig = YAML::LoadFile('stockcars fordfusion.yaml');
print Dumper $orig;
__DATA__
foreach my $k ( keys %$orig ) {
    foreach my $v ( keys %{ $orig->{$k} } ) {
        foreach my $l ( keys %{ $orig->{$k}->{$v} } ) {
            foreach my $m ( keys %{ $orig->{$k}->{$v}->{$l} } ) {
                push @$new,
                  [
                    $k,
                    $v,
                    $l,
                    $orig->{$k}->{$v}->{$l}->{$m},
                  ];

                #printf "%s\t%s\t%s\t%s\t%s\n",
                #$k, $v, $l, $m, $orig->{$k}->{$v}->{$l}->{$m};
            }
        }
    }
}
DumpFile('new.yaml', $new);
#print Dumper $new;
