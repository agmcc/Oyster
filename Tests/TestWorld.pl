#!/usr/bin/perl

package Oyster::Tests::TestWorld;

use strict;
use warnings;

use Test::Simple tests => 1;
use lib '..';
use World;

$|=1;

sub main{
	new();
}

sub new {
	my $w = Oyster::World->new(600, 400);
	ok ($w->{width} == 600 && $w->{height} == 400, "new");
}

main();