# vim:set sw=4 ts=4 ft=perl:
package Mose::Util::LaptimeFile;

sub new {
	my $proto = shift;
	my $class = ref $proto || $proto;
	my $self = ref $_[0] eq 'HASH' ? $_[0] : {@_};

	return bless $self, $class;
}

sub save_record {
	my $self = shift;
	my @laptimes = shift;

	return 1;
}

1;
