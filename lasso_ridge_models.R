library(tidyverse)
library(glmnet)

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


x <- as.matrix(Split.DF$train[,-c(1, 2, 3, 13, 14)])
y_train <- Split.DF$train$pick

x_test <- as.matrix(Split.DF$test[,-c(1, 2, 3, 13, 14)])
y_test <- Split.DF$test$pick

lambdas <- 10^seq(2, -3, by = -.1)

ridge.reg <- glmnet(x, y_train, nlambda = 25, alpha = 0, family = 'poisson', lambda = lambdas)

summary(ridge.reg)
plot(ridge.reg)

lasso.reg <- glmnet(x, y_train, nlambda = 25, alpha = 1, family = 'poisson', lambda = lambdas)

summary(lasso.reg)
plot(lasso.reg)

cv_ridge <- cv.glmnet(x, y_train, alpha = 0, lambda = lambdas)
optimal_lambda.ridge <- cv_ridge$lambda.min
optimal_lambda.ridge

cv_lasso <- cv.glmnet(x, y_train, alpha = 1, lambda = lambdas)
optimal_lambda.lasso <- cv_ridge$lambda.min
optimal_lambda.lasso


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

lasso_model <- glmnet(x, y_train, alpha = 1, lambda = optimal_lambda.lasso, standardize = TRUE)

predictions_train <- predict(lasso_model, s = optimal_lambda.lasso, newx = x)
eval_results(y_train, predictions_train, Split.DF$train)

predictions_test <- predict(lasso_model, s = optimal_lambda.lasso, newx = x_test)
eval_results(y_test, predictions_test, Split.DF$test)

predictions_validate <- predict(lasso_model, s = optimal_lambda.lasso, newx = as.matrix(Split.DF$validate[,-c(1, 2, 3, 13, 14)]))
eval_results(Split.DF$validate$pick, predictions_validate, Split.DF$validate)



ridge_model <- glmnet(x, y_train, alpha = 0, lambda = optimal_lambda.ridge, standardize = TRUE)

predictions_train <- predict(ridge_model, s = optimal_lambda.ridge, newx = x)
eval_results(y_train, predictions_train, Split.DF$train)

predictions_test <- predict(ridge_model, s = optimal_lambda.ridge, newx = x_test)
eval_results(y_test, predictions_test, Split.DF$test)

predictions_validate <- predict(ridge_model, s = optimal_lambda.ridge, newx = as.matrix(Split.DF$validate[,-c(1, 2, 3, 13, 14)]))
eval_results(Split.DF$validate$pick, predictions_validate, Split.DF$validate)