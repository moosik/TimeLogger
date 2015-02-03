## Libraries
library(cron) # had to install manually from a zip archive
library(ggplot2)


## Read sample data
data <- read.csv("./data/TimeLogger.csv", stringsAsFactors = FALSE)

## Format the data

## Colnames
colnames(data) <- c("start", "end", "total", "total.decimal", "category", "client", 
                    "job", "description")

# Convert start and end to POSIXct class
data <- transform(data, start = as.POSIXct(start))
data <- transform(data, end = as.POSIXct(end))

# Add weekday and the month information

data <- transform(data, weekdays.start = weekdays(data$start))
data <- transform(data, weekdays.end = weekdays(data$end))
data <- transform(data, month.start = months(data$start))
data <- transform(data, month.end = months(data$end))
