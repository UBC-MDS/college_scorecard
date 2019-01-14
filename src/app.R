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


ui <- fluidPage(
  titlePanel("Impact of School Size on Higher Education (US)"
    ),
    mainPanel(
    )
  )


server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)
