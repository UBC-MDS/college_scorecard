library(shiny)
library(shinyWidgets)
library(shinythemes)
library(tidyverse)
library(gridExtra)
library(cowplot)
library(shinyjs)

data <- read.csv("../data/02_scorecard_clean.csv", stringsAsFactors = FALSE)
states <- sort(unique(data$State_Name))
schools <- c("Small", "Medium", "Large")

appCSS <- "
#loading-content {
position: absolute;
background: #000000;
opacity: 0.9;
z-index: 100;
left: 0;
right: 0;
height: 100%;
text-align: center;
color: #FFFFFF;
}
"


ui <- fluidPage(theme = shinytheme("yeti"),useShinyjs(),
                inlineCSS(appCSS),
  titlePanel("Impact of School Size on Higher Education (US)", 
             windowTitle = "scorecard app"),
  sidebarLayout(
    sidebarPanel(width = 3,
                 pickerInput("state_input", 
                             label = "Select states of interest", 
                             choices = states,
                             multiple = TRUE,
                             options = list(`actions-box` = TRUE),
                             selected = states),
                 sliderInput("admin_input", 
                             "Select an admission rate range",
                             min = 0, max = 100, value = c(0, 100), post="%"),
                 pickerInput("School_size", 
                              label = "Select school sizes", 
                              choices = schools, 
                              selected = schools,
                              multiple = TRUE,
                              options = list(`actions-box` = TRUE)),
                 htmlOutput("lines")
      
    ),
    mainPanel(width = 8,
      tabsetPanel( id = 'tabs', selected = 'Total',
                   tabPanel("Total", value = 'Total', plotOutput("row_1_T"), plotOutput("row_2_T"), 
                            plotOutput("row_3_T")),
                   tabPanel("Small School List", value = 'Small', tableOutput("small_T")),
                   tabPanel("Medium School List",value = 'Medium', tableOutput("medium_T")),
                   tabPanel("Large School List", value = 'Large', tableOutput("large_T")))
    )
  )
)

