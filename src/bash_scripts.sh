uniq -c /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R1_001.seq.cellBarcode.sorted.fastq | sort - -rnk1,1 > /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R1_001.seq.cellBarcode.sorted.unique.count.sorted.fastq

cut -c 13-20 /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R1_001.seq.fastq > /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R1_001.seq.umi.fastq

bowtie2 -q --very-fast -x /Users/minzhang/Documents/data/genome_reference/hg19/hg19 -U /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R2_001.fastq -S /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R2_001.fastq.bowtie2.mapped.mm9.sam

# uniquely mapped / or, just mapped reads
samtools view -bS /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R2_001.fastq.bowtie2.mapped.hg19.sam | samtools view -F 4 - > /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R2_001.fastq.bowtie2.mapped.hg19.mappedOnly.sam


cut -d$'\t' -f1 /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R2_001.fastq.bowtie2.mapped.hg19.mappedOnly.sam | sort - > /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R2_001.fastq.bowtie2.mapped.hg19.mappedOnly.readname.txt

comm -12 /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R2_001.fastq.bowtie2.mapped.mm9.mappedOnly.readname.txt /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R2_001.fastq.bowtie2.mapped.hg19.mappedOnly.readname.txt > /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/commonmapped.readnames.txt

## slow, use a lot of memory
grep -vf /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/commonmapped.readnames.txt /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R2_001.fastq.bowtie2.mapped.mm9.mappedOnly.readname.txt > /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/uniquemapped.mm9.readnames.txt

## sort doesn't use a lot of memory
sort /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R2_001.fastq.bowtie2.mapped.mm9.mappedOnly.readname.txt /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/commonmapped.readnames.txt | uniq -u > /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/uniquemapped.mm9.readnames.txt

join /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/uniquemapped.hg19.readnames.txt /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/name_cellbarcode.txt > /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/uniqueCellbarcode_mappedto_hg19.txt

sort /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/mapped.mm9.cellbarcodes.txt | uniq -c - | sort - -rnk1,1 > /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/mapped.mm9.cellbarcodes.uniqueCount.txt

 paste -d"\t" /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R1_001.name.fastq /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/MH-L1_S1_L001_R1_001.seq.cellBarcode.fastq | sort -k1,1 -  > /Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/name_cellbarcode.txt


