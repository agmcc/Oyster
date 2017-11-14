#!/usr/bin/perl

package Oyster::World;

use strict;
use warnings;

use Time::HiRes;

use Data::Dumper;
use TreeSet;
use Physics;

# Constructor

sub new {
	my ($class, $w, $h) = @_;
	my $self = {
		width => $w,
		height => $h,
		entities => Oyster::TreeSet->new(\&sortEntities),
		tickRate => 1
	};
	bless ($self, $class);
	return $self;
}

sub sortEntities {
	my ($a, $b) = @_;
	return $b->getLayer() - $a->getLayer();
}

sub tick {
	my ($self) = @_;
	for my $e (@{$self->{entities}->{contents}}) {
		$e->update();
		$self->collisionDetection($e, @{$self->{entities}->{contents}});
	}
}

sub collisionDetection {
	my ($self, $entity, @entities) = @_;
	for my $other (@entities) {
		if ($entity->getCollider() && $other->getCollider() && $entity ne $other) {
			if ($entity->intersects($other)) {
				$entity->onCollision($other);
			}
		}
	}
}

sub play {
	my ($self) = @_;
	while (1) {
		tick($self);
		sleep(1 / $self->{tickRate});
	}
}

sub addEntity {
	my ($self, $e) = @_;
	$self->{entities}->add($e);
}

sub removeEntity {
	my ($self, $e) = @_;
	@{$self->{entities}} = grep {$_->{name} ne $e->{name}} @{$self->{entities}};
}

sub getWidth {
	my ($self) = @_;
	return $self->{width};
}

sub getHeight {
	my ($self) = @_;
	return $self->{height};
}

1;
