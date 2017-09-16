#!/usr/bin/perl

package Oyster::Entity;

use strict;
use warnings;

use Vector;
use overload 'eq' => \&eq;

# Constructor

sub new {
	my ($class, $name) = @_;
	my $self = {
		name => $name,
		location => Oyster::Vector->sZero(),
		velocity => Oyster::Vector->sZero(),
		locationPrevious => Oyster::Vector->sZero()
	};
	bless ($self, $class);
	return $self;
}

# Instance methods

sub update {
	my ($self) = @_;
	$self->{locationPrevious} = Oyster::Vector->sClone($self->{location});
	$self->{location}->add($self->{velocity});
}

sub eq {
	my ($self, $other) = @_;
	return ($self->{name} == $other->{name});
}

sub print {
	my ($self) = @_;
	print ("$self->{name}\n");
	print "location: ";
	$self->{location}->print();
	print "locationPrevious: ";
	$self->{locationPrevious}->print();
	print "velocity: ";
	$self->{velocity}->print();
}

1;