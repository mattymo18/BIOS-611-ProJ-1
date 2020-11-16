#Python Tool with bokeh plot

import pandas as pd;
import numpy as np;

import bokeh as bk;
from bokeh.layouts import column, row;
from bokeh.io import curdoc
from bokeh.models import ColumnDataSource, Slider
from bokeh.plotting import figure

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


TOOLS="pan,wheel_zoom,box_select,lasso_select,reset";

hist, edges = np.histogram(DF_Clean['combine40yd'], density=True);

hist_df = pd.DataFrame({"column": hist,
                        "left": edges[:-1],
                        "right": edges[1:]});

hist_df["interval"] = ["%d to %d" % (left, right) for left, 
                        right in zip(hist_df["left"], hist_df["right"])];
src = ColumnDataSource(hist_df);


#forty yard dash plot
forty_plot = bk.plotting.figure(tools = TOOLS, 
                                plot_width = 400, 
                                plot_height = 400, 
                                title = "Forty Yard Dash", 
                                x_axis_label = "Forty Time", 
                                y_axis_label = "Count");
forty_plot.quad(top="column", bottom = 0, left="left", right="right", source = src);

#widgets
bins = Slider(title = "Number of Bins", value = 50, start = 1, end = 100, step = 1);

#set up callbacks
def update_data(attrname, old, new):
    
    #Get current slider value
    b = bins.value
    
    #generate new data
    hist, edges = np.histogram(DF_Clean['combine40yd'], density = True, bins = b)
    hist_df = pd.DataFrame({"column": hist,
                        "left": edges[:-1],
                        "right": edges[1:]})
    src.data = ColumnDataSource(hist_df);
    
#bins.callback_policy = 'mouseup'
bins.on_change('value', update_data);


#set up layout and add to document
inputs = column(bins);


doc = curdoc();
doc.add_root(row(inputs, forty_plot, width=800));
doc.title = "Forty Yard Dash Plot";
