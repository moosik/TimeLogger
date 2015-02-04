## Libraries
library(cron) # had to install manually from a zip archive
library(ggplot2)
library(scales)
library(plyr)


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
# Add just the date for the start and the end, must specify the time zone,
# Seattle is in America/Los_Angeles
data <- transform(data, start.date = as.Date(start, tz = "America/Los_Angeles"))
data <- transform(data, end.date = as.Date(end, tz = "America/Los_Angeles"))

# Analysis of categories
# Time spent every day on doing something within a particular category
# Example: "Reading"
ggplot(data[data$category == "Reading",], aes(start, total.decimal)) + geom_bar(stat = "identity") + ylab("hours") + scale_x_datetime(breaks = date_breaks("1 day")) + theme(axis.text.x = element_text(angle = 90))
# Using just the start date, formatting the date
ggplot(data[data$category == "Reading",], aes(start.date, total.decimal)) + geom_bar(stat = "identity") + ylab("hours") + theme(axis.text.x = element_text(angle = 90)) + scale_x_date(labels = date_format("%m/%d"))

# What activities were tracked over the period of time. Color reflects statistics per day
# Can also do it per week, per month, etc. Average, sum
# Plyr function to do the summary, mean
temp <- ddply(data, .(start.date, category), function(df) mean(df$total.decimal))
ggplot(temp, aes(start.date, category, fill = V1)) + geom_tile()
# Plyr function to do the summary, sum
temp <- ddply(data, .(start.date, category), function(df) sum(df$total.decimal))
ggplot(temp, aes(start.date, category, fill = V1)) + geom_tile(color = "lightgrey") + scale_fill_gradient(low  = "yellow", high = "blue", name = "hours")
# Plotting results as categories
# Try to cut the time into the categories, max  = 8
temp <- transform(temp, V1.cat = 
                    cut(V1,  breaks = seq(0,9), labels =c("0-1", "1-2", "2-3", "3-4","4-5", "5-6", "6-7", "7-8", ">8")))
ggplot(temp, aes(start.date, category, fill = V1.cat)) + geom_tile(color = "lightgrey") + scale_fill_brewer(palette = "Spectral", name = "total hours") + ylab("") +xlab("date")
# using points and the size of the point is proportional to the value
ggplot(temp, aes(start.date, category, size = V1.cat, color = V1.cat)) + geom_point() + ylab("") +xlab("date")
# Show total activity in a day as percentage of an average 16 hours day:(temp has sum)
temp <- transform(temp, percent = (V1*100)/16)
temp <- transform(temp, percent.cat = cut(percent, breaks = seq(0,100,10), labels = c("<10", "10-20", "20-30", "30-40","40-50", "50-60", "60-70", "70-80", "80-90", "90-100")))
ggplot(temp, aes(start.date, category, fill = percent.cat)) + geom_tile(color = "lightgrey") + scale_fill_brewer(palette = "Spectral", name = "% day") + ylab("") +xlab("date")
