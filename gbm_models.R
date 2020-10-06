library(tidyverse)
library(gbm)

set.seed = 18

Clean_Data <- read.csv("derived_data/Clean_Data.csv") %>% 
  mutate(position = as.numeric(position))
DF.Off.skill <- read.csv("derived_data/Off.Skill.csv") %>% 
  mutate(Type = "1") #skill is 1, strength is 2, linebacker is 3
DF.Off.strength <- read.csv("derived_data/Off.Strength.csv") %>% 
  mutate(Type = "2")
DF.Def.skill <- read.csv("derived_data/Def.Skill.csv" )%>% 
  mutate(Type = "1")
DF.Def.strength <- read.csv("derived_data/Def.Strength.csv" )%>% 
  mutate(Type = "2")
DF.Mixed <- read.csv("derived_data/Df.Mix.csv") %>% 
  mutate(Type = "3")
Skill.Stren.DF <- rbind(DF.Off.skill, DF.Off.strength, DF.Def.strength, DF.Def.skill, DF.Mixed)

set.seed <- 18 #this is my lucky number 
spec = c(train = .6, test = .2, validate = .2)
DF = sample(cut(
  seq(nrow(Clean_Data)), 
  nrow(Clean_Data)*cumsum(c(0,spec)),
  labels = names(spec)
))

Split.DF = split(Clean_Data, DF)

gbm1 <-gbm(pick ~ heightInches + 
             weight + 
             ageAtDraft +
             combineShuttle + 
             combineBroad + 
             combine3cone + 
             combineBench + 
             combine40yd + 
             combineVert, 
           distribution = "gaussian", data = Split.DF$train[, -c(1, 2, 3, 13)], interaction.depth = 3, n.trees = 500)

summary(gbm1, plot = T)

predictions.gbm <- predict(gbm1, Split.DF$test[, -c(1, 2, 3, 13, 14)])
SSE.gbm <- sum((predictions.gbm - Split.DF$test$pick)^2)
RMSE.gbm <- sqrt(SSE.gbm/nrow(Split.DF$test))
RMSE.gbm

saveRDS(gbm1, "derived_models/best.gbm.mod.rds")