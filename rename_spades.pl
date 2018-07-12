#/bin/perl
use warnings;
use strict;

################################################################################################
#rename_spades.pl
#by Taryn Athey, Biocomputational Analyst
#January 30th, 2017
#
#Renames spades files based on a txt file.  Run from directory containing spades assemblies.
#Input is a file with original name in first column and new name in the second column
#
#Exectution: perl rename_spades.pl name_file.txt
#
#For any help or changes with this progam please contact Taryn Athey: taryn.athey@oahpp.ca
#
###############################################################################################

#Reads in file
my $file = $ARGV[0];
open my $names, "<", $file, or die "Can't open input file!";

foreach my $name (<$names>){
	$name =~ s/\r?\n//;

	#splits file into original name and new name
	(my $original, my $new) = split(/\s+/,$name);

	#changes directory based on original file name
	chdir $original;

	#renames file
	rename("$original.contigs", "$new.contigs");

	#Changes directory back
	chdir "..";
}
