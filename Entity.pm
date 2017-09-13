#!/usr/bin/perl

package Oyster::Entity;

use strict;
use warnings;

use Vector;
use overload 'eq' => \&eq;

# Constructor

sub new {
	my ($class) = @_;
	my $self = {
		id => 123,
		location => Oyster::Vector->sZero(),
		velocity => Oyster::Vector->sZero()
	};
	bless ($self, $class);
	return $self;
}

# Instance methods

sub update {
	my ($self) = @_;
	$self->{location}->add($self->{velocity});
}

sub eq {
	my ($self, $other) = @_;
	return ($self->{id} == $other->{id});
}

1;