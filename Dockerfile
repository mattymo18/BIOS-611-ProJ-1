FROM rocker/verse
MAINTAINER Matt Johnson <Johnson.Matt1818@gmail.com>
RUN R -e "install.packages('gridExtra')"
RUN R- -e "install.packages('class')"
RUN R- -e "install.packages('Rtsne')"
RUN R- -e "install.packages('glmnet')"