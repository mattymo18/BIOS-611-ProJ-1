#Python Tool with bokeh plot

import bokeh as bk;
from bokeh.layouts import gridplot;
from bokeh.plotting import figure;

import pandas as pd;
import numpy as np;

DF_Def_Skill =  pd.read_csv('derived_data/Def.Skill.csv');
DF_Def_Stren =  pd.read_csv('derived_data/Def.Strength.csv');
DF_Off_Skill =  pd.read_csv('derived_data/Off.Skill.csv');
DF_Off_Stren =  pd.read_csv('derived_data/Off.Strength.csv');
DF_Mix = pd.read_csv('derived_data/DF.Mix.csv');

#1 will be skill, 2 will be strength, 3 will be mixed
DF_Def_Skill['Type'] = 1;
DF_Def_Stren['Type'] =  2;
DF_Off_Skill['Type'] =  1;
DF_Off_Stren['Type'] =  2;
DF_Mix['Type'] = 3;

DF_Def_Skill_cle = DF_Def_Skill[["playerId", "heightInches", "weight","combine40yd", "combineVert", 
                            "combineBroad", "combine3cone", "combineBench", "combineShuttle", "Type", "pick"]];
DF_Def_Stren_cle = DF_Def_Stren[["playerId", "heightInches", "weight","combine40yd", "combineVert", 
                            "combineBroad", "combine3cone", "combineBench", "combineShuttle", "Type", "pick"]];
DF_Off_Skill_cle = DF_Off_Skill[["playerId", "heightInches", "weight","combine40yd", "combineVert", 
                            "combineBroad", "combine3cone", "combineBench", "combineShuttle", "Type", "pick"]];
DF_Off_Stren_cle = DF_Off_Stren[["playerId", "heightInches", "weight","combine40yd", "combineVert", 
                            "combineBroad", "combine3cone", "combineBench", "combineShuttle", "Type", "pick"]];
DF_Mix_cle = DF_Mix[["playerId", "heightInches", "weight","combine40yd", "combineVert", 
                            "combineBroad", "combine3cone", "combineBench", "combineShuttle", "Type", "pick"]];

DF_Clean = DF_Def_Skill_cle.append([DF_Def_Stren_cle, DF_Off_Skill_cle, DF_Off_Stren_cle, DF_Mix_cle]);

from bokeh.io import output_file, show
TOOLS="pan,wheel_zoom,box_select,lasso_select,reset";
source = bk.models.ColumnDataSource(data = DF_Clean);

#forty yard dash plot
forty_plot = bk.plotting.figure(tools = TOOLS, 
                                plot_width = 400, 
                                plot_height = 400, 
                                title = "Forty Yard Dash", 
                                x_axis_label = "Forty Time", 
                                y_axis_label = "Pick");
forty_plot.scatter('combine40yd', 'pick', size = 5, color = "blue", alpha = 0.5, source = source);


#benchpress plot
bench_plot = bk.plotting.figure(tools = TOOLS, 
                                plot_width = 400, 
                                plot_height = 400, 
                                title = "Bench Press", 
                                x_axis_label = "Number of Reps", 
                                y_axis_label = "Pick");
bench_plot.scatter('combineBench', 'pick', size = 5, color = "red", alpha = 0.5, source = source);

#Shuttle run plot
shuttle_plot = bk.plotting.figure(tools = TOOLS, 
                                plot_width = 400, 
                                plot_height = 400, 
                                title = "Shuttle Run", 
                                x_axis_label = "Shuttle Time", 
                                y_axis_label = "Pick");
shuttle_plot.scatter('combineShuttle', 'pick', size = 5, color = "purple", alpha = 0.5, source = source);

#vertical jump plot
vertical_plot = bk.plotting.figure(tools = TOOLS, 
                                plot_width = 400, 
                                plot_height = 400, 
                                title = "Vertical Jump", 
                                x_axis_label = "Vertical Height", 
                                y_axis_label = "Pick");
vertical_plot.scatter('combineVert', 'pick', size = 5, color = "green", alpha = 0.5, source = source);

#Broad jump plot
broad_plot = bk.plotting.figure(tools = TOOLS, 
                                plot_width = 400, 
                                plot_height = 400, 
                                title = "Broad Jump", 
                                x_axis_label = "Jump Distance", 
                                y_axis_label = "Pick");
broad_plot.scatter('combineBroad', 'pick', size = 5, color = "orange", alpha = 0.5, source = source);

#3 cone plot
threecone_plot = bk.plotting.figure(tools = TOOLS, 
                                plot_width = 400, 
                                plot_height = 400, 
                                title = "3 Cone Drill", 
                                x_axis_label = "3 Cone Time", 
                                y_axis_label = "Pick");
threecone_plot.scatter('combine3cone', 'pick', size = 5, color = "black", alpha = 0.5, source = source);

#combined grid plot
p = gridplot([forty_plot, bench_plot, shuttle_plot, vertical_plot, broad_plot, threecone_plot], 
             ncols = 3, merge_tools = True);

output_file(test.html);

show(p);