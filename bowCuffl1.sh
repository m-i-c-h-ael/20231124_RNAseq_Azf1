# Number of threads to use
threads=3

# Take letter of sequencing file as input; move to the corresponding directory
letter=$@
cd /home/wrtlbrnft/RNAseq/$letter

# Unzip read files - not necessary for bowtie
#gunzip *.qfq.gz

# Align reads to reference genome
bowtie2 -p $threads -x /home/wrtlbrnft/RNAseq/yeast_refSeq/idx/S288c --end-to-end -1 *_1.fq.gz -2 *_2.fq.gz > align.bam
echo "Finished running bowtie2"

# Get stats
samtools flagstat align.bam > flagstat.txt
echo "Finished getting flagstats"

# Create corresponding .bam file and sort it
#samtools view -b align.sam > align.bam
samtools sort -o align_sort.bam align.bam
echo "Finished sorting align.bam"

# run cufflinks and store results in cufflinks folder
mkdir ./cufflinks
cufflinks -g /home/wrtlbrnft/RNAseq/GCF_000146045.2_R64.ncbiRefSeq.gtf -o ./cufflinks -p $threads -L $letter align_sort.bam
echo "Finished transcript assembly (Cufflinks)"

# compare to reference genome and move results to cmp subfolder
cuffcompare -r /home/wrtlbrnft/RNAseq/GCF_000146045.2_R64.ncbiRefSeq.gtf -R -o cmp cufflinks/transcripts.gtf
echo "Finished comparison to reference genome (Cuffcompare)"
echo "All done!"
