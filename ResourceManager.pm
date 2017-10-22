#!/usr/bin/perl

package Oyster::ResourceManager;

use strict;
use warnings;

use Data::Dumper;
use File::Find;
use Sprite;

# Constructor

sub new {
	my ($class, $dir) = @_;
	my $self = {
		dir => $dir,
		ext => '.sprite'
	};
	bless ($self, $class);
	return $self;
}

# Instance methods

sub loadAll {
	my ($self) = @_;
	my @sprites;
	find (sub {
		if ($_ =~ /(.*)$self->{ext}$/) {
			push @sprites, loadSprite($_, $1);
		}
	}, $self->{dir});
	@{$self->{sprites}} = @sprites;
}

sub loadSprite {
	my ($file, $name) = @_;
	open (my $fh, '<', $file) or die "Failed to open $file: $!\n";
	my @lines = <$fh>;
	for (my $i = 0; $i < scalar @lines; $i++) {
		# Strip newlines
		$lines[$i] =~ s/\R//g;
	}
	close $fh or warn "Failed to close $file: $!\n";
	my $sprite = Oyster::Sprite->new($name, @lines);
	return $sprite;
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

1;