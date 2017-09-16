#!/usr/bin/perl

package Oyster::Tests::TestView;

use strict;
use warnings;

use lib '..';
use World;
use Entity;
use Vector;
use View;
use Border;
use threads;
use threads::shared;
use Time::HiRes qw'sleep';


$|=1;

my $worldThread;

sub main{
	my $world = Oyster::World->new(60, 20, Oyster::World::WRAP);
	
	my $mike = Oyster::Entity->new("Mike");
	$mike->{velocity} = Oyster::Vector->new(.1, .1);
	my $alex = Oyster::Entity->new("alex");
	$alex->{velocity} = Oyster::Vector->new(.3, -.2);
	my $dave = Oyster::Entity->new("dave");
	$dave->{location}->{y} = $world->{height} / 2;
	$dave->{velocity} = Oyster::Vector->new(-.4, 0);

	$world->addEntity($mike);
	$world->addEntity($alex);
	$world->addEntity($dave);

	my $view = Oyster::View->new();
	Oyster::View::hideCursor;
	Oyster::View::clearScreen();

	my $border = Oyster::Border->new();
	$border->setWidth(3);

	$view->setBorder($border);


	$view->drawBorder($world);

	while (1) {
		$world->tick();
		$view->drawWorld($world);
		sleep(1/20);
	}

	print "\n\n";

}

sub startWorld {

}

$SIG{'INT'} = sub {
    Oyster::View->showCursor();
    Oyster::View->clearScreen();
    exit;
};

main();