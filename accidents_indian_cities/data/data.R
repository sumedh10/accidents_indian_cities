library(tidyverse)

# Data Source: https://data.gov.in/catalog/road-accidents-profile-selected-cities
# Register here to get your personal api key: https://data.gov.in/


data_source <- "/resource/c300b4b7-446d-45fa-a16a-d03095422efd"
personal_api_key <- "PERSONAL_API_KEY_HERE"  



data_url <- paste0("https://api.data.gov.in", data_source, 
                   "?api-key=", personal_api_key, "&format=csv&offset=0")

accidents <- read_csv(data_url)

write_csv(accidents, "accidents_raw.csv")

metro <- c("Delhi", "Mumbai", "Kolkata", "Bengaluru", 
           "Hyderabad", "Chennai", "Pune")

accidents_processed <- accidents %>% 
    rename(city = name_of_city) %>% 
    filter(city != "Total") %>% 
    mutate(city = recode(city, 
                         Vizaq = "Visakhapatnam", 
                         `Vijaywada City` = "Vijayawada City", 
                         Thiruvanthapuram = "Thiruvananthapuram", 
                         Vadodra = "Vadodara")) %>% 
    group_by(city) %>% 
    summarise_all(funs(sum(., na.rm = TRUE))) %>% 
    gather("category_year", "count", -city) %>% 
    separate(category_year, c("category", "year"), "___") %>% 
    mutate(category = recode(category, 
                             all_accidents = "total_accidents", 
                             persons_killed = "killed", 
                             persons_injured = "injured")) %>% 
    filter(category %in% c("total_accidents", "killed", "injured")) %>% 
    mutate(region = ifelse(city %in% metro, "metro", "non_metro"), 
           count = ifelse(count == 0, NA, count)) %>% 
    group_by(city, category) %>% 
    arrange(year) %>% 
    mutate(total_count = sum(count, na.rm = TRUE), 
           cumulative_count = cumsum(coalesce(count, 0)) + count*0) %>%
    ungroup()

write_csv(accidents_processed, "accidents_processed.csv")
