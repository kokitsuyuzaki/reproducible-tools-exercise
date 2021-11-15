# Package/Function Loading
source("reductDims.R")

# Test
input <- matrix(runif(50*100), nrow=50, ncol=100)
out <- reductDims(
    input=input,
    dim_pca=10,
    dim_tsne=2,
    type_pca="svd",
    verbose=TRUE)
plotDims(out)
