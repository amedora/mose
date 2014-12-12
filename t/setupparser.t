use Test::More;
use FindBin qw/$Bin/;
use File::Spec;
BEGIN { use_ok('IRacing::Setup'); }

use strict;
my $f = File::Spec->catfile( $Bin, 'dover_fixed.htm' );
open my $fh, '<', $f or die "Can't open file $f: $!";
my $content = do {local $/; <$fh>};
close $fh;
my $s = IRacing::Setup->new($content);
ok( $s, 'loading setup file' );
is( $s->car_name,  'stockcars fordfusion', 'car name that setup file has' );
is( $s->file_name, 'dover_fixed.htm',      'file name that setup file has' );
is(
    $s->data(
        component => [ 'CHASSIS' => 'FRONT' => 'Front brake bias' ],
	unit => 1
    ),
    '71.0%',
    'Front brake bias'
);
is(
    $s->data(
        component => [ 'CHASSIS', 'FRONT', 'Front brake bias' ],
    ),
    '71',
    'Front brake bias without unit'
);
is($s->unit, 'ENGLISH', 'the setup has English unit');
done_testing();

