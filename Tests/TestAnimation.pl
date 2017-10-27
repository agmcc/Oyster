#!/usr/bin/perl

package Oyster::Tests::TestAnimation;

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
use Sprite;
use Border;

$|=1;


sub main{
	my $rm = Oyster::ResourceManager->new('/mnt/c/Users/Alexander/Documents/PerlProjects/Modules/Oyster/resources');
	$rm->loadAll();

	my $world = Oyster::World->new(30, 20, Oyster::World::WRAP);

	my $spinner = Oyster::Entity->new('spinner');
	$spinner->{location} = Oyster::Vector->new(0, $world->{height} / 2);
    $spinner->{velocity} = Oyster::Vector->new(0.1, 0);
	$spinner->setAnimation($rm->getAnimation('spinner'));
    $spinner->getAnimation()->setframeInterval(15);

	$world->addEntity($spinner);

	my $border = Oyster::Border->new();
	$border->setWidth(1);

	my $view = Oyster::View->new();
	$view->setBorder($border);

	my $controller = Oyster::Controller->new($world, $view);
	$controller->run();
}

main();