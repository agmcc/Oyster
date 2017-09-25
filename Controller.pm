#!/usr/bin/perl

package Oyster::Controller;

use strict;
use warnings;

use Time::HiRes qw'sleep';
use Data::Dumper;
use Input;

# Constructor

sub new {
	my ($class, $world, $view, $input) = @_;
	my $self = {
		world => $world,
		view => $view, 
		input => $input,
		tickRate => 60
	};
	bless ($self, $class);
	return $self;
}

# Instance methods

sub run {
	my ($self) = @_;
	while (1) {
		$self->{input}->listen();	
		$self->{onUpdate}->() if ($self->{onUpdate});
		$self->{world}->tick();
		$self->{view}->drawWorld($self->{world});
		sleep(1 / $self->{tickRate});
	}
}

sub setOnUpdateListener {
	my ($self, $callback) = @_;
	$self->{onUpdate} = $callback;
}

1;