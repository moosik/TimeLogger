library(shiny)

shinyUI(
  navbarPage("TimeLogger retrospective",
             tabPanel("Reading over time", 
                      selectInput("category", label = "Category", 
                                  choices = c("At Work", "Hobby", "Honest Work", "Housework")),
                      plotOutput("plot1")),
             tabPanel("Average time for all", plotOutput("plot2")),
             tabPanel("Total time for all", plotOutput("plot3"))
  )
)

# Define UI for application that draws a histogram
# shinyUI(
#   fluidPage(
#     # Application title
#     titlePanel("Hello Shiny!"),
#     
#     # Sidebar with a slider input for the number of bins
#     sidebarLayout(
#       sidebarPanel(
#         sliderInput("bins",
#                   "Number of bins:",
#                   min = 1,
#                   max = 50,
#                   value = 30)),
#       # Show a plot of the generated distribution
#       mainPanel(
#         plotOutput("distPlot"))
#     )
#   )
# )