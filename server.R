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
#' @import data.table
#' @import stringr

library(shiny)
library(stringr)
library(data.table)

# Load trigram/bigram/unigram datatables
tritable <- readRDS(file="trigram.RDS")
bitable <- readRDS(file="bigram.RDS")
unitable <- readRDS(file="unigram.RDS")

# Helper functions
findintrigram <- function(w1, w2) {
      ngwords <- tritable[.(w1, w2)][order(-freq)][1]
      if(any(is.na(ngwords)))
            findinbigram(w2)
      else 
            return (ngwords[, word3])
}

findinbigram <- function(w) {
      ngwords <- bitable[w][order(-freq)][1]
      if(any(is.na(ngwords)))
            retunigram()
      else
            return (ngwords[, word2])
}

retunigram <- function() {
      return(sample(unimini[,word1], 1))
      
}

# Define server logic 
shinyServer(function(input, output) {
      wordPredict <- reactive({
            textin <- input$inputWords
            
            # input text preparation
            inText <- tolower(textin)
            
            inwords <- strsplit(inText, " ")
            l <- length(inwords[[1]])
            
            if (l > 2) {
                  return (findintrigram(inwords[[1]][l-1], inwords[[1]][l]))
            }
            else if (l == 2)
                  return (findintrigram(inwords[[1]][1], inwords[[1]][2]))
            else if (l == 1) {
                  return (findinbigram(inwords[[1]][1]))
            }
            else
                  return ("")
            
      })
      
      output$value <- renderText({ 
            wordPredict()
      })
      
})
                                       
