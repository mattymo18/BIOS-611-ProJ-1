library(tidyverse)

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


glm1 <- glm(pick ~ heightInches + 
              weight + 
              ageAtDraft + 
              combine40yd + 
              combineVert + 
              combineBench +
              combineShuttle +
              combineBroad +
              combine3cone, family = poisson, data = Split.DF$train)
anova(glm1, test = "Chisq")
step(glm1, direction = "both", trace = 0)

glm2 <- glm(pick ~ heightInches + 
              ageAtDraft + 
              combine40yd + 
              combineVert + 
              combineBench +
              combineShuttle +
              combineBroad +
              combine3cone, family = poisson, data = Split.DF$train)
summary(glm2)
anova(glm2, test = "Chisq")

predictions.glm1 <- predict(glm1, Split.DF$test[, -c(1, 2, 3, 13, 14)])
SSE.glm1 <- sum((predictions.glm1 - Split.DF$test$pick)^2)
RMSE.glm1 <- sqrt(SSE.glm1/nrow(Split.DF$test))
RMSE.glm1


predictions.glm2 <- predict(glm2, Split.DF$test[, -c(1, 2, 3, 13, 14)])
SSE.glm2 <- sum((predictions.glm2 - Split.DF$test$pick)^2)
RMSE.glm2 <- sqrt(SSE.glm2/nrow(Split.DF$test))
RMSE.glm2