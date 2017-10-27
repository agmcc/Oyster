#!/usr/bin/perl

package Oyster::ResourceManager;

use strict;
use warnings;

use Data::Dumper;
use File::Find;
use Sprite;
use Animation;

# Constructor

sub new {
	my ($class, $dir) = @_;
	my $self = {
		dir => $dir,
		ext => '.sprite',
		animations => []
	};
	bless ($self, $class);
	return $self;
}

# Instance methods

sub loadAll {
	my ($self) = @_;
	my @sprites;
	find (sub {
		# Check if file contains #<number>
		if ($_ =~ /(.*)#(\d+)$self->{ext}$/) {
			$self->loadFrame($_, $1, $2);
		} 
		elsif ($_ =~ /(.*)$self->{ext}$/) {
			$self->loadSprite($_, $1);
		}
	}, $self->{dir});
}

sub loadFrame {
	my ($self, $file, $name, $frameNo) = @_;
	my @lines = loadSpriteData($file);
	my $sprite = Oyster::Sprite->new($name, \@lines, $frameNo);
	if ($frameNo == 1) {
		# New animation
		my @sprites;
		push @sprites, $sprite;
		my $animation = Oyster::Animation->new($name, @sprites);
		push @{$self->{animations}}, $animation;
	} else {
		# Existing animation
		my $animation = $self->getAnimation($name);
		push @{$animation->{sprites}}, $sprite;
	}
}

sub loadSprite {
	my ($self, $file, $name) = @_;
	my @lines = loadSpriteData($file);
	my $sprite = Oyster::Sprite->new($name, \@lines, 0);
	push @{$self->{sprites}}, $sprite;
}

sub loadSpriteData {
	my ($file) = @_;
	open (my $fh, '<', $file) or die "Failed to open $file: $!\n";
	my @lines = <$fh>;
	for (my $i = 0; $i < scalar @lines; $i++) {
		# Strip newlines
		$lines[$i] =~ s/\R//g;
	}
	close $fh or warn "Failed to close $file: $!\n";
	return @lines;
}

sub getSprites {
	my ($self) = @_;
	return @{$self->{sprites}};
}

sub getSprite {
	my ($self, $name) = @_;
	for my $spr (@{$self->{sprites}}) {
		if ($spr->{name} eq $name) {
			return $spr;
		}
	}
}

sub getAnimation {
	my ($self, $name) = @_;
	for my $anim (@{$self->{animations}}) {
		if ($anim->{name} eq $name) {
			return $anim;
		}
	}
}

1;