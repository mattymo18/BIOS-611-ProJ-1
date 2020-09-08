library(tidyverse)
library(gridExtra)

#load in data
DF.Off.skill <- read.csv("derived_data/Off.Skill.csv")
DF.Off.strength <- read.csv("derived_data/Off.Strength.csv")
DF.Def.skill <- read.csv("derived_data/Def.Skill.csv")
DF.Def.strength <- read.csv("derived_data/Def.Strength.csv")

#graph 1

g1 <- ggplot(DF.Off.skill, mapping = aes(x = combine40yd, y = pick, color = position)) +     geom_point(alpha = .5) +
  xlab("40 Time") +
  ylab("Pick") +
  labs(color = "Position", title = "Offense") +
  xlim(4, 5.2) +
  theme(legend.position = c(0, 1),
        legend.justification = c(0, 1))

g3 <- ggplot(DF.Def.skill, mapping = aes(x = combine40yd, y = pick, color = position)) +     geom_point(alpha = .5) +
  xlab("40 Time") +
  ylab("Pick") +
  labs(color = "Position", title = "Defense") +
  xlim(4, 5.2) +
  theme(legend.position = c(0, 1),
        legend.justification = c(0, 1))

Graph1 <- grid.arrange(g1, g3, nrow=1)
ggsave("derived_graphs/Off.Def.40s.png", plot = Graph1)


#graph 2

g5 <- ggplot(DF.Off.skill, aes(weight)) +
  geom_density(aes(color=position), alpha=.5) +
  xlim(170, 400) +
  xlab("Weights") +
  ylab("") +
  labs(color="Position") +
  theme(legend.position = c(0, 1),
        legend.justification = c(0, 1))

g6 <- ggplot(DF.Off.strength, aes(weight)) +
  geom_density(aes(color=position), alpha=.5) +
  xlim(170,400) +
  xlab("Weights") +
  ylab("") +
  labs(color="Position") +
  theme(legend.position = c(0, 1),
        legend.justification = c(0, 1))

Graph2 <- grid.arrange(g5, g6, nrow=1, top = "Weight Distribution by Position (Offense)")
ggsave("derived_graphs/Off.Weights.png", plot = Graph2)


#graph 3

g7 <- ggplot(DF.Off.skill, aes(ageAtDraft)) +
  geom_histogram(aes(fill = position), position = "dodge") +
  xlab("Age at Draft") +
  ylab("Count") +
  labs(fill = "Position", title = "Offense Skill") +
  theme(legend.position = c(0, 1),
        legend.justification = c(0, 1),
        legend.key.size = unit(.25, "cm")) +
  theme(axis.text.y=element_blank())

g8 <- ggplot(DF.Off.strength, aes(ageAtDraft)) +
  geom_histogram(aes(fill = position), position = "dodge") +
  xlab("Age at Draft") +
  ylab("Count") +
  labs(fill = "Position", title = "Offense Line") +
  theme(legend.position = c(0, 1),
        legend.justification = c(0, 1),
        legend.key.size = unit(.25, "cm")) +
  theme(axis.text.y=element_blank())

g9 <- ggplot(DF.Def.skill, aes(ageAtDraft)) +
  geom_histogram(aes(fill = position), position = "dodge") +
  xlab("Age at Draft") +
  ylab("Count") +
  labs(fill = "Position", title = "Defense Skill") +
  theme(legend.position = c(0, 1),
        legend.justification = c(0, 1),
        legend.key.size = unit(.25, "cm")) +
  theme(axis.text.y=element_blank())

g10 <- ggplot(DF.Def.strength, aes(ageAtDraft)) +
  geom_histogram(aes(fill = position), position = "dodge") +
  xlab("Age at Draft") +
  ylab("Count") +
  labs(fill = "Position", title = "Defense Line") +
  theme(legend.position = c(0, 1),
        legend.justification = c(0, 1),
        legend.key.size = unit(.25, "cm")) +
  theme(axis.text.y=element_blank())

Graph3 <- grid.arrange(g7, g8, g9, g10, nrow=2, top = "Age Distribution by Position")
ggsave("derived_graphs/Age.Dist.png", plot=Graph3)
