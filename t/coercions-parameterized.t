=pod

=encoding utf-8

=head1 PURPOSE

Checks the C<Split> and C<Join> parameterized coercions from
L<Types::Standard>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013-2014 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

use strict;
use warnings;
use lib qw( . ./t ../inc ./inc );
use utf8;

use Test::More;
use Test::Requires { "Encode" => 0 };
use Test::TypeTiny;

use Encode;
use Types::Standard qw( Str ArrayRef Join Split );
use Type::Utils;

my $chars          = "Café Paris|Garçon";
my $bytes_utf8     = Encode::encode("utf-8",      $chars);
my $bytes_western  = Encode::encode("iso-8859-1", $chars);

is(length($chars),         17, 'length $chars == 17');
is(length($bytes_utf8),    19, 'length $bytes_utf8 == 19');
is(length($bytes_western), 17, 'length $bytes_western == 17');

my $SplitSpace = (ArrayRef[Str]) + (Split[qr/\s/]);
my $SplitPipe  = (ArrayRef[Str]) + (Split[qr/\|/]);

ok($SplitSpace->can_be_inlined, '$SplitSpace can be inlined');
ok($SplitPipe->can_be_inlined, '$SplitPipe can be inlined');

is_deeply(
	$SplitSpace->coerce($chars),
	[ "Café", "Paris|Garçon" ],
	'$SplitSpace->coerce($chars)',
);

is_deeply(
	$SplitSpace->coerce($bytes_utf8),
	[ map Encode::encode("utf-8", $_), "Café", "Paris|Garçon" ],
	'$SplitSpace->coerce($bytes_utf8)',
);

is_deeply(
	$SplitSpace->coerce($bytes_western),
	[ map Encode::encode("iso-8859-1", $_), "Café", "Paris|Garçon" ],
	'$SplitSpace->coerce($bytes_western)',
);

should_pass($SplitSpace->coerce($chars), ArrayRef[Str]);
should_pass($SplitSpace->coerce($bytes_utf8), ArrayRef[Str]);
should_pass($SplitSpace->coerce($bytes_western), ArrayRef[Str]);

is_deeply(
	my $arr_chars = $SplitPipe->coerce($chars),
	[ "Café Paris", "Garçon" ],
	'$SplitPipe->coerce($chars)',
);

is_deeply(
	my $arr_bytes_utf8 = $SplitPipe->coerce($bytes_utf8),
	[ map Encode::encode("utf-8", $_), "Café Paris", "Garçon" ],
	'$SplitPipe->coerce($bytes_utf8)',
);

is_deeply(
	my $arr_bytes_western = $SplitPipe->coerce($bytes_western),
	[ map Encode::encode("iso-8859-1", $_), "Café Paris", "Garçon" ],
	'$SplitPipe->coerce($bytes_western)',
);

my $JoinPipe = Str + Join["|"];

is(
	$_ = $JoinPipe->coerce($arr_chars),
	$chars,
	'$JoinPipe->coerce($arr_chars)',
);
should_pass($_, Str);

is(
	$_ = $JoinPipe->coerce($arr_bytes_utf8),
	$bytes_utf8,
	'$JoinPipe->coerce($arr_bytes_utf8)',
);
should_pass($_, Str);

is(
	$_ = $JoinPipe->coerce($arr_bytes_western),
	$bytes_western,
	'$JoinPipe->coerce($arr_bytes_western)',
);
should_pass($_, Str);

done_testing;
