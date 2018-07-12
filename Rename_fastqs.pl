#/bin/perl
use warnings;
use strict;

####################################################################################
#Rename_fastqs.pl
#
#By: Taryn Athey, September 13, 2017
#
#This program should be run from the directory containing the files to be renamed
#The input names file should have the original name in the first column and the new
#name in the second column
#
#Implementation: Rename_fastqs.pl names.txt
#
####################################################################################

#Get user input
my $file = $ARGV[0];
open my $names, "<", $file, or die "Can't open input file!";

#Goes through each line in the file
foreach my $name (<$names>){
	#If the end of the line has a carriage return or a new line, remove it
	$name =~ s/\r?\n//;

	#Reads in text file, first column should be current name, second column should be new name
	my @columns = split(/\s+/, $name);

	#current file name for R1 and R2
	my $fileR1 = "$columns[0]_R1.fastq";
	my $fileR2 = "$columns[0]_R2.fastq";

	#If file exists, rename
	if( -e $fileR1){
		system("mv $fileR1 $columns[1]_R1.fastq");
	}
	if( -e $fileR2){
		system("mv $fileR2 $columns[1]_R2.fastq");
	}
}
