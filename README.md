# RSS Feed Analytics

## Overview
This project is designed to fetch and store data from a specified RSS feed over time. It is set up to run periodically, collecting data and appending it to a CSV file stored locally.

## Setup
To run the scripts, ensure you have R and the necessary packages (`XML`, `httr`, `dplyr`, `lubridate`) installed. You can install them using `install.packages()`.

## Running the Script
Navigate to the `scripts` directory and run `fetch_data.R`. This script can be scheduled to run automatically using cron jobs or similar schedulers.

## Data
The fetched data is stored in the `data` directory under `rss_feed_data.csv`.
