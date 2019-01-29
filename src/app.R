# app.R
# Author: Sarah Watts & Socorro Dominguez
# Date: January 2019
#
# This ShinyApp uses the cleaned data found in the 02_scorecard_clean.csv data file 
# And creates the app that shows the following plots:
#    1. A bar plot showing a count of schools by size
#    2. A density plot showing the distribution of female % of attendees by size of a school
#    3. A density plot showing the distribution of median earnings 10yrs after attendence by size of a school
#    4. A density plot showing the distribution of entry age by size of a school
#    5. A density plot showing the distribution of the % of loans recieved by size of a school
#    6. A density plot showing the distribution of the family income by size of a school

# This app also allows interactivity with the user. The user can select the admission rate they desire and can also
# select the size of school or states they want to review.

# Loads libraries for app 
library(shiny)
library(shinyWidgets)
library(shinythemes)
library(tidyverse)
library(gridExtra)
library(cowplot)
library(shinyjs)

# Reads data from cleaned file
data <- read.csv("../data/02_scorecard_clean.csv", stringsAsFactors = FALSE)

# Names the states
states <- sort(unique(data$State_Name))

# Names to classify the schools
schools <- c("Small", "Medium", "Large")

# Load theme
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

# User interface
ui <- fluidPage(theme = shinytheme("yeti"),useShinyjs(),
                inlineCSS(appCSS),
  titlePanel("Impact of School Size on Higher Education (USA)", 
             windowTitle = "scorecard app"),
  sidebarLayout(
    sidebarPanel(width = 3,
                 pickerInput("state_input", 
                             label = "Select states of interest", 
                             choices = states, #Select the states of interest. 
                             multiple = TRUE, # Multiselection is possible
                             options = list(`actions-box` = TRUE), 
                             selected = "California"),
                 sliderInput("admin_input", 
                             "Select an admission rate range",
                             min = 0, max = 100, value = c(0, 100), post="%"),
                 pickerInput("School_size", # Select school size
                              label = "Select school sizes", 
                              choices = schools, 
                              selected = schools,
                              multiple = TRUE, # Multiselection is possible
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

# Server - Reactive inputs.
server <- function(input, output) {
  
  output$lines <- renderText({
    paste( 
          "Large schools: 15,000 + students", 
          "Medium schools: 5,000 - 15,000 students", 
          "Small schools: 1 - 5,000 students", sep="<br>")
  })
  # Select school size
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
    # Reactive input for admission rate
    if (input$admin_input[1] == 0 & input$admin_input[2] == 100) {
      data %>% 
        # Reactive input for School size
        filter(School_size %in% input$School_size,
               State_Name %in% input$state_input)
    }
    else {
      data %>% 
        # Reactive input for admission rate
        filter(Admissions_rate_percent < input$admin_input[2],
               Admissions_rate_percent > input$admin_input[1],
               # Reactive input for School size
               School_size %in% input$School_size,
               State_Name %in% input$state_input)        
    }
  })
  
  count_schools <- reactive({
    nrow(data_filtered())
  })
  
  # overall number of schools
  school_plot <- reactive({
    data_filtered() %>% group_by(School_size) %>% summarise(count = n()) %>% 
      arrange(count, desc(count)) %>% 
      ggplot(aes(x=School_size, y=count, fill=School_size)) +
      geom_bar(colour="black", stat="identity", alpha=.3) +
      geom_text(aes(label=count), position=position_dodge(width=1), vjust=-0.25, size=5) +
      theme_bw() +
      theme(text=element_text(size=14),
            axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank()) +
      scale_fill_manual(values=fill_cols()) +
      ggtitle("Number of Schools by Size") +
      xlab("School Size") + 
      ylab("Count") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank())
  })
  
  #cPercent_Female_students distribution plot
  Percent_Female_students_dis_plot <- reactive({
    data_filtered() %>% filter(!is.na(Percent_Female_students)) %>% group_by(School_size) %>%  
      ggplot(aes((x=Percent_Female_students), fill=School_size)) +
      geom_density(alpha=.3) +
      scale_fill_manual(values=fill_cols()) +
      theme_bw() +
      theme(text=element_text(size=14),
            axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank()) +
      ggtitle("Distirubtion of the Percent of Female Students") +
      xlab("Percentage of students (%)") + 
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
      theme(text=element_text(size=14),
            axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank()) +
      scale_fill_manual(values=fill_cols()) +
      ggtitle("Distirbution of Median Earnings 10yrs after Graduation") +
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
      theme(text=element_text(size=14),
            axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank()) +
      scale_fill_manual(values=fill_cols()) +
      theme(legend.position="none") +
      ggtitle("Distribution of Entrance Age") +
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
      theme(text=element_text(size=14),
            axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank()) +
      scale_fill_manual(values=fill_cols()) +
      theme(legend.position="none") +
      ggtitle("Distribution of Students Receiving Financial Aid (%)") +
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
      theme(text=element_text(size=14),
            axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank()) +
      scale_fill_manual(values=fill_cols()) +
      theme(legend.position="none") +
      ggtitle("Distribution of Median Family Earnings") +
      xlab("Family earnings ($)") +
      ylab("Density") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
    
  })
  
  # Output of the first two plots: school count and median_10yr_wage plot
  output$row_1_T <- renderPlot({
   if (count_schools() == 0) {
     # M4. Targets BUG of not enough schools selected
      validate(
        need(count_schools() != 0, "There are no schools returned for your filtering criteria.
                                    Please increase your filtering criteria.")
      )      
    }
    if (count_schools() != 1) {
      grid.arrange(school_plot() + theme(legend.position="none"),
                   median_10yr_earn() + theme(legend.position="none"),
                   get_legend(school_plot() + guides(fill = guide_legend(title = "School Size"))),
                   ncol=3, nrow=1,
                   widths=c(5, 5, 1))
    }
    else {
      grid.arrange(school_plot() + theme(legend.position="none"),
                   widths=c(7,6))
    }
  })
  # Output of the next two plots: female distribution and Average entry age
  output$row_2_T <- renderPlot({
    if (count_schools() == 0) {
      # M4. Targets BUG of not enough schools selected
      validate(
        need(count_schools() != 0, "")
      )
    }
    if (count_schools() == 1) {
      # M4. Targets BUG of not enough schools selected
      validate(
        need(count_schools() != 1, "Additional graphs cannot be displayed when there is only one school selected. 
                                    Please increase your filtering criteria")
      )
    }
    else {
      grid.arrange(
        Percent_Female_students_dis_plot() + theme(legend.position="none"),
        Mean_entry_age_plot() + theme(legend.position="none"),
        get_legend(school_plot() + guides(fill = guide_legend(title = "School Size"))),
        ncol=3, nrow=1,
        widths=c(5, 5, 1))
    }
    
  })
  
  # Output of the next two plots: perc_fed_loans and med_fam_earnings
  output$row_3_T <- renderPlot({
    if (count_schools() == 0) {
    # M4. Targets BUG of not enough schools selected
    validate(
      need(count_schools() != 0, "")
    )      
    }
    if (count_schools() != 1) {
      grid.arrange(
        perc_fed_loans() + theme(legend.position="none"),
        med_fam_earn() + theme(legend.position="none"),
        get_legend(school_plot() + guides(fill = guide_legend(title = "School Size"))),
        ncol=3, nrow=1,
        widths=c(5, 5, 1))
    }
  })
  
  # Output of table for small schools
  output$small_T <- renderTable({
    data_small <- data_filtered() %>% filter(School_size == 'Small') %>%
      select(Institution_name, Median_earnings_after_10yrs, 
                               Percent_Female_students, Mean_entry_age,
                               Percent_students_with_loans, Median_family_income) %>%
      arrange(Institution_name) %>%
      rename("Institution name" = Institution_name,
             "Median earnings after 10yrs" = Median_earnings_after_10yrs,
             "Percent female students" = Percent_Female_students,
             "Mean entry age" = Mean_entry_age,
             "Percent students with loans" = Percent_students_with_loans,
             "Median family income" = Median_family_income
      )
    # M4. Targets BUG of not enough schools selected
    validate(
      need(nrow(data_filtered() %>% filter(School_size == 'Small')) > 0, 
                                "There are no small schools returned for your filtering criteria.
                                 Please increase your filtering criteria.")
      )
    # M4. Targets BUG of not enough schools selected
    validate(
      need(nrow(data_small) < 150, "There are too many values to display. 
           Please increase your filtering criteria to return fewer than 150 small sized schools")
      ) 
    data_small
  })
  
  # Output of table for medium schools
  output$medium_T <- renderTable({
    data_medium <- data_filtered() %>% filter(School_size == 'Medium') %>%
      select(Institution_name, Median_earnings_after_10yrs, 
                               Percent_Female_students, Mean_entry_age,
                               Percent_students_with_loans, Median_family_income) %>%
      arrange(Institution_name) %>%
      rename("Institution name" = Institution_name,
             "Median earnings after 10yrs" = Median_earnings_after_10yrs,
             "Percent female students" = Percent_Female_students,
             "Mean entry age" = Mean_entry_age,
             "Percent students with loans" = Percent_students_with_loans,
             "Median family income" = Median_family_income
             )
    validate(
      need(nrow(data_filtered() %>% filter(School_size == 'Medium')) > 0, 
                                "There are no medium schools returned for your filtering criteria.
                                 Please increase your filtering criteria.")
    )
    validate(
      need(nrow(data_medium) < 150, "There are too many values to display. 
           Please increase your filtering criteria to return fewer than 150 medium sized schools")
    ) 
    data_medium
    
  })
  
  # Output of table for large schools
  output$large_T <- renderTable({
    data_large <- data_filtered() %>% filter(School_size == 'Large') %>%
      select(Institution_name, Median_earnings_after_10yrs, 
                               Percent_Female_students, Mean_entry_age,
                               Percent_students_with_loans, Median_family_income) %>%
      arrange(Institution_name) %>%
      rename("Institution name" = Institution_name,
             "Median earnings after 10yrs" = Median_earnings_after_10yrs,
             "Percent female students" = Percent_Female_students,
             "Mean entry age" = Mean_entry_age,
             "Percent students with loans" = Percent_students_with_loans,
             "Median family income" = Median_family_income
      )
      validate(
        need(nrow(data_filtered() %>% filter(School_size == 'Large')) > 0, 
                                    "There are no large schools returned for your filtering criteria.
                                    Please increase your filtering criteria.")
      )
     validate(
      need(nrow(data_large) < 150, "There are too many values to display. 
           Please increase your filtering criteria to return fewer than 150 large sized schools")
     ) 
     data_large
  })
}

# Shiny server
shinyApp(ui = ui, server = server)