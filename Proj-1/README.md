BIOS 611 NFL Project 1
======================

This repo contains an analysis of NFL combine and draft data from the year 2000 on. Data initially taken from kaggle at: https://www.kaggle.com/toddsteussie/nfl-play-statistics-dataset-2004-to-present

PROPOSAL
--------

### INTRODUCTION:
  
  The NFL Draft is one of the of the biggest sport drafts in the world. Teams will spend millions of dollars on players that they think will help their team win and reach the Superbowl. With all this money changing hands comes a lot of risk and a lot of questions about what stats are important for deciding what players to draft. The NFL combine allows teams to see how players match up against each other in physical challenges. Teams will use the results of these tests, along with college stats and performance, to decide if and when they should draft a player. 
  
  This project will shed light on what combine stats are most important for deciding when a plyer should be drafted dependent on the position of the player. Using predictive modeling techniques and machine learning, we will try to predict when a player will get drafted based on their performance in the combine. 




USAGE
-----
You will neeed Docker and the ability to run Docker as your current user. 

This Docker container is based on rocker verse. To connect run
    > docker run -v `pwd`:/home/rstudio -p 8787:8787 -e PASSWORD=mypass -t project-env
    
Then connect to machine on port 8787