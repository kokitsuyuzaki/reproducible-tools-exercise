# r
## 対話的実行
1. Rを起動

2. 必要なパッケージ・関数を読み込み

```r
source("pca.R")
```

3. 以下の通りに関数を実行

```r
input <- read.csv("YOUR_CSV_FILE")
out <- reaductDims(
	input = input # User's CSV file
	dim_pca = 10, # Dimension of PCA
	dim_tsne = 2, # Dimension of t-SNE
	type_pca = "svd", # Type of PCA
	verbose = TRUE # verbose-mode
	)
plotDims(out)
```

## コマンド実行

```r
Rscript cmd_reductDims.R \
[YOUR_CSV_FILE] \
[Dimension of PCA] \
[Dimension of t-SNE] \
[Type of PCA] \
[verbose-mode] \
[Output file 1 (.RData)] \
[Output file 2 (.png)]
```