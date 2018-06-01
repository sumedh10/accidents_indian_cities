library(shinydashboard)
library(tidyverse)
library(plotly)

accidents_data <- read_csv("data/accidents_processed.csv")

all_cities <- sort(unique(accidents_data$city))