server <- function(input, output) {
  
  output$lines <- renderText({
    paste( 
          "Large schools: 15,000+ students", 
          "Medium schools: 15,000-5,000 students", 
          "Small schools: 5,000-1 students", sep="<br>")
  })
  
  School_size <- reactive(input$tabs)
  fill_cols <- reactive({
    if (School_size() == 'Total'){
      fill_cols = c("black", "blue", "light blue")
    }
    else if (School_size() == 'Small'){
      fill_cols = c("light blue")
    }
    else if (School_size() == 'Medium'){
      fill_cols = c("blue")
    }
    else {
      fill_cols = c("black")
    }
  })
  
  data_filtered <- reactive({
    if (input$admin_input[1] == 0 & input$admin_input[2] == 100) {
      data %>% 
        filter(School_size %in% input$School_size,
               State_Name %in% input$state_input)
    }
    else {
      data %>% 
        filter(Admissions_rate_percent < input$admin_input[2],
               Admissions_rate_percent > input$admin_input[1],
               School_size %in% input$admin_input,
               State_Name %in% input$state_input)        
    }
  })
  
  # overall number of schools
  school_plot <- reactive({
    data_filtered() %>% group_by(School_size) %>% summarise(count = n()) %>% 
      arrange(count, desc(count)) %>% 
      ggplot(aes(x=School_size, y=count, fill=School_size)) +
      geom_bar(colour="black", stat="identity", alpha=.3) +
      theme_bw() +
      theme(text=element_text(size=16)) +
      scale_fill_manual(values=fill_cols()) +
      ggtitle("Number of Schools by Size") +
      xlab("School Size") + 
      ylab("Count") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank())
  })
  
  ##Percent_Female_students dis plot
  Percent_Female_students_dis_plot <- reactive({
    data_filtered() %>% filter(!is.na(Percent_Female_students)) %>% group_by(School_size) %>%  
      ggplot(aes((x=Percent_Female_students), fill=School_size)) +
      geom_density(alpha=.3) +
      scale_fill_manual(values=fill_cols()) +
      theme_bw() +
      theme(text=element_text(size=16)) +
      ggtitle("Percentage of Percent_Female_students Students") +
      xlab("Percent_Female_students students (%)") + 
      ylab("Density") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
  })
  
  
  # Median Wage after 10 Years
  median_10yr_earn <- reactive({
    data_filtered() %>% filter(!is.na(Median_earnings_after_10yrs)) %>% group_by(School_size) %>% 
      ggplot(aes(x=Median_earnings_after_10yrs, fill=School_size)) + 
      geom_density(alpha=.3) +
      theme_bw() + 
      theme(text=element_text(size=16)) +
      scale_fill_manual(values=fill_cols()) +
      ggtitle("Median Earnings 10yrs after Graduation") +
      xlab("Earnings ($)") +
      ylab("Density") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
  })
  
  
  # Entry Age Plot
  Mean_entry_age_plot <- reactive({
    data_filtered() %>% filter(!is.na(Mean_entry_age)) %>% group_by(School_size) %>%
      ggplot(aes(x=Mean_entry_age, fill=School_size)) + geom_density(alpha=.3) +
      theme_bw() + 
      theme(text=element_text(size=16)) +
      scale_fill_manual(values=fill_cols()) +
      theme(legend.position="none") +
      ggtitle("Entrance Age") +
      xlab("Age") +
      ylab("Density") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
  })
  
  # Perceived Fed Loans
  perc_fed_loans <- reactive({
    data_filtered() %>% filter(!is.na(Percent_students_with_loans)) %>% group_by(School_size) %>%
      ggplot(aes(x=Percent_students_with_loans, fill=School_size)) + geom_density(alpha=.3) +
      theme_bw() + 
      theme(text=element_text(size=16)) +
      scale_fill_manual(values=fill_cols()) +
      theme(legend.position="none") +
      ggtitle("Students Receiving Financial Aid (%)") +
      xlab("Financial aid (%)") +
      ylab("Density") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
  })
  
  
  
  # Med family income 
  med_fam_earn <- reactive({
    data_filtered() %>% filter(!is.na(Median_family_income)) %>% group_by(School_size) %>%
      ggplot(aes(x=Median_family_income, fill=School_size)) + geom_density(alpha=.3) +
      theme_bw() + 
      theme(text=element_text(size=16)) +
      scale_fill_manual(values=fill_cols()) +
      theme(legend.position="none") +
      ggtitle("Median Family Earnings") +
      xlab("Family earnings ($)") +
      ylab("Density") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
    
  })
  
  output$row_1_T <- renderPlot({
      grid.arrange(school_plot() + theme(legend.position="none"),
                   median_10yr_earn() + theme(legend.position="none"),
                   get_legend(school_plot() + guides(fill = guide_legend(title = "School Size"))),
                   ncol=3, nrow=1,
                   widths=c(5, 5, 1))
  })
    output$row_2_T <- renderPlot({
        grid.arrange(
                     Percent_Female_students_dis_plot() + theme(legend.position="none"),
                     Mean_entry_age_plot() + theme(legend.position="none"),
                     get_legend(school_plot() + guides(fill = guide_legend(title = "School Size"))),
                     ncol=3, nrow=1,
                     widths=c(5, 5, 1))
    })
    output$row_3_T <- renderPlot({
          grid.arrange(
                       perc_fed_loans() + theme(legend.position="none"),
                       med_fam_earn() + theme(legend.position="none"),
                       get_legend(school_plot() + guides(fill = guide_legend(title = "School Size"))),
                       ncol=3, nrow=1,
                       widths=c(5, 5, 1))
  })
  output$small_T <- renderDataTable({
    data_filtered() %>% filter(School_size == 'Small') %>%
      select(Institution_name, Median_earnings_after_10yrs, 
                               Percent_Female_students, Mean_entry_age,
                               Percent_students_with_loans, Median_family_income)
  })
  output$medium_T <- renderDataTable({
    data_filtered() %>% filter(School_size == 'Medium') %>%
      select(Institution_name, Median_earnings_after_10yrs, 
                               Percent_Female_students, Mean_entry_age,
                               Percent_students_with_loans, Median_family_income)
  })
  output$large_T <- renderDataTable({
    data_filtered() %>% filter(School_size == 'Large') %>%
      select(Institution_name, Median_earnings_after_10yrs, 
                               Percent_Female_students, Mean_entry_age,
                               Percent_students_with_loans, Median_family_income)
  })
}


shinyApp(ui = ui, server = server)