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
    mainPanel("Soci-economic factors",
      fluidRow(
        splitLayout(cellWidths = c("50%", "50%"), 
                    plotOutput("school_size_plot"),
                    plotOutput("female_dis_plot"))),
      fluidRow(
        splitLayout(cellWidths = c("50%", "50%"), 
                    plotOutput("median_10yr_earn"),
                    plotOutput("entry_age_plot"))),
      fluidRow(
        splitLayout(cellWidths = c("50%", "50%"), 
                    plotOutput("perc_fed_loans"),
                    plotOutput("med_fam_earn")))
    )
  )


server <- function(input, output) {
  data_filt <- data
  output$school_size_plot = renderPlot(
    data_filt %>% group_by(SCHOOL_SIZE) %>% summarise(count = n()) %>% 
      ggplot(aes(x=SCHOOL_SIZE, y=count, fill=SCHOOL_SIZE)) +
      geom_bar(colour="black", stat="identity", alpha=.3) +
      theme_bw() +
      theme(legend.position="none") +
      ggtitle("Number of Schools by Size") +
      xlab("School Size") + 
      ylab("Count") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank())
  )
  output$female_dis_plot = renderPlot(
    data_filt %>% filter(!is.na(female)) %>% 
      ggplot(aes(x=female, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
      theme_bw() + 
      theme(legend.position="none") +
      ggtitle("Percentage of Female Students") +
      xlab("Female students (%)") +
      ylab("Frequency") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
  )
  output$median_10yr_earn = renderPlot(
    data_filt %>% filter(!is.na(md_earn_wne_p10)) %>% 
      ggplot(aes(x=md_earn_wne_p10, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
      theme_bw() + 
      theme(legend.position="none") +
      ggtitle("Median Earnings 10yrs after Graduation") +
      xlab("Earnings ($)") +
      ylab("Frequency") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
  )
  output$entry_age_plot = renderPlot(
    data_filt %>% filter(!is.na(age_entry)) %>% 
      ggplot(aes(x=age_entry, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
      theme_bw() + 
      theme(legend.position="none") +
      ggtitle("Entrance Age") +
      xlab("Age") +
      ylab("Frequency") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
  )
  output$perc_fed_loans = renderPlot(
    data_filt %>% filter(!is.na(loan_ever)) %>% 
      ggplot(aes(x=loan_ever, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
      theme_bw() + 
      theme(legend.position="none") +
      ggtitle("Students Receiving Financial Aid (%)") +
      xlab("Financial aid (%)") +
      ylab("Frequency") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
  )
  output$med_fam_earn = renderPlot(
    data_filt %>% filter(!is.na(md_faminc)) %>% 
      ggplot(aes(x=md_faminc, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
      theme_bw() + 
      theme(legend.position="none") +
      ggtitle("Median Family Earnings") +
      xlab("Family earnings ($)") +
      ylab("Frequency") +
      theme(panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      guides(fill = guide_legend(title = "School Size"))
  )
  
}

shinyApp(ui = ui, server = server)
