BIOS 611 NFL Project 1
======================

This repo contains an analysis of NFL combine and draft data from the year 2000\
on. Data initially taken from kaggle at: https://www.kaggle.com/toddsteussie/nfl-play-statistics-dataset-2004-to-present



USAGE
-----
You will neeed Docker and the ability to run Docker as your current user. 

This Docker container is based on rocker verse. To connect run
    > docker run -v `pwd`:/home/rstudio -p 8787:8787 -e PASSWORD=mypass -t project-env
    
Then connect to machine on port 8787