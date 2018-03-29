#!/bin/bash

##############################################################################
#blast_awk.sh
#
#Author: Taryn Athey, March 29th, 2018
#
#This script blasts de novo assembled fasta files against a blast database
#then grabs the contig names that had a blast match and outputs them to a new
#fasta file
#
##############################################################################

#The full path to the blast database you would like to use
#NOTE, to make a blast database: "makeblastdb -in gene.fasta -dbtype nucl"
DB=/Scratch.NFS/tathey/Sandra_blast/gene.fasta

#Loops through all of the fasta files in a directory
for FILENAME in *.fasta ;
 do
  #Checkes that the object is a file
  if [ -f "$FILENAME" ]; then
	#Grabs the basename of the fasta file
	NAME=$(basename $FILENAME .fasta)

	#blasts the fasta file
	blastn -db $DB -query $FILENAME -outfmt 6 > $NAME.blast

	#Creates an array of contig names found in blast output
	INTEREST=($(awk '{ print $1 }' $NAME.blast))

	#Loops through array and writes the sequences to a new file
	for i in "${INTEREST[@]}"
	do
		awk 'BEGIN {RS=">"}/'$i'/ {print ">"$o}' $NAME.fasta >> $NAME.contigs.fasta
	done
 fi
done
