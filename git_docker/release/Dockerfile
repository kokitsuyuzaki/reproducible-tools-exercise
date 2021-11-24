# Base Image
FROM bioconductor/bioconductor_docker:RELEASE_3_14

# Download from GitHub
ADD https://github.com/kokitsuyuzaki/reproducible-tools-exercise-r/archive/refs/tags/v1.0.tar.gz /

# Install R Packages
RUN tar -zxvf v1.0.tar.gz \
	&& cp reproducible-tools-exercise-r-1.0/*.R . \
	&& R -e 'install.packages(c("Rtsne", "irlba"), repos="http://cran.r-project.org")'