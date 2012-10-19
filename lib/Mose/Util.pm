# vim:set sw=4 ts=4 ft=perl:
package Mose::Util;

use base 'Exporter';

our @EXPORT_OK = qw/
	laptime_in_milisec
/;

sub laptime_in_milisec {
    my $format = shift;
    my ( $min, $sec ) = split /:/, $format;
    $min = $min * 60 * 1000;
    $sec = $sec * 1000;
    return $min + $sec;
}

1;
