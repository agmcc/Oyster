#!/usr/bin/perl

package Oyster::Animator;

use strict;
use warnings;

use Data::Dumper;

# Constructor

sub new {
	my ($class) = @_;
	my $self = {
		states => []
	};
	bless ($self, $class);
	return $self;
}

# Instance methods

sub play {
	my ($self, @args) = @_;
	my $currentState =  $self->getCurrentState();
	for my $transition ($currentState->getTransitions()) {
		if ($transition->checkCondition(@args)) {
			$self->{currentState} = $transition->getState();
			last;
		}
	}
}

sub addState {
	my ($self, $state) = @_;
	push @{$self->{states}}, $state;
}

sub getCurrentState {
	my ($self) = @_;
	return $self->{currentState};
}

sub setInitialState {
	my ($self, $state) = @_;
	$self->{currentState} = $state;
}

1;