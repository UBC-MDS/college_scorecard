# This script creates graphs that can be used in the shiny app
library(tidyverse)

main <- function(){
  count_states <- data %>% group_by(STABBR) %>% summarise(count = n()) %>% arrange(count, desc(count))
}
