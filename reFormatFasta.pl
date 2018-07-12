#!/bin/perl

########################################################################################
#reFormatFasta.pl
#By: Taryn Athey
#September 13th, 2017
#
#Script to convert a fasta to a certain number of nucleotides per line
#Final file will be called same name is input followed by ".fixed"
#
#Implementation: perl reFormatFasta.pl input.fasta [NumberOfNucleotides]
########################################################################################


#gets user input
my $in_file = $ARGV[0];
my $num = $ARGV[1];

#opens input file
open FILE, "<$in_file" or die "Can't open input file!";

#Combines lines in to one sequence
my $count = 0;
my $seq = "";
my $header;
foreach $line(<FILE>){
	#removes carriage returns and new lines
	$line =~ s/\r?\n//;

	#If first line, grab header
	if($count == 0){
		if(substr($line, 0, 1) eq ">"){
			$header = $line;
		}
	}
	else{
		#concatenate sequence
		$seq = $seq . $line;
	}

	$count = $count + 1;
}

#converts lower case letters in sequence to uppercase
$seq =~ tr/a-z/A-Z/;

#opens output file
open $out, ">", "$in_file.fixed" or die $!;

#Creates final fasta
print $out "$header\n";
for($i = 0; $i < length($seq); $i=$i+$num){
	print $out (substr($seq, $i, $num)) . "\n";
}
