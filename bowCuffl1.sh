# Take letter of sequencing file as input; move to the corresponding directory
letter=$@
cd /home/wrtlbrnft/RNAseq/$letter

# Align reads to reference genome
bowtie2 -p 4 -x /home/wrtlbrnft/RNAseq/yeast_refSeq/idx/S288c -1 *_1.fq -2 *_2.fq --end-to-end -S align.sam

# Create corresponding .bam file and sort it
samtools view -b align.sam > align.bam
samtools sort -o align_sort.bam align.bam

# run cufflinks and store results in cufflinks folder
mkdir ./cufflinks
cufflinks -g /home/wrtlbrnft/RNAseq/GCF_000146045.2_R64.ncbiRefSeq.gtf -o ./cufflinks -p 4 -L $letter align_sort.bam

# compare to reference genome and move results to cmp subfolder
cuffcompare -r /home/wrtlbrnft/RNAseq/GCF_000146045.2_R64.ncbiRefSeq.gtf -R -o cmp cufflinks/transcripts.gtf
