# Base Image
FROM bioconductor/bioconductor_docker:RELEASE_3_14

# Download from GitHub
ADD https://raw.githubusercontent.com/kokitsuyuzaki/reproducible-tools-exercise-r/main/reductDims.R /
ADD https://raw.githubusercontent.com/kokitsuyuzaki/reproducible-tools-exercise-r/main/cmd_reductDims.R /

# Install R Packages
RUN R -e 'install.packages(c("Rtsne", "irlba"), repos="http://cran.r-project.org")'