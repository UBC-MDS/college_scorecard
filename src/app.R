library(shiny)
library(tidyverse)
library(gridExtra)
library(cowplot)

data <- read.csv("../data/02_scorecard_clean.csv", stringsAsFactors = FALSE)
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
  
  ##Female dis plot
  
  female_dis_plot <- reactive({
    data_filtered() %>% filter(!is.na(female)) %>% group_by(SCHOOL_SIZE) %>%  
      ggplot(aes((x=female), fill=SCHOOL_SIZE)) +
      geom_density(alpha=.3) +
      scale_fill_manual(values=fill_cols()) +
      theme_bw() +
      ggtitle("Percentage of Female Students") +
      xlab("Female students (%)") + 
      ylab("Frequency") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
  })
  
  
  # Median Wage after 10 Years
  
  median_10yr_earn <- reactive({
    data_filtered() %>% filter(!is.na(md_earn_wne_p10)) %>% group_by(SCHOOL_SIZE) %>% 
      ggplot(aes(x=md_earn_wne_p10, fill=SCHOOL_SIZE)) + 
      geom_density(alpha=.3) +
      theme_bw() + 
      scale_fill_manual(values=fill_cols()) +
      ggtitle("Median Earnings 10yrs after Graduation") +
      xlab("Earnings ($)") +
      ylab("Frequency") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
  })
  
  
  # Entry Age Plot
  entry_age_plot <- reactive({
    data_filtered() %>% filter(!is.na(age_entry)) %>% group_by(SCHOOL_SIZE) %>%
      ggplot(aes(x=age_entry, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
      theme_bw() + 
      scale_fill_manual(values=fill_cols()) +
      theme(legend.position="none") +
      ggtitle("Entrance Age") +
      xlab("Age") +
      ylab("Frequency") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
  })
  
  # Perceived Fed Loans
  perc_fed_loans <- reactive({
    data_filtered() %>% filter(!is.na(loan_ever)) %>% group_by(SCHOOL_SIZE) %>%
      ggplot(aes(x=loan_ever, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
      theme_bw() + 
      scale_fill_manual(values=fill_cols()) +
      theme(legend.position="none") +
      ggtitle("Students Receiving Financial Aid (%)") +
      xlab("Financial aid (%)") +
      ylab("Frequency") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
  })
  
  # Med family income 
  
  med_fam_earn <- reactive({
    data_filtered() %>% filter(!is.na(md_faminc)) %>% group_by(SCHOOL_SIZE) %>%
      ggplot(aes(x=md_faminc, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
      theme_bw() + 
      scale_fill_manual(values=fill_cols()) +
      theme(legend.position="none") +
      ggtitle("Median Family Earnings") +
      xlab("Family earnings ($)") +
      ylab("Frequency") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
    
  })
  
  output$school_plot_1 <- output$school_plot_2 <- output$school_plot_3 <- output$school_plot_4 <- renderPlot({
    if (school_size() != 'Total') {
      grid.arrange(female_dis_plot() + theme(legend.position="none"),
                   median_10yr_earn()+ theme(legend.position="none"),
                   entry_age_plot() + theme(legend.position="none"),
                   perc_fed_loans() + theme(legend.position="none"),
                   med_fam_earn() + theme(legend.position="none"),
                   ncol=2, nrow=3, 
                   widths=c(10, 10))
    }
    else {
      grid.arrange(get_legend(school_plot() + guides(fill = guide_legend(title = "School Size"))),
                   school_plot() + theme(legend.position="none"),
                   female_dis_plot() + theme(legend.position="none"),
                   median_10yr_earn() + theme(legend.position="none"),
                   entry_age_plot() + theme(legend.position="none"),
                   perc_fed_loans() + theme(legend.position="none"),
                   med_fam_earn() + theme(legend.position="none"),
                   ncol = 2,
                   widths=c(10,10),
                   heights=c(15,15,15,15))
    }
    
  })
}


shinyApp(ui = ui, server = server)