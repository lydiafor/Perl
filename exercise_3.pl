#!/usr/bin/perl

use warnings;
use strict;

##A: read a set of number, push them into an array and calculate the median

sub median_computation(){
	##Declare an initializing variables
	my (@num_set, @sort_num_set, $n, $pos, $pos1, $pos2, $median);

	print "Introduce numbers: ";
	while (<STDIN>) {
		chomp;
		push @num_set, $_;
		($_ eq "") && last;
	};

	pop @num_set;

	#Sortering < the set
	print "Sorted numeric values:\n";
	@sort_num_set = sort {$a <=> $b} @num_set;
	print '(',join(",", @sort_num_set), ")\n";

	#Calculate the median
	$n = scalar(@sort_num_set);
	if ($n % 2 ==1){ #impar lengths
		$pos = int($n/2); #round to higher num	
		$median = $sort_num_set[$pos];
	} else { #par lengths
		$pos2 = $n/2;
		$pos1 = $pos2-1;
		$median = ($sort_num_set[$pos1] + $sort_num_set[$pos2])/2;
	}

	print "The median value is $median\n";
}

##B: Encode the matrix into a perl variable, Calculate a new matrix where X'ij=Xji and Print the resulting matrix and its diagonal vector

sub matrix_transposition_vector(){
	my (@matrix, @transpos, $i, $j, @diag_vec);


	@matrix = ( 	[1,2,3],
			[5,7,12],
			[10,12,13] );

	#Printing the matrix
	print "\nmatrix:\n";
	print "@{ $matrix[0] }\n";
	print "@{ $matrix[1] }\n";
	print "@{ $matrix[2] }\n\n";

	#Transposed matrix
	print "trasposed matrix:\n";

	for ($i=0; $i < scalar(@matrix); $i++) {
		for ($j=0; $j < scalar(@{$matrix[0]}); $j++) {
			print $matrix[$j][$i], " ";
		}
		print "\n";
	}

	#Diagonal vector
	@diag_vec = ($matrix[0][0], $matrix[1][1], $matrix[2][2]);

	print "\ndiagonal vector: \n";
	print "@diag_vec\n\n";
}
##C: push set of number into an array. For every pair of elemnts calculate the aritmetic mean, and insert the value between both

sub aritmetic_mean(){
	#Declaring variables
	my (@array, $n, $m, $i, $j, $mean);

	@array = ();
	$i = 0;

	while (<STDIN>) {
		chomp;
		push @array, $_;
		($_ eq "") && last;
	};
	pop @array;

	print "my array is:"."(",join(",", @array),")\n\n";

	$n = scalar(@array);

	#Compute and print the aritmetic mean
	while ($i < $n) {
		$j = $i + 1;
		$m = $array[$i] + $array[$j];
		$mean = $m/2;
		print "Positions $i (xn), $j (xn+1) and their mean = ".$array[$i].",". $array[$i+1].",".$mean."\n\n";
		$i = $i +2;
	};
}
