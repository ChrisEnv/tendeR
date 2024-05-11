# load packages
library("DBI")
library("here")
library("tidyverse")

# create a function to write data to a database
write_db <- function(data, db_path = here("db", "db.sqlite"), table_name) {
  # create a connection to the database
  con <- dbConnect(RSQLite::SQLite(), db_path)
  
  # write the data to the database
  dbWriteTable(con, table_name, data, overwrite = FALSE, append = TRUE)
  
  # close the connection
  dbDisconnect(con)
}

rel_cols <- c("feed_pub_date",
              "item_title",
              "item_link",
              "item_description",
              "item_pub_date",
              "item_guid"
)

# prepare data to be written to the database
prepare_data <- function(csv_path,
                         rel_cols = c("feed_pub_date",
                                      "item_title",
                                      "item_link",
                                      "item_description",
                                      "item_pub_date",
                                      "item_guid")
                         ){
  # read the data
  data <- read_csv(csv_path)
  
  # select relevant columns
  
  data <- data %>% select(all_of(rel_cols))
  
  # return the data
  return(data)
}

# join into db

join_into_db <- function(csv_path, table_name = "rss_items", db_path = here("db", "db.sqlite")) {
  
  # call prepare_data on a single file
  csv_data <- prepare_data(csv_path)

  # read all from db
  db <- dbConnect(RSQLite::SQLite(), db_path)
  db_data <- dbReadTable(db, table_name) %>% as_tibble()
  
  # remove id column from db_data
  db_data <- db_data %>% select(-id)
  
  # parse all *date columns to numeric and datetime
  
  db_data <- db_data %>% 
    mutate_at(vars(ends_with("date")), as.numeric) %>% 
    mutate_at(vars(ends_with("date")), as_datetime)
  
  # setdiff the data based on unique identifiers: item_link, item_guid
  
  data <- anti_join(csv_data, db_data, by = c("item_link", "item_guid"))
  
  # print number of rows to be added
  
  print(paste0("Adding ", nrow(data), " rows to the database"))

  # write the data to the database
  write_db(data, table_name = table_name)
  
  # close the connection
  dbDisconnect(db)
}

print_db <- function(){
  
  # connect to db and read all
  db <- dbConnect(RSQLite::SQLite(), here("db", "db.sqlite"))
  data <- dbReadTable(db, "rss_items") %>% 
    as_tibble() %>% 
    mutate_at(vars(ends_with("date")), as.numeric) %>% 
    mutate_at(vars(ends_with("date")), as_datetime)
  
  # close connection
  dbDisconnect(db)
  
  # print the data
  print(data)
}

# check which item_guid entrys are multiple times in the db and return whole rows

check_guid <- function(){
  
  # connect to db and read all
  db <- dbConnect(RSQLite::SQLite(), here("db", "db.sqlite"))
  data <- dbReadTable(db, "rss_items") %>% 
    as_tibble() %>% 
    mutate_at(vars(ends_with("date")), as.numeric) %>% 
    mutate_at(vars(ends_with("date")), as_datetime)
  
  # close connection
  dbDisconnect(db)
  
  # check for duplicates
  data %>% 
    group_by(item_guid) %>% 
    filter(n() > 1)
}




