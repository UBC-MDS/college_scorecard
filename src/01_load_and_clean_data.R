#! /usr/bin/env Rscript 
# 01_load_and_clean_data.R
# Author: Sarah Watts
# Date: January 2019
#
# This scripts loads data originating from:
# https://github.ubc.ca/MDS-2018-19/DSCI_532_viz-2_students/blob/master/oversized_datasets/scorecard.csv
# Saved in this repo as: "data/01_A_oversized_scorecard.csv"
# -------------------------------
# This script loads a subset of data originating from:
# https://ed-public-download.app.cloud.gov/downloads/Most-Recent-Cohorts-All-Data-Elements.csv
# Saved in this repo as: "data/01_B_subset_recent_scorecard.csv"
# -------------------------------
# The following operations are performed on the loaded datasets:
#    1. These two datasets are stored as tidy dataframes and joined
#    2. Only the values: UNITID, STABBR, loan_ever, female, age_entry, md_faminc, 
#                        md_earn_wne_p10, UGDS, ADM_RATE
#       are retained. 
#    3. Universities where UGDS (number of undergraduate students) = Null are removed
#    4. Add a column for "school size" based on: 
#           Large school: 15,000 +
#           Medium school: 5,000-15,000
#           Small school: 0-5,000
# columns needed for the scorecard.csv shiny app
# Its output is a clean csv file (scorecard_clean.csv)

library(tidyverse)

main <- function(){
  # load data saved in this repo as: "data/01_A_oversized_scorecard.csv"
  data_A <- read_csv("data/01_A_oversized_scorecard.csv")
  # only retain: 
  #     UNITID - Unit ID for institution
  #     STABBR - State postcode, 
  #     loan_ever - Share of students who received a federal loan while in school,
  #     female - Share of female students, via SSA data,
  #     age_entry - Average age of entry, via SSA data,
  #     md_earn_wne_p10 - Median earnings of students working and not enrolled 10 years after entry,
  #     md_faminc - Median family income
  data_A <- data_A %>% select(UNITID, STABBR, loan_ever, female, age_entry, md_faminc, md_earn_wne_p10)
  # load data saved in this repo as: "data/01_B_subset_recent_scorecard.csv"
  data_B <- read_csv("data/01_B_subset_recent_scorecard.csv")
  # only retain: 
  #     UNITID - Unit ID for institution
  #     UGDS - Enrollment of all undergraduate students
  #     ADM_RATE - Admission rate
  data_B <- data_B %>% select(UNITID, UGDS, ADM_RATE)
  # Add a column for school size (removing schools without an enrollment size)
  data_all <- left_join(data_A, data_B, by = "UNITID") %>% 
                filter(UGDS != "NULL") %>% 
                mutate(ADM_RATE_CLEAN = str_replace_all(ADM_RATE, "NULL", NA_character_)) %>%
                transform(ADM_RATE = as.numeric(ADM_RATE_CLEAN), UGDS = as.numeric(UGDS)) %>%
                select(-ADM_RATE_CLEAN) %>%
                mutate(SCHOOL_SIZE = ifelse(UGDS < 5000, "Small",
                                          ifelse(UGDS < 15000, "Medium", "Large")))
  write_csv(data_all, "data/02_scorecard_clean.csv")
}

main()