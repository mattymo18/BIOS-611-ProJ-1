FROM rocker/verse
MAINTAINER Matt Johnson <Johnson.Matt1818@gmail.com>
RUN apt update -y && apt install -y python3-pip
RUN pip3 install jupyter jupyterlab
RUN pip3 install numpy pandas sklearn plotnine matplotlib pandasql bokeh
RUN R -e "install.packages('gridExtra')"
RUN R -e "install.packages('class')"
RUN R -e "install.packages('Rtsne')"
RUN R -e "install.packages('glmnet')"
RUN R -e "install.packages('ggfortify')"
RUN R -e "install.packages('cluster')"
RUN R -e "install.packages('randomForest')"
RUN R -e "install.packages('gbm')"
RUN R -e "install.packages('car')"
RUN R -e "install.packages('pls')"
RUN R -e "install.packages('xtable')"
RUN R -e "install.packages('shinythemes')"
RUN R -e "install.packages('shiny')"
RUN R -e "install.packages('caret')"
RUN R -e "install.packages('knitr')"