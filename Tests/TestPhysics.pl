#!/usr/bin/perl

package Oyster::Tests::TestPhysics;

use strict;
use warnings;

use lib '..';
use Data::Dumper;
use ResourceManager;
use Entity;
use View;
use World;
use Controller;
use Vector;
use Border;
use Physics;

$|=1;


sub main{
	my $rm = Oyster::ResourceManager->new('/mnt/c/Users/Alexander/Documents/PerlProjects/Modules/Oyster/resources');
	$rm->loadAll();

	my $world = Oyster::World->new(150, 70, Oyster::World::FLOOR);

	# Create entity with basic animation
	my $spinner = Oyster::Entity->new('spinner');
	$spinner->{location} = Oyster::Vector->new(0, $world->{height} - 3);
	$spinner->setAnimation($rm->getAnimation('spinner'));
    $spinner->getAnimation()->setframeInterval(15);

	# Add physics
	my $spinnerPhysics = Oyster::Physics->new();
	$spinnerPhysics->setMass(1.5);
	$spinnerPhysics->setGravity(Oyster::Physics::GRAVITY_ON);
	$spinnerPhysics->setMaxForce(4);
	$spinnerPhysics->applyForce(Oyster::Vector->new(3.5, -3));
	
	$spinner->setPhysics($spinnerPhysics);

	$world->addEntity($spinner);

	my $border = Oyster::Border->new();
	$border->setWidth(1);

	my $view = Oyster::View->new();
	$view->setBorder($border);

	my $controller = Oyster::Controller->new($world, $view);
	$controller->run();
}

main();