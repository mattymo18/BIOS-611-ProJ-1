library(tidyverse)

DF.Off.skill <- read.csv("derived_data/Off.Skill.csv") %>% 
  mutate(Type = "1") #skill is 1, strength is 2, linebacker is 3
DF.Off.strength <- read.csv("derived_data/Off.Strength.csv") %>% 
  mutate(Type = "2")
DF.Def.skill <- read.csv("derived_data/Def.Skill.csv" )%>% 
  mutate(Type = "1")
DF.Def.strength <- read.csv("derived_data/Def.Strength.csv" )%>% 
  mutate(Type = "2")
DF.Def.LBs <- read.csv("derived_data/Def.LBs.csv") %>% 
  mutate(Type = "3")
Skill.Stren.DF <- rbind(DF.Off.skill, DF.Off.strength, DF.Def.strength, DF.Def.skill, DF.Def.LBs)

set.seed = 18 #my favorite number


# Clustering
##################
  
#TSNE
##################
library(Rtsne)
fit1 <- Rtsne(Skill.Stren.DF %>% select(heightInches, weight, 7:12), dims=2, check_duplicates = F)
g1 <- ggplot(fit1$Y %>% as.data.frame() %>% as_tibble(), aes(V1,V2)) +
  geom_point(aes(color=Skill.Stren.DF$Type)) +
  scale_color_discrete(name="Type", labels = c("Skill", "Strength", "Mixed"))
ggsave("derived_graphs/TSNE.Cluster.png", plot = g1)



# K-Means
#################
cc <- kmeans(Skill.Stren.DF %>% select(heightInches, weight, 7:12), 3)
fit1 <- Rtsne(Skill.Stren.DF %>% select(heightInches, weight, 7:12), dims=2, check_duplicates = F)
g2 <- ggplot(fit1$Y %>% as.data.frame() %>% as_tibble() %>% mutate(label=cc$cluster),aes(V1,V2)) +
  geom_point(aes(color=factor(label))) +
  scale_color_discrete(name="Type", labels = c("Skill", "Strength", "Mixed"))
ggsave("derived_graphs/K-Means.Cluster.png", plot = g1)

