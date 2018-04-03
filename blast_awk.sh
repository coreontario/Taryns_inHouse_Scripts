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

	#Creates an array of contig names and blast positions found in blast output
	INTEREST=($(awk '{ print $1 }' $NAME.blast))
	START=($(awk '{ print $9 }' $NAME.blast))
	END=($(awk '{ print $10 }' $NAME.blast))

	#Loops through array and writes the sequences to a new file
	for (( i=0; i<${#INTEREST[@]}; i++ ));
	do
		#Writes contig sequence to a temporary file
		awk 'BEGIN {RS=">"}/'${INTEREST[$i]}'/ {print ">"$o}' $NAME.fasta > $NAME.temp.fasta$i

		#Grabs length of fasta lines
		LINE_LEN=$(expr $(head -n2 $NAME.temp.fasta$i | tail -n1 | wc -c) - 1)

		#Checks if the blast mapped to the reverse complement, if yes, reverses the sequence
		if [ "${START[$i]}" -gt "${END[$i]}" ]
		then
			#Reverse complements the contig sequences and writes it to a temporary file
			awk 'BEGIN{RS=">";FS="\n";a["T"]="A";a["A"]="T";a["C"]="G";a["G"]="C";a["N"]="N"}NR>1{for (i=2;i<=NF;i++) seq=seq""$i;for(i=length(seq);i!=0;i--) {k=substr(seq,i,1);x=x a[k]}; printf ">%s\n%s",$1,x}' $NAME.temp.fasta$i >> $NAME.fasta.REV$i

			#Changes the length of the lines of the temporary file
			awk 'BEGIN{RS=">";FS="\n"}NR>1{seq="";for (i=2;i<=NF;i++) seq=seq""$i;a[$1]=seq;b[$1]=length(seq)}END{for (i in a) {k=sprintf("%d", (b[i]/'$LINE_LEN')+1); printf ">%s\n",i;for (j=1;j<=int(k);j++) printf "%s\n", substr(a[i],1+(j-1)*'$LINE_LEN','$LINE_LEN')}}' $NAME.fasta.REV$i >> $NAME.fasta.REVLINE$i

			#Replaces the original temp file with the reverse complemented file
			mv $NAME.fasta.REVLINE$i $NAME.temp.fasta$i
		fi
	done

	#Add strain name to contigs
	cat $NAME.temp.fasta* > $NAME.contigs.fasta
	sed -i s/\>/\>$NAME\_/g $NAME.contigs.fasta
 fi
done

#Remove all temporary files
rm *.temp.fasta*
rm *.REV*
