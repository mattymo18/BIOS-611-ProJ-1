.PHONY: clean

clean:
	rm derived_data/*

derived_data/combine.csv derived_data/draft.csv:\
 source_data/combine.csv\
 source_data/draft.csv\
 tidy_data.r
	Rscript tidy_data.r
	