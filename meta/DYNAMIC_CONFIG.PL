$meta->{prereqs}{runtime}{requires}{'Scalar::Util'}   = '1.13' if $] < 5.007003;
$meta->{prereqs}{runtime}{requires}{'Text::Balanced'} = '1.95' if $] < 5.007003;
$meta->{prereqs}{runtime}{requires}{'Exporter'}       = '5.57' if $] < 5.009001;
$meta->{prereqs}{runtime}{requires}{'Class::ISA'}     = '0.32' if $] < 5.009005;

if ($ENV{EXTENDED_TESTING} and $meta->{version} =~ /_/)
{
	$meta->{prereqs}{test}{requires}{'Moose'} = '2.0600';
}
