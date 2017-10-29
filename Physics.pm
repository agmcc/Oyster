#!/usr/bin/perl

package Oyster::Physics;

use strict;
use warnings;

use Vector;
use Data::Dumper;

use constant {
	GRAVITY_OFF => 0,
	GRAVITY_ON => 1,
	GRAVITY_FORCE => Oyster::Vector->new(0, 0.1)
};

# Constructor

sub new {
	my ($class) = @_;
	my $self = {
		velocity => Oyster::Vector::sZero(),
		acceleration => Oyster::Vector::sZero(),
		maxForce => 'Infinity',
		maxSpeed => 'Infinity',
		mass => 1,
		gravity => GRAVITY_OFF,
		gravityForce => GRAVITY_FORCE
	};
	bless ($self, $class);
	return $self;
}

# Instance methods

sub updateLocation {
	my ($self, $currentLocation) = @_;
	$self->applyForce($self->{gravityForce}) if ($self->{gravity}); 
	$self->{acceleration}->limit($self->{maxForce});
	$self->{velocity}->add($self->{acceleration}->div($self->{mass}));
	$self->{velocity}->limit($self->{maxSpeed});
	$self->{acceleration} = Oyster::Vector->sZero();
	return $currentLocation->add($self->{velocity});
}

sub applyForce {
	my ($self, $force) = @_;
	$self->{acceleration}->add($force);
}

sub getVelocity {
	my ($self) = @_;
	return $self->{velocity};
}

sub setVelocity {
	my ($self, $velocity) = @_;
	$self->{velocity} = $velocity;
}

sub getAcceleration {
	my ($self) = @_;
	return $self->{acceleration};
}

sub setAcceleration {
	my ($self, $acceleration) = @_;
	$self->{acceleration} = $acceleration;
}

sub getMaxForce {
	my ($self) = @_;
	return $self->{maxForce};
}

sub setMaxForce {
	my ($self, $maxForce) = @_;
	$self->{maxForce} = $maxForce;
}

sub getMaxSpeed {
	my ($self) = @_;
	return $self->{maxSpeed};
}

sub setMaxSpeed {
	my ($self, $maxSpeed) = @_;
	$self->{maxSpeed} = $maxSpeed;
}

sub getMass {
	my ($self) = @_;
	return $self->{mass};
}

sub setMass {
	my ($self, $mass) = @_;
	$self->{mass} = $mass;
}

sub setGravity {
	my ($self, $mode) = @_;
	$self->{gravity} = $mode;
}

sub getGravity {
	my ($self) = @_;
	return $self->{gravity};
}

sub setGravityForce {
	my ($self, $force) = @_;
	$self->{gravityForce} = $force;
}

sub getGravityForce {
	my ($self) = @_;
	return $self->{gravityForce};
}

1;