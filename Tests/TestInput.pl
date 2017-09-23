#!/usr/bin/perl

package Oyster::Tests::TestEntity;

use strict;
use warnings;

use lib '..';
use Entity;
use Input;
use Time::HiRes qw'sleep';

$|=1;

sub main{
	my $input = Oyster::Input->new();
	$input->setOnKeyListener(\&onKey);

	while (1) {
		$input->listen();
		sleep (1/60);
	}
}

sub onKey {
	my ($key) = @_;
	if ($key == Oyster::Input::ARROW_UP) {
		print "Up\n";
	}
}

main();