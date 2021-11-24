# Base Image
FROM bioconductor/bioconductor_docker:RELEASE_3_14

# Install R Packages
RUN curl https://raw.githubusercontent.com/kokitsuyuzaki/reproducible-tools-exercise-r/main/reductDims.R > /reductDims.R \
	&& curl https://raw.githubusercontent.com/kokitsuyuzaki/reproducible-tools-exercise-r/main/cmd_reductDims.R > cmd_reductDims.R \
	&& R -e 'install.packages(c("Rtsne", "irlba"), repos="http://cran.r-project.org")'