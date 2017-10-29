#!/usr/bin/perl

package Oyster::Tests::TestAnimationController;

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
use AnimationController;
use AnimationState;
use AnimationTransition;

$|=1;


sub main{
	my $rm = Oyster::ResourceManager->new('/mnt/c/Users/Alexander/Documents/PerlProjects/Modules/Oyster/resources');
	$rm->loadAll();

	my $world = Oyster::World->new(100, 15, Oyster::World::WRAP);

	# Load animations
	my $playerWalk = $rm->getAnimation('player-walk');
	$playerWalk->setframeInterval(15);
	my $playerRun = $rm->getAnimation('player-run');
	$playerRun->setframeInterval(7.5);
	my $playerSprint = $rm->getAnimation('player-sprint');
	$playerSprint->setframeInterval(5);
	
	# Create animation states
	my $playerWalkState = Oyster::AnimationState->new($playerWalk);
	my $playerRunState = Oyster::AnimationState->new($playerRun);
	my $playerSprintState = Oyster::AnimationState->new($playerSprint);

	# Create transitions
	$playerWalkState->addTransition(Oyster::AnimationTransition->new($playerRunState, sub {
		my ($velocity) = @_;
		return $velocity->{x} > 0.2;
	}));

	$playerRunState->addTransition(Oyster::AnimationTransition->new($playerWalkState, sub {
		my ($velocity) = @_;
		return $velocity->{x} < 0.2;
	}));

	$playerRunState->addTransition(Oyster::AnimationTransition->new($playerSprintState, sub {
		my ($velocity) = @_;
		return $velocity->{x} > 0.3;
	}));

	$playerSprintState->addTransition(Oyster::AnimationTransition->new($playerRunState, sub {
		my ($velocity) = @_;
		return $velocity->{x} < 0.3;
	}));

	# Create animation controller
	my $animationController = Oyster::AnimationController->new();
	$animationController->addState($playerWalkState);
	$animationController->addState($playerRunState);
	$animationController->addState($playerSprintState);
	$animationController->setInitialState($playerWalkState);

	# Create player
	my $player = Oyster::Entity->new('player');
	$player->{location} = Oyster::Vector->new(0, $world->{height} - 3);
	$player->setAnimationController($animationController);
	
	$world->addEntity($player);

	my $border = Oyster::Border->new();
	$border->setWidth(1);

	my $view = Oyster::View->new();
	$view->setBorder($border);

	my $controller = Oyster::Controller->new($world, $view);
	$controller->setOnUpdateListener(sub {
		$player->{velocity}->add(Oyster::Vector->new(0.001, 0));
		$player->{velocity}->limit(0.45);
	});
	$controller->run();
}

main();