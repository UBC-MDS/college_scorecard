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
library(gridExtra)
library(cowplot)

data <- read_csv("../data/02_scorecard_clean.csv")
states <- as.list(unique(data$STABBR))
adm_rate <- as.numeric(data$ADM_Rate_P)
sch_size <- as.list(unique(data$SCHOOL_SIZE))

ui <- fluidPage(
  
  titlePanel("Impact of School Size on Higher Education (US)"
             ),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("State1Input", label = h3("State"), 
                  choices = states, 
                  selected = 1),
    
      sliderInput("adm_rate", label = h3("Admission Rate"), step = 5,
                min = 0.0, max = 100.0, value = c(0,100),
                sep = ""
                )
    ),
    
  mainPanel(
    tabsetPanel(
      tabPanel("Total", plotOutput("row_1"), plotOutput("row_2"), plotOutput("row_3")),
      tabPanel("Small Schools", plotOutput(""), plotOutput(""), plotOutput("")),
      tabPanel("Medium Schools", plotOutput(""), plotOutput(""), plotOutput("")),
      tabPanel("Large Schools", plotOutput(""), plotOutput(""), plotOutput(""))
      )
  )
  )
)

server <- function(input, output) {
  data_filt <- data
  school_size_plot <- data_filt %>% group_by(SCHOOL_SIZE) %>% summarise(count = n()) %>% 
    ggplot(aes(x=SCHOOL_SIZE, y=count, fill=SCHOOL_SIZE)) +
    geom_bar(colour="black", stat="identity", alpha=.3) +
    theme_bw() +
    theme(legend.position="none") +
    ggtitle("Number of Schools by Size") +
    xlab("School Size") + 
    ylab("Count") +
    theme(panel.background = element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
  female_dis_plot <- data_filt %>% filter(!is.na(female)) %>% 
    ggplot(aes(x=female, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
    theme_bw() + 
    ggtitle("Percentage of Female Students") +
    xlab("Female students (%)") +
    ylab("Frequency") +
    theme(panel.background = element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    guides(fill = guide_legend(title = "School Size"))
  median_10yr_earn <- data_filt %>% filter(!is.na(md_earn_wne_p10)) %>% 
    ggplot(aes(x=md_earn_wne_p10, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
    theme_bw() + 
    theme(legend.position="none") +
    ggtitle("Median Earnings 10yrs after Graduation") +
    xlab("Earnings ($)") +
    ylab("Frequency") +
    theme(panel.background = element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    guides(fill = guide_legend(title = "School Size"))
  entry_age_plot <- data_filt %>% filter(!is.na(age_entry)) %>% 
    ggplot(aes(x=age_entry, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
    theme_bw() + 
    theme(legend.position="none") +
    ggtitle("Entrance Age") +
    xlab("Age") +
    ylab("Frequency") +
    theme(panel.background = element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    guides(fill = guide_legend(title = "School Size"))
  perc_fed_loans <- data_filt %>% filter(!is.na(loan_ever)) %>% 
    ggplot(aes(x=loan_ever, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
    theme_bw() + 
    theme(legend.position="none") +
    ggtitle("Students Receiving Financial Aid (%)") +
    xlab("Financial aid (%)") +
    ylab("Frequency") +
    theme(panel.background = element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    guides(fill = guide_legend(title = "School Size"))
  med_fam_earn <- data_filt %>% filter(!is.na(md_faminc)) %>% 
    ggplot(aes(x=md_faminc, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
    theme_bw() + 
    theme(legend.position="none") +
    ggtitle("Median Family Earnings") +
    xlab("Family earnings ($)") +
    ylab("Frequency") +
    theme(panel.background = element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    guides(fill = guide_legend(title = "School Size"))
  legend <- get_legend(female_dis_plot)
  female_dis_plot <- female_dis_plot + theme(legend.position="none")
  output$row_1 = renderPlot(
    grid.arrange(school_size_plot, 
                 median_10yr_earn,
                 legend,
                 ncol=3, nrow=1, 
                 widths=c(5.3, 5.3, 0.8))
  )
  output$row_2 = renderPlot(
    grid.arrange(entry_age_plot,
                 female_dis_plot,
                 legend,
                 ncol=3, nrow=1, 
                 widths=c(5.3, 5.3, 0.8))
  )
  output$row_3 = renderPlot(
    grid.arrange(perc_fed_loans,
                 med_fam_earn,
                 legend,
                 ncol=3, nrow=1, 
                 widths=c(5.3, 5.3, 0.8))
  )
}

shinyApp(ui = ui, server = server)
