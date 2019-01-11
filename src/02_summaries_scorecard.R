data2 <- read_csv("data/02_scorecard_clean.csv")

data3 <- data2 %>%
  group_by(STABBR) %>%
  summarize(loan=mean(loan_ever, na.rm=TRUE), female = (mean(female, na.rm=TRUE)))