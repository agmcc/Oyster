#!/usr/bin/perl

package Oyster::AnimationState;

use strict;
use warnings;

use Vector;
use TreeSet;
use Data::Dumper;

# Constructor

sub new {
	my ($class, $animation) = @_;
	my $self = {
		animation => $animation,
		transitions => [],
		name => $animation->{name}
	};
	bless ($self, $class);
	return $self;
}

# Instance methods

sub addTransition {
	my ($self, $transition) = @_;
	push @{$self->{transitions}}, $transition;
}

sub getAnimation {
	my ($self) = @_;
	return $self->{animation};
}

sub getTransitions {
	my ($self) = @_;
	return @{$self->{transitions}};
}

1;