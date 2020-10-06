library(tidyverse)

DF.Off.skill <- read.csv("derived_data/Off.Skill.csv") %>% 
  mutate(Type = "1") #skill is 1, strength is 2, linebacker is 3
DF.Off.strength <- read.csv("derived_data/Off.Strength.csv") %>% 
  mutate(Type = "2")
DF.Def.skill <- read.csv("derived_data/Def.Skill.csv" )%>% 
  mutate(Type = "1")
DF.Def.strength <- read.csv("derived_data/Def.Strength.csv" )%>% 
  mutate(Type = "2")
DF.Mixed <- read.csv("derived_data/DF.Mix.csv") %>% 
  mutate(Type = "3")
Skill.Stren.DF <- rbind(DF.Off.skill, DF.Off.strength, DF.Def.strength, DF.Def.skill, DF.Mixed)

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
ggsave("derived_graphs/K-Means.Cluster.png", plot = g2)


# Principle Component Analysis
##################
library(ggfortify)
library(cluster)
pcs <- prcomp(Skill.Stren.DF %>% select(heightInches, weight, 7:12), scale. = T)
g3 <- autoplot(pcs, loadings=T, loadings.colour = 'blue', loadings.label.size = 6)
g4 <- autoplot(pam(Skill.Stren.DF %>% select(heightInches, weight, 7:12), 3), frame = T, fram.type = 'norm') +
  scale_color_discrete(name="Type", labels = c("Skill", "Strength", "Mixed"))+
  guides(fill = F)
g5 <- autoplot(silhouette(pam(Skill.Stren.DF %>% select(heightInches, weight, 7:12), 3)))

ggsave("derived_graphs/PCA.Eignen.png", plot = g3)
ggsave("derived_graphs/PCA.FramedClusters.png", plot = g4)
ggsave("derived_graphs/PCA.Silhouette.png", plot = g5)

