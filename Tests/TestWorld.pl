#!/usr/bin/perl

package Oyster::Tests::TestWorld;

use strict;
use warnings;

use Test::Simple tests => 1;
use lib '..';
use World;
use Entity;
use Vector;

$|=1;

sub main{
	new();

	my $world = Oyster::World->new(5, 5, Oyster::World::WRAP);
	my $mike = Oyster::Entity->new("Mike");
	$mike->{velocity} = Oyster::Vector->new(1, -1);
	$world->addEntity($mike);
	# $world->addEntity(Oyster::Entity->new("Joe"));

	$world->play();
}

sub new {
	my $w = Oyster::World->new(600, 400);
	ok ($w->{width} == 600 && $w->{height} == 400, "new");
}

main();