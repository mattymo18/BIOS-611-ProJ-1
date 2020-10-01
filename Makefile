.PHONY: clean

clean:
	rm derived_data/*

derived_data/Off.Skill.csv derived_data/Off.Strength.csv\
derived_data/Def.Skill.csv dervied_data/Def.Strength.csv\
derived_data/Def.LBs.csv\
derived_data/Clean_Data.csv\
derived_data/combine.csv\
derived_data/draft.csv:\
 source_data/combine.csv\
 source_data/draft.csv\
 tidy_data.r
	Rscript tidy_data.r
	
	
	
derived_graphs/Off.Def.40s.png\
derived_graphs/Off.Weights.png\
derived_graphs/Age.Dist.png\
derived_graphs/Boxplot.by.round.png:\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 tidy_graphs.r
	Rscript tidy_graphs.r