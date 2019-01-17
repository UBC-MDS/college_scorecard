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
    sidebarPanel(width = 3,
      selectInput("typeInput", "Select a state of interest", 
                  choices = states,
                  selected = '(all)'),
      sliderInput("priceInput", "And an admission rate",
                  min = 0, max = 100, value = c(0, 100), post="%"),
      htmlOutput("lines")
      
    ),
    mainPanel(width = 8,
      tabsetPanel( id = 'tabs', selected = 'Total',
                   tabPanel("Total", value = 'Total', plotOutput("row_1_T"), plotOutput("row_2_T"), plotOutput("row_3_T")),
                   tabPanel("Small", value = 'Small', plotOutput("row_1_S"), plotOutput("row_2_S"), plotOutput("row_3_S")),
                   tabPanel("Medium",value = 'Medium', plotOutput("row_1_M"), plotOutput("row_2_M"), plotOutput("row_3_M")),
                   tabPanel("Large", value = 'Large', plotOutput("row_1_L"), plotOutput("row_2_L"), plotOutput("row_3_L")))
    )
  )
)

server <- function(input, output) {
  
  output$lines <- renderText({
    paste("School sizes (by number of students):", 
          "Large: 15,000+", 
          "Medium: 15,000-5,000", 
          "Small: 5,000-", sep="<br>")
  })
  
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
  
  # overall number of schools
  school_plot <- reactive({
    data_filtered() %>% group_by(SCHOOL_SIZE) %>% summarise(count = n()) %>% 
      arrange(count, desc(count)) %>% 
      ggplot(aes(x=SCHOOL_SIZE, y=count, fill=SCHOOL_SIZE)) +
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
  
  ##Female dis plot
  female_dis_plot <- reactive({
    data_filtered() %>% filter(!is.na(female)) %>% group_by(SCHOOL_SIZE) %>%  
      ggplot(aes((x=female), fill=SCHOOL_SIZE)) +
      geom_density(alpha=.3) +
      scale_fill_manual(values=fill_cols()) +
      theme_bw() +
      theme(text=element_text(size=16)) +
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
      theme(text=element_text(size=16)) +
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
      theme(text=element_text(size=16)) +
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
      theme(text=element_text(size=16)) +
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
      theme(text=element_text(size=16)) +
      scale_fill_manual(values=fill_cols()) +
      theme(legend.position="none") +
      ggtitle("Median Family Earnings") +
      xlab("Family earnings ($)") +
      ylab("Frequency") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
    
  })
  
  output$row_1_T <- output$row_1_S <- output$row_1_M <- output$row_1_L <- renderPlot({
    if (school_size() == 'Total') {
      grid.arrange(get_legend(school_plot() + guides(fill = guide_legend(title = "School Size"))),
                   school_plot() + theme(legend.position="none"),
                   median_10yr_earn()+ theme(legend.position="none"),
                   ncol=3, nrow=1, 
                   widths=c(1, 5, 5))
    }
    else {
      grid.arrange(school_plot() + theme(legend.position="none"),
                   median_10yr_earn() + theme(legend.position="none"),
                   ncol=2, nrow=1)
    }
  })
    output$row_2_T <- output$row_2_S <- output$row_2_M <- output$row_2_L <- renderPlot({
      if (school_size() == 'Total') {
        grid.arrange(get_legend(school_plot() + guides(fill = guide_legend(title = "School Size"))),
                     female_dis_plot() + theme(legend.position="none"),
                     entry_age_plot() + theme(legend.position="none"),
                     ncol=3, nrow=1, 
                     widths=c(1, 5, 5))
      }
      else {
        grid.arrange(female_dis_plot() + theme(legend.position="none"),
                     entry_age_plot() + theme(legend.position="none"),
                     ncol=2, nrow=1)
      }
    })
      output$row_3_T <- output$row_3_S <- output$row_3_M <- output$row_3_L <- renderPlot({
        if (school_size() == 'Total') {
          grid.arrange(get_legend(school_plot() + guides(fill = guide_legend(title = "School Size"))),
                       perc_fed_loans() + theme(legend.position="none"),
                       med_fam_earn() + theme(legend.position="none"),
                       ncol=3, nrow=1, 
                       widths=c(1, 5, 5))
        }
        else {
          grid.arrange(perc_fed_loans() + theme(legend.position="none"),
                       med_fam_earn() + theme(legend.position="none"),
                       ncol=2, nrow=1)
        }
    
  })
}


shinyApp(ui = ui, server = server)