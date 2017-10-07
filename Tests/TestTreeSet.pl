#!/usr/bin/perl

package Oyster::Tests::TestTreeSet;

use strict;
use warnings;

use lib '..';
use TreeSet;

$|=1;

sub main{
	my $tree = Oyster::TreeSet->new(sub { return $_[1] - $_[0]; });
	$tree->add(-4);
	$tree->add(1);
	$tree->add(2);
	$tree->add(1);
	$tree->print();
}

main();