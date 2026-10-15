library(shiny)
library(bslib)
library(bsicons)
library(maps)
library(mapproj)

source("helpers.R")
counties <- readRDS("data/counties.rds")

# User interface ----
ui <- page_sidebar(
  title = "censusVis",
  
  sidebar = sidebar("Create demographic maps with information from the 2010 US Census",
                    selectInput(
                      "var",
                      label = "Choose a variable to display",
                      choices = list("Percent White" = "white", 
                                     "Percent Black" = "black",
                                     "Percent Hispanic" = "hispanic",
                                     "Percent Asian" = "asian"),
                      selected = 1
                    ),
                    sliderInput(
                      "range",
                      label = "Range of interest:",
                      min = 0,
                      max = 100,
                      value = c(0, 100)
                    )
                    ),
  card(plotOutput("map"))
  
  
)
# Define server logic ----
server <- function(input, output) {
 # color <- "darkgreen"
  output$map <- renderPlot({
    l_title <- paste("%", input$var)
    percent_map(
      var = counties[[input$var]], 
      color = switch(input$var,
                     "white" = "red", 
                     "black" = "black",
                     "hispanic" = "darkorange",
                     "asian" = "darkviolet"
                     ), 
      legend.title = l_title,
      max = input$range[2],
      min = input$range[1])
  })
  
  # output$selected_var <- renderText({
  #  paste("You have selected this: ", input$var)
  # }
  # )
  # output$selected_range <- renderText({
  #   paste("You have choosen a range that goes from ", 
  #         input$range[1], 
  #         " to ",
  #         input$range[2])
  #   
  # })
}

# Run the app ----
shinyApp(ui = ui, server = server)