#!/usr/bin/perl

package Oyster::AnimationTransition;

use strict;
use warnings;

use Vector;
use TreeSet;
use Data::Dumper;

# Constructor

sub new {
	my ($class, $state, $condition) = @_;
	my $self = {
		state => $state,
		condition => $condition
	};
	bless ($self, $class);
	return $self;
}

sub checkCondition {
	my ($self, @args) = @_;
	$self->{condition}->(@args);
}

sub getState {
	my ($self) = @_;
	return $self->{state};
}

1;