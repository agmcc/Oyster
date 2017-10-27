#!/usr/bin/perl

package Oyster::Animation;

use strict;
use warnings;

use Vector;
use TreeSet;
use Data::Dumper;

# Constructor

sub new {
	my ($class, $name, @sprites) = @_;
	my $self = {
		name => $name,
		sprites => \@sprites,
		frameInterval => 20,
		currentFrameInd => 0,
		frameCounter => 0
	};
	bless ($self, $class);
	return $self;
}

# Instance methods

sub setframeInterval {
	my ($self, $frameInterval) = @_;
	$self->{frameInterval} = $frameInterval;
}

sub play {
	my ($self) = @_;
	$self->{frameCounter}++;
	if ($self->{frameCounter} >= $self->{frameInterval}) {
		$self->nextFrame();
		$self->{frameCounter} = 0;
	}
}

sub nextFrame {
	my ($self) = @_;
	$self->{currentFrameInd}++;
	if ($self->{currentFrameInd} >= scalar @{$self->{sprites}}) {
		$self->{currentFrameInd} = 0;
	}
}

sub getCurrentFrame {
	my ($self) = @_;
	return ${$self->{sprites}}[$self->{currentFrameInd}];
}

1;