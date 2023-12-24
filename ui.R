#'
#' Next Word Predictor
#'  
#' This is a very simple application for predicting next word based on user input
#' 
#' 
#' @author Deniz
#' 
#' @details This app takes in the text input from user and predicts next word
#'  
#' @import shiny


library(shiny)

# Define UI for application that predicts next word
fluidPage(

    # Application title
    titlePanel("Next Word Predictor"),

    # Sidebar 
    sidebarLayout(
        sidebarPanel(
              h3("Instructions"),
              tags$div(class="header", checked=NA,
                       tags$p("Type in the text field below and click \"Submit\" button or press \"Enter\", to see the most likely next word 
                        displayed at the main panel. ")),
              h3("Input"),
              textInput("inputWords",
                        "Please type here:"),
              submitButton("Submit")
  
        ),

        # print the predicted value
        mainPanel(
              h3("Predicted next word:"),
              textOutput("value")
        )
    )
)
