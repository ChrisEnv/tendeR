library(tidyRSS)
library(tidyverse)
library(lubridate)

fetch_rss_data <- function(url) {
  # Fetch RSS feed and parse
  rss_data <- tidyfeed(url)
  
  return(rss_data)
}

# URL of the RSS feed
rss_url <- "https://www.service.bund.de/Content/Globals/Functions/RSSFeed/RSSGenerator_Ausschreibungen.xml"

# Fetch data
rss_data <- fetch_rss_data(rss_url)

# Generate a filename with the current date and time
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
file_path <- sprintf("data/rss_feed_data_%s.csv", timestamp)

# Write the data to a new CSV file
write_csv(rss_data, file_path)
