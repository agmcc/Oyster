#!/usr/bin/perl

package Oyster::Tests::TestLayers;

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

	my $player = Oyster::Entity->new('player');
	$player->{location} = Oyster::Vector->new(0, $world->{height} - 4);
	$player->setLayer(5);
	$player->{velocity} = Oyster::Vector->new(0.1, 0);
	$player->setSprite($rm->getSprite('player'));

	my $wall = Oyster::Entity->new('wall');
	$wall->{location} = Oyster::Vector->new(0, $world->{height} - 3);
	$wall->setLayer(1);
	$wall->setSprite($rm->getSprite('wall'));

	my $clouds = Oyster::Entity->new('clouds');
	$clouds->setSprite($rm->getSprite('clouds'));

	$world->addEntity($player);
	$world->addEntity($wall);
	$world->addEntity($clouds);

	my $border = Oyster::Border->new();
	$border->setWidth(1);

	my $view = Oyster::View->new();
	$view->setBorder($border);

	my $controller = Oyster::Controller->new($world, $view);
	$controller->run();
}

main();