# Base Image
FROM bioconductor/bioconductor_docker:RELEASE_3_14

# Download from GitHub
ADD https://github.com/kokitsuyuzaki/reproducible-tools-exercise-r/archive/refs/tags/first_commit.tar.gz /

# Install R Packages
RUN tar -zxvf first_commit.tar.gz \
	&& cp reproducible-tools-exercise-r-first_commit/*.R . \
	&& R -e 'install.packages(c("Rtsne", "irlba"), repos="http://cran.r-project.org")'