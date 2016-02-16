## DropSeq clustering analysis
## Feb 12, 2016

## Min Zhang

library(pheatmap)

## 200 top cell barcodes of human cells L2 data
inputpath <- "/Users/minzhang/Documents/data/P56_dropseq/runL2test/hg19.L2/mixall.collapsed.txt"



input <- read.table(inputpath, header = T, sep = "\t", row.names = 1)
head(input)

## g2 
cell.cycle <- read.table("/Users/minzhang/Documents/data/P56_dropseq/DropSeq/data/cellCycleMarkers.csv", sep = ",", header = T, strip.white = T)

head(cell.cycle)
cell.cycle

input2 <- input[, colSums(input[,1:200]) >= 1000] ## 1000 cutoff, 112 genes
input2$gene <- input$gene
input.g1s <- input2[input2$gene %in% cell.cycle$G1S, 1:112]
input.s <- input2[input2$gene %in% cell.cycle$S, 1:112]
input.g2m <- input2[input2$gene %in% cell.cycle$G2M, 1:112]
input.m <- input2[input2$gene %in% cell.cycle$M, 1:112]
input.mg1 <- input2[input2$gene %in% cell.cycle$MG1, 1:112]


input.cell.cycle2 <- rbind(colSums(input.g1s), colSums(input.s), colSums(input.g2m), colSums(input.m), colSums(input.mg1))
input.cell.cycle2

input.cell.cycle3 <- data.frame(input.cell.cycle2, (apply(-input.cell.cycle2, 2, rank)))
input.cell.cycle3
input.cell.cycle3[input.cell.cycle3 == 5] <- 25
input.cell.cycle3[input.cell.cycle3 == 4.5] <- 12
input.cell.cycle3[input.cell.cycle3 == 4] <- 6
input.cell.cycle3[input.cell.cycle3 == 3.5] <- 3
input.cell.cycle3[input.cell.cycle3 == 3] <- 2
input.cell.cycle3[input.cell.cycle3 == 2.5] <- 1
input.cell.cycle3[input.cell.cycle3 == 2] <- 0
input.cell.cycle3[input.cell.cycle3 == 1.5] <- 0
input.cell.cycle3[input.cell.cycle3 == 1] <- 0

## not good separation using raw number

library("colorspace")

set.seed(41)
pheatmap(input.cell.cycle3, scale = "column", cluster_rows = T, cluster_cols = T, cutree_cols = 1, treeheight_row = F, treeheight_col = F, legend_labels = F, color = diverge_hcl(30, alpha = 1), labels_col = T, border_color = "none")

p

input.cell.cycle3

