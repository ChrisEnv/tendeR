# load packages
library("DBI")
library("here")
library("tidyverse")

# create db in db folder

if (!file.exists(here("db", "db.sqlite"))) {
  db <- dbConnect(RSQLite::SQLite(), here("db", "db.sqlite"))
  dbDisconnect(db)
}

# analyse structure of data

csv_dir <- here("data")
csv_files <- list.files(csv_dir, pattern = "\\.csv$", full.names = TRUE)

# select first file and get header
csv_file <- csv_files[1]
csv_data <- read_csv(csv_file)

# define relevant information columns

rel_cols <- c("feed_pub_date",
              "item_title",
              "item_link",
              "item_description",
              "item_pub_date",
              "item_guid"
)

# create table

db <- dbConnect(RSQLite::SQLite(), here("db", "db.sqlite"))

dbExecute(db, "
  CREATE TABLE IF NOT EXISTS rss_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    feed_pub_date TEXT,
    item_title TEXT,
    item_link TEXT,
    item_description TEXT,
    item_pub_date TEXT,
    item_guid TEXT,
    UNIQUE(item_link, item_guid)
  )
")

# close connection

dbDisconnect(db)
