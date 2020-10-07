library(tidyverse)
library(randomForest)
library(knitr)

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

oob.err=double(9)
test.err=double(9)

for (mtry in 1:9) {

  rf1 <- randomForest(pick ~ heightInches +
                        weight +
                        ageAtDraft +
                        combineShuttle +
                        combineBroad +
                        combine3cone +
                        combineBench +
                        combine40yd +
                        combineVert,
                      data = Split.DF$train[, -c(1, 2, 3, 13)], mtry = mtry, ntree=500,
                      xtest = Split.DF$test[, -c(1, 2, 3, 13, 14)],
                      yest = Split.DF$test$pick, keep.forest = T)
  oob.err[mtry] = rf1$mse[500] #error of all trees fitted

  pred <- predict(rf1, Split.DF$test[, -c(1, 2, 3, 13, 14)], type = "response")
  test.err[mtry] = with(Split.DF$test[, -c(1, 2, 3, 13)], mean((pick - pred)^2))

  cat(mtry, " ")
}

which.min(test.err)


rf2 <- randomForest(pick ~ heightInches + 
                      weight + 
                      ageAtDraft +
                      combineShuttle + 
                      combineBroad + 
                      combine3cone + 
                      combineBench + 
                      combine40yd + 
                      combineVert, 
                    data = Split.DF$train[, -c(1, 2, 3, 13)], type = "regression", mtry = 4, ntree=500, 
                    xtest = Split.DF$test[, -c(1, 2, 3, 13, 14)], 
                    ytest = Split.DF$test$pick, keep.forest = T)

predictions.rf <- predict(rf2, Split.DF$test[, -c(1, 2, 3, 13, 14)])

SSE.rf <- sum((predictions.rf - Split.DF$test$pick)^2)
RMSE.rf <- sqrt(SSE.rf/nrow(Split.DF$test))
RMSE.rf

varImpPlot(rf2)
importance(rf2)

saveRDS(rf2, "derived_models/best.rf.mod.rds")

rf.importance.table <- kable(importance(rf2))

saveRDS(rf.importance.table, "derived_graphs/rf.importance.table.rds")
