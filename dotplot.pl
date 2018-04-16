#!/usr/bin/perl

##printing matrices
##From a seqs file and two identifiers, compare those two seqs
##create a matrix od matches and mismatches

use strict;
use warnings;

#Variable declaration

my (%seqs, $header, $seq, $head1, $head2, $head, $seq1, $seq2, @seq1, @seq2, @matrix);

#We need to introduce two seq names (separately) and a fasta file as command arguments

(scalar(@ARGV) < 3) && do {
	print "You need to introduce three argumentes: seq1, seq2, fasta\n";
	exit(0);
};

#Once the parameters are correct, we store the fasta file into a hash

open(FASTA, $ARGV[2]) or die "Could not open that file";

while (<FASTA>){
	chomp;
	if ($_ =~ /^>/) {
		$header = $_;
		$header =~ s/^>//; #Remove "<" symbol
		$seqs{$header} = "";

	} else {
		s/\s+//g;
		$seq = $_;
		$seqs{$header} = $seq;
	}
}

close FASTA;

#Searching the corresponded sequence to our headers

$head1 = $ARGV[0];
$head2 = $ARGV[1];

foreach $head (keys %seqs) {
	if ($head1 eq $head) {
		$seq1 = $seqs{$head};
	}
	if ($head2 eq $head) {
		$seq2 = $seqs{$head};
	} 
} 

#Initialize the alignment matrix

@seq1 = split//, $seq1;
@seq2 = split//, $seq2;

$matrix[0][0] = "*";
my $n = length($seq1);
my $m = length($seq2);

for (my $j=1; $j <= $n; $j++) {
	$matrix[0][$j] = $seq1[$j-1];
}

for (my $i=1; $i <= $m; $i++) {
	$matrix[$i][0] = $seq2[$i-1];
}

#Filing the matrix with matches/mismatches values

my $a = scalar@{ $matrix[0]};
my $b = scalar(@matrix);

for (my $j=1; $j<$a; $j++) {
	for (my $i=1; $i<$b; $i++) { 
		my $char1 = $matrix[0][$j];
		my $char2 = $matrix[$i][0];
		
		if ($char1 eq $char2) {
			$matrix[$i][$j] = 1;
		} else {
			$matrix[$i][$j] = 0;
		}
		
	}
}

#Printing the results as a dot plot matrix

for (my $i=0; $i< $m; $i++) {
	for (my $j=0; $j<$n; $j++) {
		unless ($i == 0 || $j == 0) {
			print STDOUT ($matrix[$i][$j] ? '*' : ' ');
		} else {
			print STDOUT $matrix[$i][$j];
		}
		
		print STDOUT " ";
	}
		print STDOUT "\n";
}

exit(0);



