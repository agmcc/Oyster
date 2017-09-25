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
use Controller;

$|=1;

my $worldThread;

sub main{
	# Create world
	my $world = Oyster::World->new(80, 15, Oyster::World::WRAP);

	# Create entities
	my $man = Oyster::Entity->new('man');
	$man->{location} = Oyster::Vector->new($world->{width} / 2, $world->{height} - 1);
	$man->{velocity} = Oyster::Vector->new(0.01, 0);
	$man->{bounds}->setBounds(-1, -1, 1, 1);
	my @man = (
		[" @ "],
		["~\e[1;32mV\e[0m~"],
		["/ \\"]	
	);
	$man->setSprite(@man);

	# Populate world
	$world->addEntity($man);

	# Create view
	my $view = Oyster::View->new();
	Oyster::View::hideCursor;
	Oyster::View::clearScreen();

	# Add a border
	my $border = Oyster::Border->new();
	$border->setWidth(1);
	$view->setBorder($border);
	$view->drawBorder($world);

	# Create input
	my $input = Oyster::Input->new();
	$input->setOnKeyListener(sub {
		my ($key) = @_;
		my $maxSpeed = .5;
		my $acceleration = .25;
		if ($key eq Oyster::Input::ARROW_RIGHT) {
			$man->{velocity}->add(Oyster::Vector->new($acceleration, 0));
		} elsif ($key eq Oyster::Input::ARROW_LEFT) {
			$man->{velocity}->add(Oyster::Vector->new(-$acceleration, 0));
		}
		$man->{velocity}->limit($maxSpeed);
	});

	# Create controller
	my $controller = Oyster::Controller->new($world, $view, $input);
	$controller->setOnUpdateListener(sub {
		
	});

	# Start game
	$controller->run();
}

$SIG{'INT'} = sub {
    Oyster::View->showCursor();
    Oyster::View->clearScreen();
    exit;
};

main();