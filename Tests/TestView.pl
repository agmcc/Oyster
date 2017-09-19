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
use Time::HiRes qw'sleep';
use Bounds;
use Data::Dumper;

$|=1;

my $worldThread;

sub main{
	# print "\n\n";
	# Oyster::View->drawSprite();
	# print "\n\n";
	# exit();

	my $world = Oyster::World->new(50, 40, Oyster::World::WRAP);
	
	my $mike = Oyster::Entity->new("Mike");
	$mike->{velocity} = Oyster::Vector->new(.1, .1);
	$mike->setSprite('M');

	my $alex = Oyster::Entity->new("alex");
	$alex->{velocity} = Oyster::Vector->new(.3, -.2);
	$alex->setSprite('A');

	my $dave = Oyster::Entity->new("dave");
	$dave->{location}->{y} = $world->{height} / 2;
	$dave->{velocity} = Oyster::Vector->new(-.4, 0);
	$dave->setSprite('D');

	my $t = Oyster::Entity->new("T");
	$t->{location} = Oyster::Vector->new(0, 5);
	$t->{velocity} = Oyster::Vector->new(.1, 0);
	$t->setSprite('T');

	my $u = Oyster::Entity->new("U");
	$u->{location} = Oyster::Vector->new(20, 20);
	$u->{velocity} = Oyster::Vector->new(-0.1, 0);

	my @robot = 
	(
		["[\e[1;31m:\e[0m]"],
		['/#\\'],
		['| |']
	);

	$u->setSprite(@robot);
	$u->{bounds}->setBounds(-1, -1, 1, 1);

	# $world->addEntity($mike);
	# $world->addEntity($alex);
	# $world->addEntity($dave);
	# $world->addEntity($t);
	$world->addEntity($u);

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
		sleep(1/30);
	}

	print "\n\n";

}

$SIG{'INT'} = sub {
    Oyster::View->showCursor();
    Oyster::View->clearScreen();
    exit;
};

main();