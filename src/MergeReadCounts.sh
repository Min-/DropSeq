#!/bin/bash

## for i in ./hg19.L2.sams/*.sam;
## do 
##   makeTagDirectory $i.dir $i;
##   analyzeRepeats.pl rna hg19 -count exons -raw -d $i.dir > $i.count.txt;
##   rm -rf $i.dir;
## done

for i in $1/*.count.txt;
do
  tail -n +2 $i | sort -k1,1 - > $i.sorted.txt;
  rm $i;
done


