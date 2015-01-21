use Test::More;
use FindBin qw/$Bin/;
use File::Spec;
BEGIN { use_ok('IRacing::Setup'); }

use strict;
my $f = File::Spec->catfile( $Bin, '..', 'setups', 'stockcars toyotacamry',
    'baseline_ENGLISH.htm' );
open my $fh, '<', $f or die "Can't open file $f: $!";
my $content = do { local $/; <$fh> };
close $fh;
my $s = IRacing::Setup->new($content);
ok( $s, 'loading setup file' );
#
# Basic informations
is( $s->car_name,  'stockcars toyotacamry', 'car_name()' );
is( $s->file_name, '<baseline>',      'file_name()' );
is( $s->unit, 'ENGLISH',      'unit()' );

#
# Tires
is ($s->data(component => ['TIRE' => 'LEFT FRONT' => 'Cold pressure'], unit => 1), '35.0 psi', 'TIRE => LEFT FRONT => Cold pressure');
is ($s->data(component => ['TIRE' => 'LEFT REAR' => 'Cold pressure'], unit => 1), '35.0 psi', 'TIRE => LEFT FRONT => Cold pressure');
is ($s->data(component => ['TIRE' => 'RIGHT FRONT' => 'Cold pressure'], unit => 1), '48.5 psi', 'TIRE => LEFT FRONT => Cold pressure');
is ($s->data(component => ['TIRE' => 'RIGHT REAR' => 'Cold pressure'], unit => 1), '48.5 psi', 'TIRE => LEFT FRONT => Cold pressure');

is ($s->data(component => ['TIRE' => 'LEFT FRONT' => 'Last hot pressure'], unit => 1), '37.9 psi', 'TIRE => LEFT FRONT => Last hot pressure');
is ($s->data(component => ['TIRE' => 'LEFT REAR' => 'Last hot pressure'], unit => 1), '37.9 psi', 'TIRE => LEFT REAR => Last hot pressure');
is ($s->data(component => ['TIRE' => 'RIGHT FRONT' => 'Last hot pressure'], unit => 1), '53.6 psi', 'TIRE => RIGHT FRONT => Last hot pressure');
is ($s->data(component => ['TIRE' => 'RIGHT REAR' => 'Last hot pressure'], unit => 1), '53.6 psi', 'TIRE => RIGHT REAR => Last hot pressure');

is ($s->data(component => ['TIRE' => 'LEFT FRONT' => 'Last temps O'], unit => 1), '103F', 'TIRE => LEFT FRONT => Last temps O');
is ($s->data(component => ['TIRE' => 'LEFT FRONT' => 'Last temps M'], unit => 1), '103F', 'TIRE => LEFT FRONT => Last temps M');
is ($s->data(component => ['TIRE' => 'LEFT FRONT' => 'Last temps I'], unit => 1), '103F', 'TIRE => LEFT FRONT => Last temps I');

is ($s->data(component => ['TIRE' => 'LEFT REAR' => 'Last temps O'], unit => 1), '103F', 'TIRE => LEFT REAR => Last temps O');
is ($s->data(component => ['TIRE' => 'LEFT REAR' => 'Last temps M'], unit => 1), '103F', 'TIRE => LEFT REAR => Last temps M');
is ($s->data(component => ['TIRE' => 'LEFT REAR' => 'Last temps I'], unit => 1), '103F', 'TIRE => LEFT REAR => Last temps I');

is ($s->data(component => ['TIRE' => 'RIGHT FRONT' => 'Last temps I'], unit => 1), '103F', 'TIRE => RIGHT FRONT => Last temps I');
is ($s->data(component => ['TIRE' => 'RIGHT FRONT' => 'Last temps M'], unit => 1), '103F', 'TIRE => RIGHT FRONT => Last temps M');
is ($s->data(component => ['TIRE' => 'RIGHT FRONT' => 'Last temps O'], unit => 1), '103F', 'TIRE => RIGHT FRONT => Last temps O');

is ($s->data(component => ['TIRE' => 'RIGHT REAR' => 'Last temps I'], unit => 1), '103F', 'TIRE => RIGHT REAR => Last temps I');
is ($s->data(component => ['TIRE' => 'RIGHT REAR' => 'Last temps M'], unit => 1), '103F', 'TIRE => RIGHT REAR => Last temps M');
is ($s->data(component => ['TIRE' => 'RIGHT REAR' => 'Last temps O'], unit => 1), '103F', 'TIRE => RIGHT REAR => Last temps O');

is ($s->data(component => ['TIRE' => 'LEFT FRONT' => 'Tread remaining O'], unit => 1), '100%', 'TIRE => LEFT FRONT => Tread remaining O');
is ($s->data(component => ['TIRE' => 'LEFT FRONT' => 'Tread remaining M'], unit => 1), '100%', 'TIRE => LEFT FRONT => Tread remaining M');
is ($s->data(component => ['TIRE' => 'LEFT FRONT' => 'Tread remaining I'], unit => 1), '100%', 'TIRE => LEFT FRONT => Tread remaining I');

is ($s->data(component => ['TIRE' => 'LEFT REAR' => 'Tread remaining O'], unit => 1), '100%', 'TIRE => LEFT REAR => Tread remaining O');
is ($s->data(component => ['TIRE' => 'LEFT REAR' => 'Tread remaining M'], unit => 1), '100%', 'TIRE => LEFT REAR => Tread remaining M');
is ($s->data(component => ['TIRE' => 'LEFT REAR' => 'Tread remaining I'], unit => 1), '100%', 'TIRE => LEFT REAR => Tread remaining I');

is ($s->data(component => ['TIRE' => 'RIGHT FRONT' => 'Tread remaining I'], unit => 1), '100%', 'TIRE => RIGHT FRONT => Tread remaining I');
is ($s->data(component => ['TIRE' => 'RIGHT FRONT' => 'Tread remaining M'], unit => 1), '100%', 'TIRE => RIGHT FRONT => Tread remaining M');
is ($s->data(component => ['TIRE' => 'RIGHT FRONT' => 'Tread remaining O'], unit => 1), '100%', 'TIRE => RIGHT FRONT => Tread remaining O');

is ($s->data(component => ['TIRE' => 'RIGHT REAR' => 'Tread remaining I'], unit => 1), '100%', 'TIRE => RIGHT REAR => Tread remaining I');
is ($s->data(component => ['TIRE' => 'RIGHT REAR' => 'Tread remaining M'], unit => 1), '100%', 'TIRE => RIGHT REAR => Tread remaining M');
is ($s->data(component => ['TIRE' => 'RIGHT REAR' => 'Tread remaining O'], unit => 1), '100%', 'TIRE => RIGHT REAR => Tread remaining O');

#
# Chassis
is ($s->data(component => ['CHASSIS' => 'FRONT' => 'Ballast forward'], unit => 1), '0.0"', 'CHASSIS => FRONT => Ballast forward');
is ($s->data(component => ['CHASSIS' => 'FRONT' => 'Nose weight'], unit => 1), '50.2%', 'CHASSIS => FRONT => Nose weight');
is ($s->data(component => ['CHASSIS' => 'FRONT' => 'Cross weight'], unit => 1), '56.7%', 'CHASSIS => FRONT => Cross weight');
is ($s->data(component => ['CHASSIS' => 'FRONT' => 'Steering ratio'], unit => 1), '12:1', 'CHASSIS => FRONT => Steering ratio');

#is ($s->data(), '', '');
done_testing();
