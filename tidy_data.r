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
Draft.compl <- na.omit(Draft.2000)[, c(1, 3, 4)]


write.csv(Draft.compl, "derived_data/draft.csv")
write.csv(Comb.compl, "derived_data/combine.csv")

#join data into single clean df
DF.clean <- na.omit(left_join(Comb.compl, Draft.compl, by = "playerId")[, -c(1, 3, 4:9, 11:13, 16)])
DF.clean$position <- factor(DF.clean$position)
write.csv(DF.clean, "derived_data/Clean_Data.csv")

#split data into 4 groups
DF.Off.skill <- DF.clean %>% 
  filter(position == "WR" | position == "RB" | position == "TE")
DF.Off.strength <- DF.clean %>% 
  filter(position == "C" | position == "OG" | position == "OT" | position == "OL")
DF.Def.skill <- DF.clean %>% 
  filter(position == "DB" | position == "S")
DF.Def.strength <- DF.clean %>% 
  filter(position == "DE" | position == "DL" | position == "DT" | position == "LB" | position == "OLB")

#save new csv's
write.csv(DF.Off.skill, "derived_data/Off.Skill.csv")
write.csv(DF.Off.strength, "derived_data/Off.Strength.csv")
write.csv(DF.Def.skill, "derived_data/Def.Skill.csv")
write.csv(DF.Def.strength, "derived_data/Def.Strength.csv")

