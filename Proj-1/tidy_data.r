library(tidyverse)

Draft <- read.csv("source_data/draft.csv")
Combine <- read.csv("source_data/combine.csv")

#I'm thinking i'm going to use only data from 2000 on. I think these observations will be more complete. Also since the game has changed so much, this sort of analysis is only really relevant in the modern era of football. I also do not need a lot of these variables, lets select important ones 
Comb.2000 <- Combine %>% 
  filter(combineYear >= 2000) %>% 
  select(1:6, 8:18, 28:33)
Draft.2000 <- Draft %>% 
  filter(draft >= 2000) %>% 
  select(1:19)

#ok lets take out any rows with an NA just to see
Comb.compl <- na.omit(Comb.2000) 
Draft.compl <- na.omit(Draft.2000)


write.csv(Draft.compl, "derived_data/draft.csv")
write.csv(Combine.compl, "derived_data/combine.csv")

