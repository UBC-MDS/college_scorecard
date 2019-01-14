#! /usr/bin/env Rscript 
# 02_explore_scorecard.R
# Author: Sarah Watts
# Date: January 2019
#
# This script uses the data found in the 02_scorecard_clean.csv data file 
# And creates the following plots:
#    1. A bar plot showing a count of schools by size
#    2. A density plot showing the distribution of female % of attendees by size of a school
#    3. A density plot showing the distribution of median earnings 10yrs after attendence by size of a school
#    4. A density plot showing the distribution of entry age by size of a school
#    5. A density plot showing the distribution of the % of loans recieved by size of a school
#    6. A density plot showing the distribution of the family income by size of a school

# This script creates graphs that can be used in the shiny app
library(tidyverse)
library(ggplot2)

main <- function(){
  data <- read_csv("data/02_scorecard_clean.csv")
  school_size_plot(data)
  female_dis_plot(data)
  median_10yr_earn(data)  
  entry_age_plot(data)
  perc_fed_loans(data)
  med_fam_earn(data)
}

school_size_plot <- function(data){
  count_schools <- data %>% group_by(SCHOOL_SIZE) %>% summarise(count = n()) %>% arrange(count, desc(count))
  plot <- count_schools %>% ggplot(aes(x=SCHOOL_SIZE, y=count, fill=SCHOOL_SIZE)) +
    geom_bar(colour="black", stat="identity", alpha=.3) +
    theme_bw() +
    theme(legend.position="none") +
    ggtitle("Number of Schools by Size") +
    xlab("School Size") + 
    ylab("Count") +
    theme(panel.background = element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
  return(plot)
}

female_dis_plot <- function(data){
  filter_data <- data %>% filter(!is.na(female))
  plot <- filter_data %>% ggplot(aes(x=female, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
    theme_bw() + 
    ggtitle("Percentage of Female Students") +
    xlab("Female students (%)") +
    ylab("Frequency") +
    theme(panel.background = element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    guides(fill = guide_legend(title = "School Size"))
  return(plot)
}

median_10yr_earn <- function(data){
  filter_data <- data %>% filter(!is.na(md_earn_wne_p10))
  plot <- filter_data %>% ggplot(aes(x=md_earn_wne_p10, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
    theme_bw() + 
    theme(legend.position="none") +
    ggtitle("Median Earnings 10yrs after Graduation") +
    xlab("Earnings ($)") +
    ylab("Frequency") +
    theme(panel.background = element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    guides(fill = guide_legend(title = "School Size"))
  return(plot)
}

entry_age_plot <- function(data){
  filter_data <- data %>% filter(!is.na(age_entry))
  plot <- filter_data %>% ggplot(aes(x=age_entry, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
    theme_bw() + 
    theme(legend.position="none") +
    ggtitle("Entrance Age") +
    xlab("Age") +
    ylab("Frequency") +
    theme(panel.background = element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    guides(fill = guide_legend(title = "School Size"))
  return(plot)
}

perc_fed_loans <- function(data){
  filter_data <- data %>% filter(!is.na(loan_ever))
  plot <- filter_data %>% ggplot(aes(x=loan_ever, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
    theme_bw() + 
    theme(legend.position="none") +
    ggtitle("Students Receiving Financial Aid (%)") +
    xlab("Financial aid (%)") +
    ylab("Frequency") +
    theme(panel.background = element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    guides(fill = guide_legend(title = "School Size"))
  return(plot)
}

med_fam_earn <- function(data){
  filter_data <- data %>% filter(!is.na(md_faminc))
  plot <- filter_data %>% ggplot(aes(x=md_faminc, fill=SCHOOL_SIZE)) + geom_density(alpha=.3) +
    theme_bw() + 
    theme(legend.position="none") +
    ggtitle("Median Family Earnings") +
    xlab("Family earnings ($)") +
    ylab("Frequency") +
    theme(panel.background = element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    guides(fill = guide_legend(title = "School Size"))
  return(plot)
}

main()
