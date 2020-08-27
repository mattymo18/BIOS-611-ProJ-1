BIOS 611 NFL Project 1
======================

This repo will eventually contain an anlysis of NFL combine/draft data.



USAGE
-----
You will neeed Docker and the ability to run Docker as your current user. 

This Docker container is based on rocker verse. To connect run
    > docker run -v `pwd`:/home/rstudio -p 8787:8787 -e PASSWORD=mypass -t project-env
    
The connect to machine on port 8787