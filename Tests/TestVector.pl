#!/usr/bin/perl

package Oyster::Tests::TestVector;

use strict;
use warnings;

use Test::Simple tests => 24;
use lib '..';
use Vector;

$|=1;

sub main{
    new();
    equals();
    add();
    subtract();
    mult();
    div();
    mag();
    sqrMag();
    setMag();
    dot();
    normalize();
    limit();

    sAdd();
    sSub();
    sMult();
    sDiv();
    sClone();
    sDist();
    sNormalize();
    sZero();
}

sub new {
	my $a = Oyster::Vector->new(1, 2);
	ok($a->{x} == 1 && $a->{y} == 2, "new");
}

sub equals {
	my $a = Oyster::Vector->new(1, 2);
	my $b = Oyster::Vector->new(1, 2);
	my $c = Oyster::Vector->new(5, 6);
	ok ($a->eq($b), "eq");
	ok (!$a->eq($c), "eq negative");
	ok ($a->eq($a), "eq same");
	ok ($a eq $b, "overload eq");
}

sub add {
	my $a = Oyster::Vector->new(1, 2);
	my $b = Oyster::Vector->new(-3, 7.5);
	my $ra = Oyster::Vector->new(-2, 9.5);
	my $rb = Oyster::Vector->new(-3, 7.5);
	$a->add($b);
	ok ($a->eq($ra) && $b->eq($rb), "add");
}

sub subtract {
	my $a = Oyster::Vector->new(1, 2);
	my $b = Oyster::Vector->new(-3, 7.5);
	$a->sub($b);
	my $ra = Oyster::Vector->new(4, -5.5);
	my $rb = Oyster::Vector->new(-3, 7.5);
	ok ($a->eq($ra) && $b->eq($rb), "sub");
}

sub mult {
	my $a = Oyster::Vector->new(1, 2);
	my $b = 5;
	my $ra = Oyster::Vector->new(5, 10);
	my $rb = 5;
	$a->mult($b);
	ok ($a->eq($ra) && $b == $rb, "mult");
}

sub div {
	my $a = Oyster::Vector->new(9, 12);
	my $b = 3;
	my $ra = Oyster::Vector->new(3, 4);
	my $rb = 3;
	$a->div($b);
	ok ($a->eq($ra) && $b == $rb, "div");
}

sub mag {
	my $a = Oyster::Vector->new(9, 12);
	my $m = $a->mag();
	my $rm = 15;
	my $ra = Oyster::Vector->new(9, 12);
	ok ($m == $rm && $a->eq($ra), "mag");
}

sub sqrMag {
	my $a = Oyster::Vector->new(4, 2);
	my $sm = $a->sqrMag();
	my $rsm = 20;
	my $ra = Oyster::Vector->new(4, 2);
	ok ($sm == $rsm && $a->eq($ra), "sqrMag");
}

sub setMag {
	my $a = Oyster::Vector->new(9, 12);
	$a->setMag(5);
	ok ($a->mag() == 5, "setMag");
}

sub dot {
	my $a = Oyster::Vector->new(9, 12);
	my $b = Oyster::Vector->new(4, 8);
	my $d = $a->dot($b);
	my $rd = 132;
	my $ra = Oyster::Vector->new(9, 12);
	my $rb = Oyster::Vector->new(4, 8);
	ok ($d == $rd && $a->eq($ra) && $b->eq($rb), "dot");
}

sub normalize {
	my $a = Oyster::Vector->new(4, 6);
	$a->normalize();
	my $m = $a->mag();
	my $ra = Oyster::Vector->new(4, 6);
	my $rm = 1;
	ok ($m == $rm, "normalize");
}

sub limit {
	my $a = Oyster::Vector->new(4, 7);
	$a->limit(4);
	my $m = $a->mag();
	my $rm = 4;
	ok ($m == $rm, "limit");
	my $b = Oyster::Vector->new(4, 3);
	$a->limit(8);
	my $m2 = $b->mag();
	my $rm2 = 5;
	ok ($m2 == $rm2, "limit not reached");
}

sub sAdd {
	my $a = Oyster::Vector->new(2, 4);
	my $b = Oyster::Vector->new(5, 8);
	my $c = Oyster::Vector->sAdd($a, $b);	
	my $ra = Oyster::Vector->new(2, 4);
	my $rb = Oyster::Vector->new(5, 8);
	my $rc = Oyster::Vector->new(7, 12);
	ok ($c->eq($rc) && $a->eq($ra) && $b->eq($rb), "sAdd");
}

sub sSub {
	my $a = Oyster::Vector->new(2, 4);
	my $b = Oyster::Vector->new(5, 8);
	my $c = Oyster::Vector->sSub($a, $b);	
	my $ra = Oyster::Vector->new(2, 4);
	my $rb = Oyster::Vector->new(5, 8);
	my $rc = Oyster::Vector->new(-3, -4);
	ok ($c->eq($rc) && $a->eq($ra) && $b->eq($rb), "sSub");
}

sub sMult {
	my $a = Oyster::Vector->new(2, 4);
	my $b = 5;
	my $c = Oyster::Vector->sMult($a, $b);
	my $ra = Oyster::Vector->new(2, 4);
	my $rb = 5;
	my $rc = Oyster::Vector->new(10, 20);
	ok ($c->eq($rc) && $a->eq($ra) && $b == $rb, "sMult");
}

sub sDiv {
	my $a = Oyster::Vector->new(2, 4);
	my $b = 2;
	my $c = Oyster::Vector->sDiv($a, $b);
	my $ra = Oyster::Vector->new(2, 4);
	my $rb = 2;
	my $rc = Oyster::Vector->new(1, 2);
	ok ($c->eq($rc) && $a->eq($ra) && $b == $rb, "sDiv");
}

sub sClone {
	my $a = Oyster::Vector->new(2, 4);
	my $b = Oyster::Vector->sClone($a);
	ok ($a->eq($b), "sClone");
}

sub sDist {
	my $a = Oyster::Vector->new(1, 3);
	my $b = Oyster::Vector->new(3, 6);
	my $d = Oyster::Vector->sDist($a, $b);
	my $ra = Oyster::Vector->new(1, 3);
	my $rb = Oyster::Vector->new(3, 6);
	my $rd = 3.605551275463989;
	ok ($d == $rd && $a->eq($ra) && $b->eq($rb), "sDist");
}

sub sNormalize {
	my $a = Oyster::Vector->new(4, 6);
	my $n = Oyster::Vector->sNormalize($a);
	my $ra = Oyster::Vector->new(4, 6);
	my $m = $n->mag();
	my $rm = 1;
	ok ($m == $rm && $a->eq($ra), "sNormalize");
}

sub sZero {
	my $a = Oyster::Vector->sZero();
	my $ra = Oyster::Vector->new(0, 0);
	ok ($a->eq($ra), "sZero");
}

main();