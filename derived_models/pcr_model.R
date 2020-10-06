library("tidyverse")
library("pls")

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

pcr.mod <- pcr(pick ~ heightInches + 
                 weight + 
                 ageAtDraft + 
                 combine40yd + 
                 combineVert + 
                 combineBench +
                 combineShuttle +
                 combineBroad +
                 combine3cone, data = Split.DF$train, scale = T, validation = "CV")
summary(pcr.mod)

validationplot(pcr.mod, val.type = "R2")

predictions.pcr <- predict(pcr.mod, newdata = Split.DF$test, ncomp = 3)
SSE.pcr <- sum((predictions.pcr - Split.DF$test$pick)^2)
RMSE.pcr <- sqrt(SSE.pcr/nrow(Split.DF$test))
RMSE.pcr

saveRDS(pcr.mod, "derived_models/best.pcr.mod.rds")
