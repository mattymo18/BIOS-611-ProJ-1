library(tidyverse)
library(pls)
library(randomForest)
library(xtable)
library(glmnet)
library(gbm)
library(knitr)

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

pcr <- readRDS("derived_models/best.pcr.mod.rds")
rf <- readRDS("derived_models/best.rf.mod.rds")
glm <-readRDS("derived_models/best.glm.mod.rds")
lm <- readRDS("derived_models/best.lin.mod.rds")
lasso <- readRDS("derived_models/best.lasso.mod.rds")
ridge <- readRDS("derived_models/best.ridge.mod.rds")
gbm <- readRDS("derived_models/best.gbm.mod.rds")


# Compute R^2 from true and predicted values
eval_results <- function(true, predicted, df) {
  SSE <- sum((predicted - true)^2)
  SST <- sum((true - mean(true))^2)
  R_square <- 1 - SSE / SST
  RMSE = sqrt(SSE/nrow(df))
  
  
  # Model performance metrics
  data.frame(
    RMSE = RMSE,
    Rsquare = R_square
  )
  
}

models <- c("PCR", "Random Forest", "GLM", "LM", "Lasso", "Ridge", "GBM")

predictions.pcr <- predict(pcr, newdata = Split.DF$validate[, -c(1, 2, 3, 13, 14)], ncomp = 3, type = "response")
predictions.rf <- predict(rf, newdata = Split.DF$validate[, -c(1, 2, 3, 13, 14)], type = "response")
predictions.glm <- predict(glm, newdata = Split.DF$validate[, -c(1, 2, 3, 13, 14)], type = "response")
predictions.lm <- predict(lm, newdata = Split.DF$validate[, -c(1, 2, 3, 13, 14)])

x <- as.matrix(Split.DF$validate[,-c(1, 2, 3, 13, 14)])
predictions.lasso <- predict(lasso, newdata = Split.DF$validate[, -c(1, 2, 3, 13, 14)], type = "response", newx = x)
predictions.ridge <- predict(ridge, newdata = Split.DF$validate[, -c(1, 2, 3, 13, 14)], type = "response", newx = x)

predictions.gbm <- predict(gbm, newdata = Split.DF$validate[, -c(1, 2, 3, 13, 14)], type = "response")

pcr.results <- eval_results(Split.DF$validate$pick, predictions.pcr, Split.DF$validate) %>% 
  mutate("Model" = "PCR")
rf.results <- eval_results(Split.DF$validate$pick, predictions.rf, Split.DF$validate)%>% 
  mutate("Model" = "Random Forest")
glm.results <- eval_results(Split.DF$validate$pick, predictions.glm, Split.DF$validate)%>% 
  mutate("Model" = "GLM")
lm.results <- eval_results(Split.DF$validate$pick, predictions.lm, Split.DF$validate)%>% 
  mutate("Model" = "LM")
lasso.results <- eval_results(Split.DF$validate$pick, predictions.lasso, Split.DF$validate)%>% 
  mutate("Model" = "Lasso")
ridge.results <- eval_results(Split.DF$validate$pick, predictions.ridge, Split.DF$validate)%>% 
  mutate("Model" = "Ridge")
gbm.results <- eval_results(Split.DF$validate$pick, predictions.gbm, Split.DF$validate)%>% 
  mutate("Model" = "GBM")

Results <- rbind(pcr.results, rf.results, glm.results, lm.results, lasso.results, ridge.results, gbm.results) %>% 
  select(Model, Rsquare, RMSE) %>% 
  arrange(RMSE)

RMSE.Table <- kable(Results)

saveRDS(RMSE.Table, "derived_graphs/RMSE.Table.rds")

