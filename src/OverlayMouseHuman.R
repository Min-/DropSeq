# Min Zhang
# DropSeq pipeline for read distribution analysis

# Feb 6, 2016
# v0.1.0: init generate scatter plot for human, mouse transcript seperation

# update Feb 10, 2016
# v0.1.1: analyse the distribution of reads for each cell barcodes

## overlay mouse and human dropseq

inputPath <- "/Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/readCountHumanMouse.txt"

inputPath <- "/Users/minzhang/Documents/data/P56_dropseq/runL2test/readCountHumanMouse.txt"

# L2
inputPath <- "/Users/minzhang/Documents/data/P56_dropseq/results/readCountHumanMouseL2.txt"

input <- read.table(inputPath, header = F, sep = "\t", row.names = 1)

colnames(input) <- c("Human Reads", "Mouse Reads")

## plotting between two species
plot(input$`Human Reads`, input$`Mouse Reads`
     , xlim=c(0,10000)
     , ylim = c(0, 10000)
     #, log = "yx"
     , pch = 19, col = ifelse(input$`Human Reads` <= 100, "darkred", ifelse(input$`Mouse Reads`<= 100, "darkblue", "cornflowerblue")), cex = 0.1, xlab = "Human Reads", ylab = "Mouse Reads")

## distribution
head(input)
hist(log(input$`Human Reads`+1))
hist(log(input$`Mouse Reads`+1))

quantile(input$`Human Reads`, seq(0.99,1,0.0001))

# 472 cells are top 0.2% percentile for human data (542.000 reads for 99.8% quantile)

0.1*0.01*238246

quantile(input$`Mouse Reads`, seq(0.99,1,0.0001))
# mouse take top 0.1% reads, 99.9% 535 reads

# total reads from human or mouse
colSums(input)
# Human Reads Mouse Reads 
# 3211681     2041193 
# for human 542/3211681 = 0.000168759
# for mouse 535/2041193 = 0.0002621016

## shrink count list
abudant.cells <- input[input$`Human Reads` >= 1500 | input$`Mouse Reads` >= 1500, ]
# 673 total

## plot again, use log scale of axes, clearly three categories, use kmean to cluster them
plot(abudant.cells$`Human Reads` + 1, abudant.cells$`Mouse Reads` + 1, cex=0.2, pch = 19, log = "xy")

set.seed(124)
abudant.cells.kmean <- kmeans(log(abudant.cells+1), iter.max = 10, centers = 4)
cluster.color <- function()
  {  a <- abudant.cells.kmean$cluster;
     col <-  ifelse(a == 1, "red",
               ifelse(a == 2, "blue",
                 ifelse(a == 3, "green",
                        "orange")))
     return(col)
  }

plot(log(abudant.cells$`Human Reads` + 1), log(abudant.cells$`Mouse Reads` + 1), cex=0.2, pch = 19, col = cluster.color())

## number of cells in each clusters
abudant.cells.kmean$size
# human only 1 + 3 
# 35 + 248 = 283
# 283/673 = 42.0%

# mouse only 2
195
# 195/673 = 28.9%

# double 4
196
# 196/673 = 29.1%

## estimate how many cells to include based on percentage of mix population
mixedCutoff <- function(){
  interval <- seq(0.999,1,0.0001)
  counter <- seq(1, length(interval), 1)
  human.quantile <- quantile(input$`Human Reads`, interval)
  mouse.quantile <- quantile(input$`Mouse Reads`, interval)
  cell.populations <- Map(function(n){ input[input$`Human Reads` >= human.quantile[n] | input$`Mouse Reads` >= mouse.quantile[n], ] }, counter)
  results <- Map(function(x){dim(x)[1]}, cell.populations)
  return(data.frame(unlist(results), interval))
}

mixedCutoff()

### visualize

cutoff <- 0.9995
human.q <- quantile(input$`Human Reads`, cutoff)
mouse.q <-  quantile(input$`Mouse Reads`, cutoff)
abudant.cells <- input[input$`Human Reads` >= human.q | input$`Mouse Reads` >= mouse.q, ]
plot(abudant.cells$`Human Reads` + 1, abudant.cells$`Mouse Reads` + 1, cex=0.2, pch = 19, log = "xy")

set.seed(124)
abudant.cells.kmean <- kmeans(log(abudant.cells+1), iter.max = 10, centers = 4)
cluster.color <- function()
{  a <- abudant.cells.kmean$cluster;
col <-  ifelse(a == 1, "red",
               ifelse(a == 2, "blue",
                      ifelse(a == 3, "green",
                             ifelse(a == 4, "orange",
                                    "darkgreen"))))
return(col)
}

plot(log(abudant.cells$`Human Reads` + 1), log(abudant.cells$`Mouse Reads` + 1), cex=0.2, pch = 19, col = cluster.color())
abudant.cells.kmean$size
# 0.9995 human: 97, mouse: 113, mix 26, seed 124

# 0.996, human: 94-3, mouse 95-17=78, seed 615, 10.5%