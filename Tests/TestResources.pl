#!/usr/bin/perl

package Oyster::Tests::TestResources;

use strict;
use warnings;

use lib '..';
use Data::Dumper;
use ResourceManager;

$|=1;


sub main{
	my $rm = Oyster::ResourceManager->new('./resources');
	$rm->loadAll();
	system('clear');

	for my $spr ($rm->getSprites()) {
		for my $line ($spr->getData()) {
			print $line."\n";
		}
	}
}

main();