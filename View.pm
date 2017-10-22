#!/usr/bin/perl

package Oyster::View;

use strict;
use warnings;

use Time::HiRes;

use utf8;
binmode STDOUT, ":utf8";

use TreeSet;
use Data::Dumper;

# Constructor

sub new {
	my ($class) = @_;
	my $self = {

	};
	bless ($self, $class);
	return $self;
}

sub drawWorld {
	my ($self, $world) = @_;
	if (!$self->{blank}) {
		$self->{blank} = $self->newFrame($world);
	}
	# Create new frame from blank template
	@{$self->{frame}} = @{$self->{blank}};
	for my $entity (@{$world->{entities}->{contents}}) {
		my $drawCoord = $self->worldToView($entity->getLocation());
		$self->drawSprite($drawCoord, $entity->getSprite());
	}
	$self->printFrame();
}

sub newFrame {
	my ($self, $world) = @_;
	my @frame;
	my $bw = $self->getBorderW();
	# No border
	if ($bw < 1) {
		for (my $y = 0; $y < $world->{height}; $y++) {
			$frame[$y] = ' ' x $world->{width};
		}
		return \@frame;
	}
	my $rows = $world->{height} + $bw * 2;
	my $cols = $world->{width} + $bw * 2;
	my $b = $self->{border};

	for (my $y = 0; $y < $rows; $y++) {
		if ($y < $bw) {
			# Top rows
			$frame[$y] = $b->{left} x $y.$b->{topLeft}
							.$b->{top} x ($world->{width} + 2 * ($bw - $y - 1))
							.$b->{topRight}.$b->{right} x $y;
		} elsif ($y > $rows - $bw - 1) {
			# Bottom rows
			$frame[$y] = $b->{left} x ($rows - $y - 1).$b->{bottomLeft}
							.$b->{bottom} x ($world->{width} + 2 * ($bw - ($rows - $y - 1) - 1))
							.$b->{bottomRight}.$b->{right} x ($rows - $y - 1);
		} else {
			# Middle rows
			$frame[$y] = $self->{border}->{left} x $bw.' ' x $world->{width}.$self->{border}->{right} x $bw;
		}
	}
	return \@frame;
}

sub printFrame {
	my ($self) = @_;
	moveCursor(Oyster::Vector->new(0, 0));
	for my $line (@{$self->{frame}}) {
		print $line."\n";
	}
}

sub setBorder {
	my ($self, $border) = @_;
	$self->{border} = $border;
}

sub getBorderW {
	my ($self) = @_;
	return $self->{border}->{width} ? $self->{border}->{width} : 0;
}

sub drawSprite {
	my ($self, $origin, $sprite) = @_;
	my $bw = $self->getBorderW();
	# For each row in the sprite
	for (my $y = 0; $y < scalar $sprite->getData(); $y++) {
		my $drawY = $origin->{y} + $y;
		# Only draw sprite rows inside frame
		if ($drawY < scalar @{$self->{frame}} - $bw) {
			# Get reference current frame row to modify
			my $frameRowRef = \${$self->{frame}}[$drawY];
			# Split current sprite row into array of chars
			my @spriteRow = split //, ${$sprite->{data}}[$y];
			for (my $x = 0; $x < scalar @spriteRow; $x++) {
				# Position to on frame to draw
				my $drawX = $origin->{x} + $x;
				# Add non-transparent sprite row chars to frame row and
				# ensure chars aren't drawn outside frame
				if ($spriteRow[$x] ne ' ' && $drawX < (length $$frameRowRef) - $bw) {
					substr($$frameRowRef, $drawX, 1) = $spriteRow[$x];
				}
			}
		}
	}
}

sub moveCursor {
	my ($coord) = @_;
	print "\e[".$coord->{y}.";".$coord->{x}."f";
}

sub worldToView {
	my ($self, $entity) = @_;
	my $bw = $self->getBorderW();
	my $x = sprintf("%.0f", $entity->{x}) + $bw;
	my $y = sprintf("%.0f", $entity->{y}) + $bw; 
	return Oyster::Vector->new($x, $y);
}

sub clearScreen {
	# Clear
	print "\e[2J";
	# Home
	print "\e[H";
}

sub hideCursor {
	print "\e[?25l";
}

sub showCursor {
	print "\e[?25h";
}

1;