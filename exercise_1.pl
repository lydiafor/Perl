#!/usr/bin/perl

#Countdown

use warnings;
use strict;

print "Countdown start: ";
my $start = <STDIN>;
	chomp $start;

my $i = $start;

while ($i > 0) {
	do {
		print "$i\n"; 
		$i--;
		sleep(2);
	} until ($i==0)	
};



