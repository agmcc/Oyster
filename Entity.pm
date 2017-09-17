#!/usr/bin/perl

package Oyster::Entity;

use strict;
use warnings;

use Vector;
use Bounds;
use Data::Dumper;

use overload 'eq' => \&eq;
use overload ne => \&ne;

# Constructor

sub new {
	my ($class, $name) = @_;
	my $self = {
		name => $name,
		location => Oyster::Vector->sZero(),
		velocity => Oyster::Vector->sZero(),
		locationPrevious => Oyster::Vector->sZero(),
		sprite => '?',
		bounds => Oyster::Bounds->new(0, 0, 1, 1)
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

sub ne {
	my ($self, $other) = @_;
	return !($self eq $other);
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
	print "bounds: ";
	$self->{bounds}->print();
}

sub setSprite {
	my ($self, $sprite) = @_;
	$self->{sprite} = $sprite;
}

sub intersects {
	my ($self, $other) = @_;
	my $b1 = $self->{bounds};
	my $b2 = $other->{bounds};
	my $l1 = $self->{location};
	my $l2 = $other->{location};
	# <= etc. to ensure adjacent squares don't count as intersection
	return !($l2->{x} + $b2->{x1} >= $l1->{x} + $b1->{x2} ||
			 $l2->{x} + $b2->{x2} <= $l1->{x} + $b1->{x1} ||
			 $l2->{y} + $b2->{y1} >= $l1->{y} + $b1->{y2} ||
			 $l2->{y} + $b2->{y2} <= $l1->{y} + $b1->{y1});
}

sub onCollision {
	my ($self, $other) = @_;
	$self->setSprite("\e[1;31m".'X'."\e[0m");
}

1;