#!/usr/bin/perl

package Oyster::Tests::TestEntity;

use strict;
use warnings;

use Test::Simple tests => 4;
use lib '..';
use Entity;

$|=1;

sub main{
   new();
   update();
   equals();
}

sub new {
	my $a = Oyster::Entity->new();
	my $l = Oyster::Vector->sZero();
	ok ($a->{location}->eq($l), "new");
}

sub equals {
	my $a = Oyster::Entity->new();
	my $b = Oyster::Entity->new();
	ok ($a eq $b, 'eq');
	$b->{id} = 999;
	ok ($a->{id} ne $b->{id}, 'not eq');
}

sub update {
	my $a = Oyster::Entity->new();
	$a->{location} = Oyster::Vector->new(5, -3);
	$a->{velocity} = Oyster::Vector->new(2, 4);
	$a->update();
	my $r = Oyster::Vector->new(7, 1);
	ok ($a->{location}->eq($r), "update");
}

main();