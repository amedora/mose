use Test::More;
use FindBin qw/$Bin/;
use File::Spec;

BEGIN { use_ok('IRacing::Setup'); }

use strict;

my $f = File::Spec->catfile($Bin, 'dover_fixed.htm');
my $s = IRacing::Setup->new($f);
ok($s, 'loading setup file');

done_testing();

