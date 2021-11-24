# Command Line Arguments
args <- commandArgs(trailingOnly = TRUE)
input <- as.matrix(read.csv(args[1])) # User's CSV file
dim_pca <- as.numeric(args[2]) # Dimension of PCA
dim_tsne <- as.numeric(args[3]) # Dimension of t-SNE
type_pca <- args[4] # Type of PCA
verbose <- as.logical(args[5]) # verbose-mode
output1 <- args[6] # Output file 1 (.RData)
output2 <- args[7] # Output file 2 (.png)

# Package/Function Loading
source("reductDims.R")

# Dimension Reduction
out <- reductDims(
    input=input,
    dim_pca=dim_pca,
    dim_tsne=dim_tsne,
    type_pca=type_pca,
    verbose=verbose)
save(out, file=output1)

# Plot
png(file=output2, width=1000, height=500)
plotDims(out)
dev.off()
