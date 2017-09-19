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
	# Create world
	my $world = Oyster::World->new(70, 15, Oyster::World::WRAP);

	# Create entities
	my $man = Oyster::Entity->new('man');
	$man->{location} = Oyster::Vector->new(1, $world->{height} - 1);
	$man->{velocity} = Oyster::Vector->new(.1, 0);
	$man->{bounds}->setBounds(-1, -1, 1, 1);
	my @man = (
		[" @ "],
		["~\e[1;32mV\e[0m~"],
		["/ \\"]	
	);
	$man->setSprite(@man);

	my $robot = Oyster::Entity->new('robot');
	$robot->{location} = Oyster::Vector->new($world->{width} - 1, $world->{height} - 1);
	$robot->{velocity} = Oyster::Vector->new(-.1, 0);
	$robot->{bounds}->setBounds(-1, -1, 1, 1);
	my @robot = (
		["[\e[1;32m:\e[0m]"],
		['/#\\'],
		['| |']
	);
	$robot->setSprite(@robot);
	$robot->setCollisionListener(sub {
		my ($other) = @_;
		my @angryRobot = (
			["[\e[1;31m:\e[0m]"],
			['/#\\'],
			['| |']
		);
		$robot->setSprite(@angryRobot);
		$world->removeEntity($other);
	});

	# Populate world
	$world->addEntity($man);
	$world->addEntity($robot);

	# Create view
	my $view = Oyster::View->new();
	Oyster::View::hideCursor;
	Oyster::View::clearScreen();

	# Add a border
	my $border = Oyster::Border->new();
	$border->setWidth(3);
	$view->setBorder($border);
	$view->drawBorder($world);

	# Main game loop
	while (1) {
		$world->tick();
		$view->drawWorld($world);
		sleep(1/60);
	}
}

$SIG{'INT'} = sub {
    Oyster::View->showCursor();
    Oyster::View->clearScreen();
    exit;
};

main();