#!/usr/bin/perl

package Oyster::View;

use strict;
use warnings;

use Time::HiRes;

use utf8;
binmode STDOUT, ":utf8";

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

	for my $e (@{$world->{entities}}) {
		$self->drawEntity($e);
	}
}

sub drawBorder {
	my ($self, $world) = @_;

	my $b = $self->{border};

	return if (!$b);

	for (my $i = 0; $i < $b->{width}; $i++) {
		# Top left corner
		$self->drawPixel(Oyster::Vector->new(1 + $i, 1 + $i), $b->{topLeft});
		# Bottom left corner
		$self->drawPixel(Oyster::Vector->new(1 + $i, $world->{height} + 1 - $i + $b->{width} * 2), $b->{bottomLeft});
		# Top right corner
		$self->drawPixel(Oyster::Vector->new($world->{width} + 1 - $i + $b->{width} * 2, 1 + $i), $b->{topRight});
		# Bottom right corner
		$self->drawPixel(Oyster::Vector->new($world->{width} + 1 - $i + $b->{width} * 2, $world->{height} + 1 - $i + $b->{width} * 2), $b->{bottomRight});

		for (my $x = 2 + $i; $x < $world->{width} + 1 - $i + $b->{width} * 2; $x++) {
			# Top Wall
			$self->drawPixel(Oyster::Vector->new($x, 1 + $i), $b->{top});
			# Bottom Wall
			$self->drawPixel(Oyster::Vector->new($x, $world->{height} + 1 - $i + $b->{width} * 2), $b->{bottom});
		}

		for (my $y = 2 + $i; $y < $world->{height} + 1 - $i + $b->{width} * 2; $y++) {
			# Left Wall
			$self->drawPixel(Oyster::Vector->new(1 + $i, $y), $b->{left});
			# Right Wall
			$self->drawPixel(Oyster::Vector->new($world->{width} + 1 - $i + $b->{width} * 2, $y), $b->{right});
		}
	}
}

sub setBorder {
	my ($self, $border) = @_;
	$self->{border} = $border;
}

sub drawEntity {
	my ($self, $e) = @_;
	my $prev = $self->worldToView($e->{locationPrevious});
	my $cur = $self->worldToView($e->{location});

	if ($prev ne $cur) {
		$self->drawPixel($prev, ' ');
		$self->drawPixel($cur, $e->{sprite});
	}
}

sub worldToView {
	my ($self, $v) = @_;
	my $borderOffset = $self->{border} ? $self->{border}->{width} : 0;
	my $x = sprintf("%.0f", $v->{x}) + 1 + $borderOffset;
	my $y = sprintf("%.0f", $v->{y}) + 1 + $borderOffset; 
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

sub drawPixel {
    my ($self, $coord, $pixel) = @_;
    print "\e[".$coord->{y}.";".$coord->{x}."f";
    print $pixel;
}

1;