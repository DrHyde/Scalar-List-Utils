#!./perl

use strict;
use warnings;

use Test::More;

use List::Util qw(sample);

{
  my @items = sample 3, 1 .. 10;
  is( scalar @items, 3, 'returns correct count when plentiful' );

  @items = sample 10, 1 .. 10;
  is( scalar @items, 10, 'returns correct count when exact' );

  @items = sample 20, 1 .. 10;
  is( scalar @items, 10, 'returns correct count when short' );
}

{
  my @items = sample 5, 1 .. 5;
  is_deeply( [ sort { $a <=> $b } @items ], [ 1 .. 5 ],
    'returns a permutation of the input list when exact' );
}

{
  # These two seeds happen to give different results for me, but there is the
  # smallest 1-in-2**48 chance that they happen to agree on some platform. If
  # so then pick a different seed value.

  srand 1234;
  my $x = join "", sample 3, 'a'..'z';

  srand 5678;
  my $y = join "", sample 3, 'a'..'z';

  isnt( $x, $y, 'returns different result on different random seed' );

  srand;
}

{
  my @nums = ( 1..5 );
  sample 5, @nums;

  is_deeply( \@nums, [ 1..5 ],
    'sample does not mutate passed array'
  );
}

{
  local $List::Util::RAND = sub { 4/10 };

  is( join( "", sample 5, 'A'..'Z' ), 'JKALC',
    'rigged rand() yields predictable output'
  );
}

done_testing;
