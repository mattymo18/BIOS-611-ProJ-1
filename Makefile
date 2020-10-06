.PHONY: clean

clean:
	rm derived_data/*
	
Analysis.pdf: Analysis.Rmd\
 derived_graphs/Boxplot.by.round.png\
 derived_graphs/Off.Weights.png\
 derived_graphs/Age.Dist.png\
 derived_graphs/40.Time.Plot.png\
 derived_graphs/TSNE.Cluster.png\
 derived_graphs/K-Means.Cluster.png\
 derived_graphs/PCA.FramedClusters.png
	R -e "rmarkdown::render('Analysis.Rmd')"

derived_models/best.lasso.mod.rds\
derived_models/best.ridge.mod.rds:derived_data/Clean_Data.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Df.Mix.csv\
 lasso_ridge_models.R
	Rscript lasso_ridge_models.R

derived_models/best.glm.mod.rds: derived_data/Clean_Data.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Df.Mix.csv\
 glm_models.R
	Rscript glm_models.R

derived_models/best.gbm.mod.rds: derived_data/Clean_Data.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Df.Mix.csv\
 gbm_models.R
	Rscript gbm_models.R
	

derived_models/best.rf.mod.rds: derived_data/Clean_Data.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Df.Mix.csv\
 rf_model.R
	Rscript rf_model.R
 

derived_models/best.lin.mod.rds: derived_data/Clean_Data.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Df.Mix.csv\
 linear_models.R
	Rscript linear_models.R

derived_data/Off.Skill.csv derived_data/Off.Strength.csv\
derived_data/Def.Skill.csv dervied_data/Def.Strength.csv\
derived_data/Df.Mix.csv\
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
derived_graphs/Pick.Density.Plot.png\
derived_graphs/40.Time.Plot.png\
derived_graphs/Boxplot.by.round.png:\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 tidy_graphs.r
	Rscript tidy_graphs.r
	
derived_graphs/PCA.Eigen.png\
derived_graphs/PCA.FramedClusters.png\
derived_graphs/K-Means.Cluster.png\
derived_graphs/TSNE.Cluster.png:\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 cluster_data.R
	Rscript cluster_data.R
	
