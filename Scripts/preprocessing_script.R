library(dplyr)
library(stringr)
library(ggplot2)
library(data.table)



# a generic function to prepare data for a specific city, data_date
prepare_data <- function(city)
{
  data_filtered <- all_data %>% filter(city == my_city)
  data_filtered <-data_filtered[order(data_filtered$data_date, decreasing = TRUE),]
  
  for(j in 1:3){
    
    my_row <- data_filtered[j,]
    print(my_row$listings_url)
  
  
  # Cleaning listings dataframe
  
  print(paste0("reading data from ", my_row$listings_url))
    
  listings <- read.csv(textConnection(readLines(gzcon(url(my_row$listings_url)))))
  print(paste0("reading data from ", my_row$calendar_url))
  calendar <-  read.csv(textConnection(readLines(gzcon(url(my_row$calendar_url)))))
  
  ## Add Keys: columns city and day date
  listings$city <- my_row$city
  listings$country <- my_row$country
  listings$data_date <- my_row$data_date
  

  ## Select interesting columns
  ### Most columns don't contain interesting information
  columns_listings <- c("country", "city","listing_url","data_date", "id", "neighbourhood_cleansed", 
                        "latitude", "longitude", 
                        "property_type", "room_type", "accommodates", "bedrooms", 
                        "beds", "price", "minimum_nights",  "maximum_nights")
  
  listings <- listings %>% 
    select(columns_listings) %>% 
    arrange(id)
  
  
  # Cleaning calendar dataframe
  
  ## arrange by id and date
  calendar <- calendar %>% 
    arrange(listing_id, date)
  
  ## add day number (starting first day)
  calendar <- calendar %>%
    group_by(listing_id) %>%
    mutate(day_nb = row_number()) %>%
    ungroup()
  
  ## change available column to binary
  calendar <- calendar %>%
    mutate(available = ifelse(available=="t", 1, 0))
  
  ## clean price column and transform to numeric
  calendar <- calendar %>%
    mutate(price = str_replace(price, "\\$", ""),
           adjusted_price = str_replace(adjusted_price, "\\$", ""))
  calendar <- calendar %>%
    mutate(price = str_replace(price, ",", ""),
           adjusted_price = str_replace(adjusted_price, ",", ""))
  calendar <- calendar %>%
    mutate(price = as.numeric(price),
           adjusted_price = as.numeric(adjusted_price))
  
  ## calculate estimated revenue for upcoming day
  calendar <- calendar %>%
    mutate(revenue = price*(1-available))
  
  ## calculate availability, price, revenue for next 30, 60 days ... for each listing_id
  calendar <- calendar %>%
    group_by(listing_id) %>%
    summarise(availability_30 = sum(available[day_nb<=30], na.rm = TRUE),
              #availability_60 = sum(available[day_nb<=60], na.rm = TRUE),
              #availability_90 = sum(available[day_nb<=90], na.rm = TRUE),
              #availability_365 = sum(available[day_nb<=365], na.rm = TRUE),
              price_30 = mean(price[day_nb<=30 & available==0], na.rm = TRUE),
              #price_60 = mean(price[day_nb<=60 & available==0], na.rm = TRUE),
              #price_90 = mean(price[day_nb<=90 & available==0], na.rm = TRUE),
              #price_365 = mean(price[day_nb<=365 & available==0], na.rm = TRUE),
              revenue_30 = sum(revenue[day_nb<=30], na.rm = TRUE),
              #revenue_60 = sum(revenue[day_nb<=60], na.rm = TRUE),
              #revenue_90 = sum(revenue[day_nb<=90], na.rm = TRUE),
              #revenue_365 = sum(revenue[day_nb<=365], na.rm = TRUE)           
    )
  listings$id <- as.integer(listings$id)
  listings_cleansed <- listings %>% left_join(calendar, by = c("id" = "listing_id"))
  
  dir.create(file.path("..","Data","data_cleansed", city, my_row$data_date), recursive = TRUE)
  
  write.csv(listings_cleansed, file.path("..","Data","data_cleansed", city, my_row$data_date, "listings.csv"))
  print(paste0("saving data into ", file.path("..","Data","data_cleansed", city, my_row$data_date, "listings.csv")))
  }
}
 



cities <- c("austin", "bordeaux", "cambridge", "malaga", "mallorca", "sevilla")


all_data <-read.csv("../Data/all_data.csv")


for(i in 1:length(cities)){
  my_city <- cities[i]
  print("-------------------------------------------------")
  print(paste(c("Preparing data for", my_city), collapse = " "))
  prepare_data(my_city)
}

# Clean Environment
rm(list=ls())
  

cities <- c("austin", "bordeaux", "cambridge", "malaga", "mallorca", "sevilla")

# We are only interested in data between min_date and max_date
min_date <- '2020-01-01'
max_date <- '2020-12-31'

files_paths <- c()

# Read data in cities between min_date and max_date
for(city in cities){
  file_dir <- file.path("..","Data", "data_cleansed", city)
  file_subdirs <- list.dirs(file_dir)
  file_subdirs <- file_subdirs[-1]
  
  for(file_subdir in file_subdirs){
    if(file_subdir < file.path(file_dir, min_date) | file_subdir > file.path(file_dir, max_date)  )
      file_subdirs = file_subdirs[file_subdirs != file_subdir]
  }
  files_paths <- c(files_paths, file_subdirs)
}

files_paths <- file.path(files_paths, "listings.csv")
listings <- 
  do.call(rbind,
          lapply(files_paths, read.csv, row.names=1))


## Preprocess
listings$room_type <- ifelse(listings$room_type != "Entire home/apt" & listings$room_type != "Hotel room" & listings$room_type != "Private room" & listings$room_type != "Shared room", "Undefined", listings$room_type)
listings$bedrooms <- ifelse(listings$bedrooms != "4" & listings$bedrooms != "3" & listings$bedrooms != "2" & listings$bedrooms != "1", "5+", listings$bedrooms)



listings$longitude <- as.numeric(listings$longitude)
listings$latitude <- as.numeric(listings$latitude)
listings$longitude <- ifelse(listings$longitude>2000,-97.5,listings$longitude)
listings$latitude <- ifelse(is.na(listings$latitude),30.2,listings$latitude)

View(listings)

listings$availability_30 <- ifelse(is.na(listings$availability_30),0,listings$availability_30)
listings$revenue_30 <- ifelse(is.na(listings$revenue_30),0,listings$revenue_30)


listings$price_30 <- ifelse(is.na(listings$price_30), "0", listings$price_30)

View(listings)

write.csv(listings, file.path("..","Data","listings.csv"))
print(paste0("saving data into ", file.path("..","Data","data_cleansed", "listings2.csv")))




