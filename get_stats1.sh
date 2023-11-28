# write to file stats.txt
echo "Read alignment statistics" > stats.txt

for file in $@ 
do
	echo "\n"$file >> stats.txt
	echo "QC-passed reads:" >> stats.txt
	# samtools flagstat has been run and output saved in flagstat
	head -n 1 $file/flagstat.txt | cut -d " " -f1 >> stats.txt

	# line 7 contains #alignments
	echo "Alignments:" >> stats.txt
	head -n 7 $file/flagstat.txt | tail -n 1 | cut -d " " -f1 >> stats.txt

	# line 12 contains #properly paired alignments
	echo "Properly paired:" >> stats.txt
	head -n 12 $file/flagstat.txt | tail -n 1 | cut -d " " -f1 >> stats.txt

	# Cufflinks output
	echo "\nTranscript assembly statistics" >> stats.txt
	echo "Genes:" >> stats.txt
	cut -f9 $file/cufflinks/transcripts.gtf | cut -d " " -f2 | sort -u | wc -l >> stats.txt

	echo "Transcripts:" >> stats.txt
	cut -f9 $file/cufflinks/transcripts.gtf | cut -d " " -f4 | sort -u | wc -l >> stats.txt
done
