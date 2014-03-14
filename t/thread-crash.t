use Config;
BEGIN {
  unless ($Config{useithreads}) {
    print "1..0 # SKIP your perl does not support ithreads\n";
    exit 0;
  }
}
use strict;
use warnings;
use Test::More;

for (0..100) {
  my $out = system $^X, (map {; '-I', $_ } @INC), 't/thread-crash.pl';
  if($out != 0) {
    is $out, 0;
    last;
  }
}

done_testing;
