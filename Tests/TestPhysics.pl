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
use BoxCollider;

$|=1;


sub main{
	my $rm = Oyster::ResourceManager->new('./resources');
	$rm->loadAll();

	my $world = Oyster::World->new(120, 35);

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

	# Floor
	my $floor = Oyster::Entity->new('floor');
	$floor->setLocation(Oyster::Vector->new($world->getWidth() - 41, $world->getHeight() - 3));
	$floor->setSprite($rm->getSprite('wall'));
	$floor->setCollider(Oyster::BoxCollider->new(0, 0, 40, 2));

	# Box
	my $box = Oyster::Entity->new('box');
	$box->setLocation(Oyster::Vector->new($world->getWidth() - 30, 5));
	$box->setSprite($rm->getSprite('box'));
	$box->setCollider(Oyster::BoxCollider->new(0, 0, 6, 3));
	my $boxPhysics = Oyster::Physics->new();
	$boxPhysics->setGravity(Oyster::Physics::GRAVITY_ON);
	$box->setPhysics($boxPhysics);
	$box->setCollisionListener(sub {
		my ($self, $other) = @_;
		$box->getPhysics()->applyForce(Oyster::Vector->new(0, -0.7));
	});

	# $world->addEntity($spinner);
	$world->addEntity($floor);
	$world->addEntity($box);

	my $border = Oyster::Border->new();
	$border->setWidth(1);

	my $view = Oyster::View->new();
	$view->setBorder($border);
	$view->setDebug(1);

	my $controller = Oyster::Controller->new($world, $view);
	$controller->run();
}

main();
