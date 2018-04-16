# Perl Exercises
In this repository, you can find the exercises and final projecto for Perl subject of the Master in Bioinformatics for Health Science (UPF)

**Exercise 1:** write a short script that will print a countdown on the terminal.

**Exercise 2:**

  -A: write a short script that computes the factorial of a number, $f(x) = x!$, provided by the user.
  
  -B: counts the frequencies of nucleotides for a given sequence, in order to count the observed frequency of a given dinucleotide, and print all nucleotide positions where the given dinucleotide was found.

**Exercise 3:**

  -A: write a short script that reads a set of numbers from the terminal, pushes them into an array, then it has to compute the median for that set.
  
  -B: Encode the following matrix into a Perl variable and then calculate a new matrix where each $X'_{i,j} = X_{j,i}$. Print the resulting matrix and its diagonal vector:
```
  1  2  3
  5  7 12
 10 12 13
```
  -C: take a set of integers from the terminal and push them into a Perl array. For every pair of elements on that array, calculate the aritmetic mean, and insert the corresponding value between the two elements of that array. Print out the resulting list of numbers in a single line, using single whitespaces as output field separator. 

**Exercise 4:**

 -A: Gene features can be easily grouped in GFF format thanks to the ninth column, which often contains a gene identifier. Write a script to count every feature found for each gene. **As a hint**, you can use the gene identifier (the ninth column) as a primary key, and the feature field (the third column) as a secondary key.
  testing file: *feats.gff*.
  
  -B: Imagine you have two files in tabular format; both having the same kind of data: just an identifier on the first column, and a numeric value on the second. Write a script that merges the two files into a single output having three columns: the identifier, the value for that id from file 1, and the corresponding value from file 2. Where no value is present on one of the two files, just return the "`NA`" string.
  testing files: *fileA.tbl and fileB.tbl*.

**Dot Plot exercise:** create a dot matrix with the alignemnt of two sequences from a fasta file.
  testing file: *seq.fa*
  
**Project:** write a script to merge two synchronized files (FASTA and QUAL files) into a single output file (FASTQ). It also can work without a qual input, by creating a fake scoring fot output records. Moreover, the standard error output will contain the statistic analysis of the sequence content and scores distribution.
  files: *create_fastq.pl* (main program), *reads.fasta, reads.qual, ASCII_code.*
