library(shiny)
library(tidyverse)

data <- read.csv("02_scorecard_clean.csv", stringsAsFactors = FALSE)
tmp <- sort(unique(data$STABBR))
tmp <- append(tmp, '(all)')
states <- sort(tmp)


ui <- fluidPage(
  titlePanel("Impact of School Size on Higher Education (US)", 
             windowTitle = "scorecard app"),
  sidebarLayout(
    sidebarPanel(
      selectInput("typeInput", "Select a state of interest", 
                  choices = states,
                  selected = '(all)'),
      sliderInput("priceInput", "Select an admission rate range",
                  min = 0, max = 100, value = c(0, 100), post="%")
      
    ),
    mainPanel(
      # plotOutput("school_plot"))
      tabsetPanel( id = 'tabs', selected = 'Total',
                   tabPanel("Total", value = 'Total', plotOutput("school_plot_1")),
                   tabPanel("Small", value = 'Small', plotOutput("school_plot_2")),
                   tabPanel("Medium",value = 'Medium', plotOutput("school_plot_3")),
                   tabPanel("Large", value = 'Large', plotOutput("school_plot_4")))
    )
  )
)

server <- function(input, output) {
  school_size <- reactive(input$tabs)
  fill_cols <- reactive({
    if (school_size() == 'Total'){
      fill_cols = c("green", "blue", "red")
    }
    else if (school_size() == 'Small'){
      fill_cols = c("red")
    }
    else if (school_size() == 'Medium'){
      fill_cols = c("blue")
    }
    else {
      fill_cols = c("green")
    }
  })
  
  # may need to change this filtering
  data_filtered <- reactive({
    if (input$typeInput != '(all)') {
      if (school_size() != 'Total') {
        data %>% 
          filter(ADM_Rate_P < input$priceInput[2],
                 ADM_Rate_P > input$priceInput[1],
                 STABBR == input$typeInput,
                 SCHOOL_SIZE == school_size())
      }
      else {
        data %>% 
          filter(ADM_Rate_P < input$priceInput[2],
                 ADM_Rate_P > input$priceInput[1],
                 STABBR == input$typeInput)        
      }
    }
    else {
      if (school_size() != 'Total') {
        data %>% 
          filter(ADM_Rate_P < input$priceInput[2],
                 ADM_Rate_P > input$priceInput[1],
                 SCHOOL_SIZE == school_size())
      }
      else {
        data %>% 
          filter(ADM_Rate_P < input$priceInput[2],
                 ADM_Rate_P > input$priceInput[1])        
      }
    }
  })
  
  # Repeat for each graph
  school_plot <- reactive({
    data_filtered() %>% group_by(SCHOOL_SIZE) %>% summarise(count = n()) %>% 
      arrange(count, desc(count)) %>% 
      ggplot(aes(x=SCHOOL_SIZE, y=count, fill=SCHOOL_SIZE)) +
      geom_bar(colour="black", stat="identity", alpha=.3) +
      theme_bw() +
      scale_fill_manual(values=fill_cols()) +
      ggtitle("Number of Schools by Size") +
      xlab("School Size") + 
      ylab("Count") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank())
  })
  
  output$school_plot_1 <- output$school_plot_2 <- output$school_plot_3 <- output$school_plot_4 <- renderPlot({
    if (school_size() != 'Total') {
      grid.arrange(school_plot() + theme(legend.position="none"), 
                   school_plot() + theme(legend.position="none"),
                   ncol=2, nrow=1, 
                   widths=c(7, 7))
    }
    else {
      grid.arrange(get_legend(school_plot() + guides(fill = guide_legend(title = "School Size"))),
                   school_plot() + theme(legend.position="none"), 
                   school_plot() + theme(legend.position="none"),
                   ncol=3, nrow=1, 
                   widths=c(1, 5, 5))
    }
    
  })
}


shinyApp(ui = ui, server = server)