########## Enviornment ##########
library(shiny)
library(shinythemes)
library(tidyverse)
library(plotly)

DF.Off.skill <- read.csv("derived_data/Off.Skill.csv") %>% 
  mutate(Type = "1") #skill is 1, strength is 2, linebacker is 3
DF.Off.strength <- read.csv("derived_data/Off.Strength.csv") %>% 
  mutate(Type = "2")
DF.Def.skill <- read.csv("derived_data/Def.Skill.csv" )%>% 
  mutate(Type = "1")
DF.Def.strength <- read.csv("derived_data/Def.Strength.csv" )%>% 
  mutate(Type = "2")
DF.Mixed <- read.csv("derived_data/DF.Mix.csv") %>% 
  mutate(Type = "3")
Skill.Stren.DF <- rbind(DF.Off.skill, DF.Off.strength, DF.Def.strength, DF.Def.skill, DF.Mixed)
Skill.Stren.DF <- Skill.Stren.DF %>% 
  rename(`Forty Yard Dash` = combine40yd, 
         `Bench Press` = combineBench, 
         `Shuttle Run` = combineShuttle, 
         `Three Cone Drill` = combine3cone, 
         `Vertical Jump` = combineVert, 
         `Broad Jump` = combineBroad, 
         `Pick` = pick, 
         `Round` = round) %>% 
  mutate(Type.Name = ifelse(Type == 1, "Skill", ifelse(Type == 2, "Strength", "Mixed")))
Player.Names <- read.csv("derived_data/combine.csv") %>% 
  select(playerId, nameFull)
Skill.Stren.DF <- right_join(Player.Names, Skill.Stren.DF)

########## UI ##########
ui <-  fluidPage(theme = shinytheme("yeti"),
               navbarPage("NFL Combine Evaluation Tool", 
                          tabPanel("Combine Statistic Density Plots", 
                                   sidebarLayout(
                                     sidebarPanel(
                                       selectInput("Variable.Select.Density.Plots", h3("Combine Stat"), 
                                                   choices = c("Forty Yard Dash", 
                                                               "Bench Press",
                                                               "Shuttle Run", 
                                                               "Three Cone Drill", 
                                                               "Vertical Jump", 
                                                               "Broad Jump"), 
                                                   selected = "Forty Yard Dash")), 
                                     mainPanel(
                                       plotlyOutput("Density.Plots"),
                                       tableOutput("Combine.Stat.Table")
                                     )
                                   )
                          ), 
                          tabPanel("Combine Statistic Scatter Plots", 
                                   sidebarLayout(
                                     sidebarPanel(
                                       selectInput("X.Variable.Select.Scatter", h3("Select X Variable"), 
                                                   choices = c("Forty Yard Dash", 
                                                               "Bench Press", 
                                                               "Shuttle Run", 
                                                               "Three Cone Drill", 
                                                               "Vertical Jump", 
                                                               "Broad Jump"), 
                                                   selected = "Forty Yard Dash"), 
                                       selectInput("Y.Variable.Select.Scatter", h3("Select Y Variable"), 
                                                   choices = c("Forty Yard Dash", 
                                                               "Bench Press", 
                                                               "Shuttle Run", 
                                                               "Three Cone Drill", 
                                                               "Vertical Jump", 
                                                               "Broad Jump"), 
                                                   selected = "Forty Yard Dash")), 
                                     mainPanel(
                                       plotlyOutput("Scatter.Plots")
                                     )
                                   ))
               )
)

########## Server ##########
server <- function(input, output) {
  ###### Density Plots ###### 
  
  output$Density.Plots <- renderPlotly({
    
  var <- input$Variable.Select.Density.Plots
   
  ggplotly(
    Skill.Stren.DF %>%
      ggplot(aes(x = !!sym(var))) +
      geom_density(aes(fill = Type.Name), alpha = .55) +
      ylab("Density") + 
      theme(axis.line = element_line(colour = "black"),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_blank(), 
            legend.title = element_blank()))
  })
  
  ##### Reactive Table Function #######
  Combine.Stat.func <- reactive({
   if(input$Variable.Select.Density.Plots == "Bench Press" | 
      input$Variable.Select.Density.Plots == "Vertical Jump" |
      input$Variable.Select.Density.Plots == "Broad Jump") {
     Skill.Stren.DF %>% 
      rename(`Name` = nameFull) %>% 
      select(Name, !!sym(input$Variable.Select.Density.Plots)) %>% 
      arrange(desc(!!sym(input$Variable.Select.Density.Plots))) %>% 
      head(5)
   } else {
     Skill.Stren.DF %>% 
       rename(`Name` = nameFull) %>% 
       select(Name, !!sym(input$Variable.Select.Density.Plots)) %>% 
       arrange(!!sym(input$Variable.Select.Density.Plots)) %>% 
       head(5)
   }
  })
  
  ##### Density Page Table #####
  output$Combine.Stat.Table <- renderTable(
    Combine.Stat.func()
  )
  
  
  
  
  ##### Scatter Plots #####
  output$Scatter.Plots <- renderPlotly({
    
    xvar <- input$X.Variable.Select.Scatter
    yvar <- input$Y.Variable.Select.Scatter
   
  ggplotly(
     Skill.Stren.DF %>% 
      ggplot(aes(x = !!sym(xvar), y = !!sym(yvar))) +
      geom_point(aes(color = Type.Name), alpha = .5) +
      theme(axis.line = element_line(colour = "black"),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_blank(), 
            legend.title = element_blank()))
    
  })
  
}


# Run the application 
shinyApp(ui = ui, server = server)

