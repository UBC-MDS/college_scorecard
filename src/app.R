#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

data <- read_csv("../data/02_scorecard_clean.csv")
states <- as.list(unique(data$STABBR))
adm_rate <- as.numeric(data$ADM_Rate_P)
sch_size <- as.list(unique(data$SCHOOL_SIZE))

ui <- fluidPage(
  
  titlePanel("Impact of School Size on Higher Education (US)"
             ),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("State1Input", label = h3("City 1"), 
                  choices = states, 
                  selected = 1),
    
      sliderInput("adm_rate", label = h3("Admission Rate"), step = 5,
                min = 0.0, max = 100.0, value = c(0,100),
                sep = ""
                )
    ),
    
  mainPanel(
    tabsetPanel(
      tabPanel("Total", plotOutput("raw_graph"), plotOutput("normalized_graph")),
      tabPanel("Small Schools", plotOutput("raw_graph"), plotOutput("normalized_graph")),
      tabPanel("Medium Schools", plotOutput("raw_graph"), plotOutput("normalized_graph")),
      tabPanel("Large Schools", plotOutput("raw_graph"), plotOutput("normalized_graph"))
      )
  )
  )
)

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)
