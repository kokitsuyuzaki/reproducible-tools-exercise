FROM bioconductor/bioconductor_docker:RELEASE_3_14

ADD ../r/pca.R

RUN apt-get update \
	&& apt-get install -y --no-install-recommends apt-utils \
	libmysqlclient-dev \
	libgdal-dev \
	texlive \
	texlive-latex-extra \
	texlive-fonts-extra \
	texlive-bibtex-extra \
	texlive-science \
	texi2html \
	texinfo \
	lmodern \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	## Install Packages
	&& R -e 'install.packages("BiocManager", repos="http://cran.r-project.org"); BiocManager::install(version = "devel"); BiocManager::valid(); BiocManager::install(c("BiocStyle", "knitr",  "rmdformats", "formatR", "magick", "biomaRt", "AnnotationHub", "meshr", "MeSHDbi", "readxl", "tagcloud", "RColorBrewer"), suppressUpdates=TRUE, force=TRUE)'