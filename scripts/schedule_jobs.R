library(cronR)

# Path to the script that fetches the RSS data
script_path <- "scripts/fetch_data.R"

# Log file paths
log_file <- "logs/fetch_data_log.txt"
error_file <- "logs/fetch_data_error.txt"

# Schedule the fetching script to run daily at 7:00 AM
cmd <- cron_rscript(script_path, output = log_file, error = error_file)

# Add the cron job
job_id <- "daily_rss_fetch"
if (cron_exists(job_id)) {
  cron_rm(job_id)  # Remove the existing job if it already exists
}
cron_add(cmd, frequency = 'daily', at = '07:00', id = job_id)

# To view all current cron jobs
print(cron_ls())

# Instructions to manually remove or edit the job if needed:
# cron_rm("daily_rss_fetch")
# cron_edit(id = "daily_rss_fetch")
