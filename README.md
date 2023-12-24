# WordPredictor
Predicting the next word based on input

This repository is for the Data Science Specialization Capstone project.

For this project we are building a predictive model for text. The data for training the model is provided by SwiftKey and is available at:

https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip

The code for the Shiny App is in ui.R and server.R.

The code for reading in the raw data, sampling, cleaning the data and training the model is in capstone.R

Only English data sets for News, Twitter and Blogs are used

For space saving and performance only 10000 entries from each file is sampled and combined

3-gram, 2- gram and unigram models are created. For space and speed higher order n-grams were not uploaded 

Bad words, foreign characters, numbers, urls, separators are removed

quanteda package is used for tokenization of data and n-gram modeling

data.table is used for easy access 
