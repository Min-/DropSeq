#!/bin/bash

## Min Zhang
## Martin lab

## Feb 8, 2016
## v0.1.0

## input data

echo "DropSeqPipepline fastq1 fastq2 outputDirectory bowtieIndexFolder"

baseDir=$3

if [ ! -d "$3" ]; then
  mkdir $3
else
  echo "$3 is existed."
fi

gzip -dc < $1 > $baseDir/fastq1
gzip -dc < $2 > $baseDir/fastq2

## extract cell barcode, UMI, and readname

#readname
awk 'NR%4==1' $baseDir/fastq1 > $baseDir/fastq1.readname.txt

#barcodeSequence
awk 'NR%4==2' $baseDir/fastq1 > $baseDir/fastq1.seq.txt

#cellBarcode
cut -c 1-12 $baseDir/fastq1.seq.txt > $baseDir/fastq1.cellbarcode.txt
sort $baseDir/fastq1.cellbarcode.txt | uniq -c - | sort - -rnk1,1 > $baseDir/fastq1.cellbarcode.count.txt

#umiBarcode
cut -c 13-20 $baseDir/fastq1.seq.txt > $baseDir/fastq1.umi.txt
sort $baseDir/fastq1.umi.txt | uniq -c - | sort - -rnk1,1 > $baseDir/fastq1.umi.count.txt

#merge readname and cell barcode and sort by readname
paste -d"\t" $baseDir/fastq1.readname.txt $baseDir/fastq1.cellbarcode.txt | sort -k1,1 - > $baseDir/fastq1.readname.cellbarcode.sorted.txt

## mapping
bowtie2 -q --very-fast -x $4/hg19/hg19 -U $baseDir/fastq2 | samtools view -bS - | samtools view -F 4 - > $baseDir/hg19.mappedOnly.sam

bowtie2 -q --very-fast -x $4/mm9/mm9 -U $baseDir/fastq2 | samtools view -bS - | samtools view -F 4 - > $baseDir/mm9.mappedOnly.sam

# get readname for mapped reads
cut -d$'\t' -f1 $baseDir/hg19.mappedOnly.sam | sort - > $baseDir/hg19.mappedOnlyReadname.txt
cut -d$'\t' -f1 $baseDir/mm9.mappedOnly.sam | sort - > $baseDir/mm9.mappedOnlyReadname.txt

# overlay reads mapped to both hg19 and mm9
comm -12 $baseDir/hg19.mappedOnlyReadname.txt $baseDir/mm9.mappedOnlyReadname.txt > $baseDir/common.mapped.readnames.txt

# A2 = A1 - (overlay A1 B1)
sort $baseDir/hg19.mappedOnlyReadname.txt $baseDir/common.mapped.readnames.txt | uniq -u > $baseDir/unqiuemapped.hg19.readnames.txt
sort $baseDir/mm9.mappedOnlyReadname.txt $baseDir/common.mapped.readnames.txt | uniq -u > $baseDir/unqiuemapped.mm9.readnames.txt

## get cell barcode based on readnames; haskell code
## [input_hg19, input_mm9, name_cellbarcode, output_hg19, output_mm9]
/Users/minzhang/Documents/data/P56_dropseq/DropSeq/src/UniqueSpecies $baseDir/unqiuemapped.hg19.readnames.txt $baseDir/unqiuemapped.mm9.readnames.txt $baseDir/fastq1.readname.cellbarcode.sorted.txt $baseDir/mapped.hg19.cellbarcodes.txt $baseDir/mapped.mm9.cellbarcodes.txt

## sort and count cell barcodes
sort $baseDir/mapped.hg19.cellbarcodes.txt | uniq -c - | sort - -rnk1,1 > $baseDir/mapped.hg19.cellbarcodes.uniqueCount.txt
sort $baseDir/mapped.mm9.cellbarcodes.txt | uniq -c - | sort - -rnk1,1 > $baseDir/mapped.mm9.cellbarcodes.uniqueCount.txt

## count cell barcodes for each species
## OverlayMouseHuman
/Users/minzhang/Documents/data/P56_dropseq/DropSeq/src/OverlayMouseHuman $baseDir/mapped.hg19.cellbarcodes.uniqueCount.txt $baseDir/mapped.mm9.cellbarcodes.uniqueCount.txt $baseDir/readCountHumanMouse.txt 








