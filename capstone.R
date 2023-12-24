
#'
#' Next Word Predictor
#'  
#' Data Science Capstone Project
#' 
#' @author Deniz
#' 
#' @details Reads in the training data set and builds an n-gram back off prediction model
#'  
#' @import shiny
#' @import data.table
#' @import stringr
#' @import quanteda
#' @import quanteda.textmodels
#' 
library(stringr)
library(quanteda)
library(quanteda.textmodels)
library(data.table)


con <- file("final/en_US/en_US.news.txt", "r") 
newstext <- readLines(con, encoding="utf-8")
close(con)
nlen <- length(newstext)
nwords <- sum(str_count(newstext, '\\w+'))

tcon <- file("final/en_US/en_US.twitter.txt", "r")
twittext <- readLines(tcon, encoding="utf-8")
close (tcon)
tlen <- length(twittext)
twords <- sum(str_count(twittext, '\\w+'))

bcon <- file("final/en_US/en_US.blogs.txt", "r")
blogtext <- readLines(bcon, encoding="utf-8")
close(bcon)
blen <- length(blogtext)
bwords <-  sum(str_count(blogtext, '\\w+'))

set.seed(12345)
samplesize = 10000

newssample <- sample(newstext, samplesize, replace = FALSE)
blogsample <- sample(blogtext, samplesize, replace = FALSE)
twitsample <- sample(twittext, samplesize, replace = FALSE)

corpora <- corpus(c(newssample, blogsample, twitsample))

# file for bad words
badcon <- file("en.txt")
badwords <- readLines(badcon, encoding="utf-8")
close(badcon)

tok <- tokens(corpora, remove_punct = TRUE, remove_symbols = TRUE,
              remove_numbers = TRUE, remove_url = TRUE, 
              remove_separators = TRUE)
tok <- tokens_remove(tok, pattern = "^[#@].+$", valuetype = "regex")
tok <- tokens_remove(tok, badwords)
tok <- tokens_keep(tok, pattern = "^[a-zA-Z]+$", valuetype = "regex")

# Just to see the top features 
sampledfm <- dfm(tok, tolower = TRUE, remove_padding = TRUE)

topfeatures(sampledfm)

tokunigram <- tokens_ngrams(tok, n = 1, concatenator = " ")

dfmunigram <- dfm(tokunigram)

tokbigram <- tokens_ngrams(tok, n = 2, concatenator = " ")

dfmbigram <- dfm(tokbigram)
topbi <- topfeatures(dfmbigram, 100)


toktrigram <- tokens_ngrams(tok, n = 3, concatenator = " ")
dfmtrigram <- dfm(toktrigram)


unisum <- colSums(dfmunigram)

unitable <- data.table(word1 = names(unisum), freq = unisum)

unimini <- unitable[order(-freq)][1:100]

bisum <- colSums(dfmbigram)

bitable <- data.table(
      word1 = sapply(strsplit(names(bisum), " "), '[[', 1),
      word2 = sapply(strsplit(names(bisum), " "), '[[', 2),
      freq = bisum)

trisum <- colSums(dfmtrigram)
tritable <- data.table(
      word1 = sapply(strsplit(names(trisum), " "), '[[', 1),
      word2 = sapply(strsplit(names(trisum), " "), '[[', 2),
      word3 = sapply(strsplit(names(trisum), " "), '[[', 3),
      freq = trisum)   

setkey(unitable, word1)
setkey(bitable, word1, word2)
setkey(tritable, word1, word2, word3)

# saving the data tables to files to upload to Shiny 
saveRDS(tritable, file = "trigram.RDS")
saveRDS(bitable, file = "bigram.RDS")
saveRDS(unimini, file = "unigram.RDS")

# function to look for 2 words in trigram
findintrigram <- function(w1, w2) {
      ngwords <- tritable[.(w1, w2)][order(-freq)][1]
      if(any(is.na(ngwords)))
            findinbigram(w2)
      else 
            print(ngwords[, word3])
}

# function to look for a word in bigram
findinbigram <- function(w) {
      ngwords <- bitable[w][order(-freq)][1]
      if(any(is.na(ngwords)))
            retunigram()
      else
            print(ngwords[, word2])
}

retunigram <- function() {
      return(sample(unimini[,word1], 1))
}

# function for testing the model from the command line
getInput <- function(str){
      str = char_tolower(str)
      inwords <- strsplit(str, " ")
      l <- length(inwords[[1]])
      if (l > 2) {
            findintrigram(inwords[[1]][l-1], inwords[[1]][l])
      }
      else if (l == 2)
            findintrigram(inwords[[1]][1], inwords[[1]][2])
      else if (l == 1) {
            findinbigram(inwords[[1]][1])
      }
      else
            retunigram()
}
