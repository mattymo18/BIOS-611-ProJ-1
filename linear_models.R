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
DF.Def.LBs <- read.csv("derived_data/Def.LBs.csv") %>% 
  mutate(Type = "3")
Skill.Stren.DF <- rbind(DF.Off.skill, DF.Off.strength, DF.Def.strength, DF.Def.skill, DF.Def.LBs)


lm1 <- lm(pick ~ heightInches + 
            weight + 
            ageAtDraft + 
            combine40yd + 
            combineVert + 
            combineBench +
            combineShuttle +
            combineBroad +
            combine3cone, data = Split.DF$train)
summary(lm1)
lm2 <- step(lm1, trace = 0)
summary(lm2)
anova(lm1, lm2)
plot(lm2)

library(car)
bc <- boxCox(lm1)
lam <- bc$x[which.max(bc$y)]
lm3 <- lm((pick)^lam ~ heightInches + 
            weight + 
            ageAtDraft + 
            combine40yd + 
            combineVert + 
            combineBench +
            combineShuttle +
            combineBroad +
            combine3cone, data = Split.DF$train)
summary(lm3)

lm4 <- step(lm3, trace = 0)
summary(lm4)

anova(lm3, lm4)

predictions.lm4 <- predict(lm4, Split.DF$test[, -c(1, 2, 3, 13, 14)])
SSE.lm4 <- sum((predictions.lm4 - Split.DF$test$pick)^2)
RMSE.lm4 <- sqrt(SSE.lm4/nrow(Split.DF$test))
RMSE.lm4