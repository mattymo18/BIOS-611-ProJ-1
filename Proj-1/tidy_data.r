library(tidyverse)

Draft <- read.csv("source_data/draft.csv")
Combine <- read.csv("source_data/combine.csv")

#do some work here


write.csv(Draft, "derived_data/draft.csv")
write.csv(Combine, "derived_data/combine.csv")

