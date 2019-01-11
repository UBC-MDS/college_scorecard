#! /usr/bin/env Rscript 
# 01_load_and_clean_data.R
# Author: Sarah Watts
# Date: January 2019
#
# This script tidies the 01_raw_data_scorecard.txt data file and retains the relevant 
# columns needed for the scorecard.csv shiny app
# Its output is a clean csv file (scorecard_clean.csv)

library(tidyverse)

main <- function(){
  data <- read_csv("data/01_raw_data_scorecard.txt")
  # only retain: 
  #     State postcode, 
  #     Share of students who received a federal loan while in school,
  #     Share of female students, via SSA data,
  #     Average age of entry, via SSA data,
  #     Median earnings of students working and not enrolled 10 years after entry,
  #     Median family income
  clean_data <- data %>% select(STABBR, loan_ever, female, age_entry, md_faminc, md_earn_wne_p10)
  write_csv(clean_data, "data/02_scorecard_clean.csv")
}

main()