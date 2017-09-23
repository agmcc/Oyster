#!/usr/bin/perl

package Oyster::Input;

use strict;
use warnings;

use Term::ReadKey;
use Data::Dumper;

use constant {
	ARROW_UP => 901,
	ARROW_DOWN => 902,
	ARROW_LEFT => 903,
	ARROW_RIGHT => 904,
	RETURN => 905
};

# Constructor

sub new {
	my ($class) = @_;
	my $self = {
	
	};
	bless ($self, $class);
	$self->init();
	return $self;
}

# Instance methods

sub init {
	my ($self) = @_;
    ReadMode(3);
}

sub listen {
	my ($self) = @_;
	my $key = ReadKey(-1);

	if ($key) {
		my $specialKey = checkSpecialKeys($key);
		if ($specialKey) {
			$key = $specialKey;
		}
		$self->onKey($key);
	} 
}

sub checkSpecialKeys {
    my ($key) = @_;
    # Check for escape key
    if (ord $key == 27) {
        if (defined (my $k = ReadKey(-1))) {
            my $code = ord $k;
            # Check for control key
            if ($code == 91) {
                # Check for action key
                my $action = ord (ReadKey(-1));

                return ARROW_UP if ($action == 65);
                return ARROW_DOWN if ($action == 66);
                return ARROW_RIGHT if ($action == 67);
                return ARROW_LEFT if ($action == 68);
            }   
        }
    # Carriage return key
    } elsif (ord $key == 10) {
    	return RETURN;
    }
}

sub setOnKeyListener {
	my ($self, $callback) = @_;
	$self->{key} = $callback;
}

sub onKey {
	my ($self, $k) = @_;
	if ($self->{key}) {
		$self->{key}->($k);
	}
}

# Ensure normal readmode restored on exit
sub DESTROY {
    ReadMode(0);
}

1;