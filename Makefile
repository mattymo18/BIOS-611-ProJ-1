.PHONY: clean
.PHONY: NFL_Combine_Tool
.PHONY: NFL_Python_Tool

#cleans entire repository of derived elements
clean:
	rm derived_data/*.csv
	rm derived_graphs/*.png
	rm derived_graphs/*.rds
	rm derived_models/*.rds
	rm Analysis.pdf
	
NFL_Python_Tool:\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/DF.Mix.csv\
 bokeh serve --port ${PORT} --address 0.0.0.0 NFL_Python_Aspect.ipynb

NFL_Combine_Tool:\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/DF.Mix.csv\
 derived_data/combine.csv\
 NFL_Combine_Tool.R
	Rscript NFL_Combine_Tool.R ${PORT}

#builds final report	
Analysis.pdf: Analysis.Rmd\
 derived_graphs/Boxplot.by.round.png\
 derived_graphs/Off.Weights.png\
 derived_graphs/Age.Dist.png\
 derived_graphs/40.Time.Plot.png\
 derived_graphs/TSNE.Cluster.png\
 derived_graphs/K-Means.Cluster.png\
 derived_graphs/PCA.FramedClusters.png\
 derived_graphs/RMSE.Table.rds\
 derived_graphs/rf.importance.table.rds\
 derived_graphs/rf.plot.png
	R -e "rmarkdown::render('Analysis.Rmd')"

#builds RMSE Table in final report
derived_graphs/RMSE.Table.rds: derived_data/Clean_Data.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Df.Mix.csv\
 derived_models/best.gbm.mod.rds\
 derived_models/best.ridge.mod.rds\
 derived_models/best.lasso.mod.rds\
 derived_models/best.lin.mod.rds\
 derived_models/best.glm.mod.rds\
 derived_models/best.rf.mod.rds\
 derived_models/best.pcr.mod.rds\
 model.eval.table.R
	Rscript model.eval.table.R

#builds pcr model
derived_models/best.pcr.mod.rds: derived_data/Clean_Data.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Df.Mix.csv\
 pcr_model.R
	Rscript pcr_model.R

#builds lasso and ridge models
derived_models/best.lasso.mod.rds\
derived_models/best.ridge.mod.rds: derived_data/Clean_Data.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Df.Mix.csv\
 lasso_ridge_models.R
	Rscript lasso_ridge_models.R

#builds glm model
derived_models/best.glm.mod.rds: derived_data/Clean_Data.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Df.Mix.csv\
 glm_models.R
	Rscript glm_models.R

#builds gbm model
derived_models/best.gbm.mod.rds: derived_data/Clean_Data.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Df.Mix.csv\
 gbm_models.R
	Rscript gbm_models.R

#builds random forest and rf plots	
derived_graphs/rf.plot.png\
derived_graphs/rf.importance.table.rds\
derived_models/best.rf.mod.rds: derived_data/Clean_Data.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Df.Mix.csv\
 rf_model.R
	Rscript rf_model.R

#builds linear model
derived_models/best.lin.mod.rds: derived_data/Clean_Data.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Df.Mix.csv\
 linear_models.R
	Rscript linear_models.R

#builds derived datasets
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

#builds many of the major graphs used in final report	
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
	
#builds clustering plots
derived_graphs/PCA.Eigen.png\
derived_graphs/PCA.Silhouette.png\
derived_graphs/PCA.FramedClusters.png\
derived_graphs/K-Means.Cluster.png\
derived_graphs/TSNE.Cluster.png:\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 cluster_data.R
	Rscript cluster_data.R
	
#builds the preliminary figures in the README	
preliminary_figures/Boxplot.by.round.png\
preliminary_figures/Off.Def.40s.png\
preliminary_figures/Off.Weights.png\
preliminary_figures/Age.Dist.png:\
 derived_data/Def.Skill.csv\
 derived_data/Def.Strength.csv\
 derived_data/Off.Skill.csv\
 derived_data/Off.Strength.csv\
 tidy_graphs.r
	Rscript tidy_graphs.r


