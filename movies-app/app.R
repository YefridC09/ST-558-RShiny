# Load packages

library(shiny)
library(bslib)
library(tidyverse)
library(DT)

# Get the data

file <- "https://github.com/rstudio-education/shiny-course/raw/main/movies.RData"
destfile <- "movies.RData"

download.file(file, destfile)

# Load data

load("movies.RData")

# Define UI

ui <- page_sidebar(
  sidebar = sidebar(
    # Select variable for y-axis
    selectInput(
      inputId = "y",
      label = "Y-axis:",
      choices = c("IMDB Rating" = "imdb_rating", 
                  "IMDB Number of Votes" = "imdb_num_votes", 
                  "Critics Score" = "critics_score", 
                  "Audience Score" = "audience_score", 
                  "Runtime" = "runtime"),
      selected = "audience_score"
    ),
    # Select variable for x-axis
    selectInput(
      inputId = "x",
      label = "X-axis:",
      choices = c("IMDB Rating" = "imdb_rating", 
                  "IMDB Number of Votes" = "imdb_num_votes", 
                  "Critics Score" = "critics_score", 
                  "Audience Score" = "audience_score", 
                  "Runtime" = "runtime"),
      selected = "critics_score"
    ),
    selectInput(
      inputId = "z",
      label = "Color by:",
      choices = c("Title type" = "title_type", 
                  "Genre" = "genre", 
                  "MPAA rating" = "mpaa_rating", 
                  "Critics rating" = "critics_rating", 
                  "Audience rating" = "audience_rating"),
      selected = "mpaa_rating"
    ),
    
    # Set alpha leverl
    sliderInput(inputId = "alpha",
                label = "Set transparency",
                min = 0, max = 1,
                value = 0.8),
    
    #Add check box to show the data
    checkboxInput(inputId = "show_data",
                  label = "Show data table",
                  value = TRUE)
    
  
  ),
  # Output: Show scatterplot
  card(plotOutput(outputId = "scatterplot"),
       plotOutput(outputId = "densityplot", height = 200),
       dataTableOutput(outputId = "moviestable")
       )
)

# Define server

server <- function(input, output, session) {
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y, 
                                     color = input$z)) +
      geom_point(alpha = input$alpha)
  })
  
  output$densityplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x))+
      geom_density()
    
  })
  

  output$moviestable <- renderDataTable({
    if(input$show_data){
      DT::datatable(data = movies |> select(1:7),
                    options = list(pageLength = 10),
                    rownames = FALSE)
    }
  })
  
}

# Create a Shiny app object
# Display number of observations
HTML(paste0("The dataset has ", nrow(movies),
            "observations."))

shinyApp(ui = ui, server = server)