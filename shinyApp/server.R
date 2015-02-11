library(shiny)
library(ggplot2)
library(scales)
library(plyr)

data <- read.csv("../data/TimeLogger.csv", stringsAsFactors = FALSE)
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
temp.mean <- ddply(data, .(start.date, category), function(df) mean(df$total.decimal))
temp.sum <- ddply(data, .(start.date, category), function(df) sum(df$total.decimal))
temp.sum <- transform(temp.sum, V1.cat = 
                    cut(V1,  
                        breaks = seq(0,9), 
                        labels =c("0-1", "1-2", "2-3", "3-4","4-5", "5-6", "6-7", "7-8", ">8")))



# Define server logic required to draw a histogram
shinyServer(
  function(input, output){
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
    output$plot1 <- renderPlot(
      {
        ggplot(data[data$category == input$category,], 
               aes(start, total.decimal)) + 
          geom_bar(stat = "identity") + 
          ylab("hours") + 
          scale_x_datetime(breaks = date_breaks("1 day")) + 
          theme(axis.text.x = element_text(angle = 90))
        }
    )
    output$plot2 <- renderPlot(
      {
        ggplot(temp.mean, aes(start.date, category, fill = V1)) + geom_tile()
      }
    )
    output$plot3 <- renderPlot(
      {
        ggplot(temp.sum, aes(start.date, category, fill = V1.cat)) + 
          geom_tile(color = "lightgrey") + 
          scale_fill_brewer(palette = "Spectral", name = "total hours") + 
          ylab("") +xlab("date")
      }
    )
  }
)