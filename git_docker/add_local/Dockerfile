# Base Image
FROM bioconductor/bioconductor_docker:RELEASE_3_14

# Download from GitHub
ADD reductDims.R /
ADD cmd_reductDims.R /

# Install R Packages
RUN R -e 'install.packages(c("Rtsne", "irlba"), repos="http://cran.r-project.org")'