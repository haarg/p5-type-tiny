use threads;
use strict;
use warnings;
use Type::Tiny;

my $int = Type::Tiny->new(
  name       => "Integer",
  constraint => sub { /^(?:-?[1-9][0-9]*|0)$|/ },
  message    => sub { "$_ isn't an integer" },
);

threads->create(sub {
  my $type = $int;
  1;
})->join;
