# Feb 6, 2016

## overlay mouse and human dropseq

inputPath <- "/Users/minzhang/Documents/data/P56_dropseq/MH-L1-32920888/Data/Intensities/BaseCalls/readCountHumanMouse.txt"

inputPath <- "/Users/minzhang/Documents/data/P56_dropseq/runL2test/readCountHumanMouse.txt"

# L2
inputPath <- "/Users/minzhang/Documents/data/P56_dropseq/results/readCountHumanMouseL2.txt"

input <- read.table(inputPath, header = F, sep = "\t", row.names = 1)

colnames(input) <- c("Human Reads", "Mouse Reads")


plot(input$`Human Reads`, input$`Mouse Reads`
     #, xlim=c(0,3000)
     #, ylim = c(0, 3000)
     , log = "yx"
     , pch = 19, col = ifelse(input$`Human Reads` <= 10, "darkred", ifelse(input$`Mouse Reads`<= 10, "darkblue", "cornflowerblue")), cex = 0.1, xlab = "Human Reads", ylab = "Mouse Reads")

