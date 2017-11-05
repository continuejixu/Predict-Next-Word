#This is R file contains functions required by WordPredictApp.
#setwd("~/online courses/JHU-DataScience/10 Capstone Project/WordPredictApp")

if ("shiny" %in% rownames(installed.packages()) == FALSE){
  install.packages('shiny')
}
if ("ggplot2" %in% rownames(installed.packages()) == FALSE){
  install.packages('ggplot2')
}
if ("BH" %in% rownames(installed.packages()) == FALSE){
  install.packages('BH')
}
if ("NLP" %in% rownames(installed.packages()) == FALSE){
  install.packages('NLP')
}
library(shiny)
library(ggplot2)
library(BH)
library(NLP)


#Load the ngram dataframe
ngram5 <- readRDS("ngram5.rds")
ngram4 <- readRDS("ngram4.rds")
ngram3 <- readRDS("ngram3.rds")
ngram2 <- readRDS("ngram2.rds")
ngram1 <- readRDS("ngram1.rds")

#clean the user input data
cleanInput <- function(x) {
  x <- tolower(x)                      # convert to lowercase
  x <- gsub("\\S*[0-9]+\\S*", " ", x)  # remove numbers
  x <- gsub("^[(]|[)]$", " ", x)       # remove any end brackets
  x <- gsub("[(].*?[)]", " ", x)       # remove any middle brackets
  x <- gsub("[[:punct:]]", "", x)      # remove punctuations
  x <- gsub("\\s+"," ",x)              # compress and trim whitespace
  x <- gsub("^\\s+|\\s+$", "", x)
  return(x)
}

# getLastWords function used for get the last words of a sentence.
# Ex. getLastWords( "thank you for looking through my code", 3 ) ==> "through my code"
getLastWords <- function(x, n) {
  x <- cleanInput(x)
  words <- unlist(strsplit(x, " "))
  len <- length(words)
  if (n < 1) {
    stop("No Text Entered")
  }
  if (n > len) {
    n <- len
  }
  if (n==1) {
    return(words[len])
  } else {
    text <- words[(len-n+1):len]
    return(text)
  }
}

# Functions to check. The return of column will be like this: [nextword] [ngrams.scores]. 
check5gram <- function(x, ngram5, getNrows) {
  words <- getLastWords(x, 4)
  match <- subset(ngram5, w1 == words[1] & w2 == words[2] & w3 == words[3] & w4 == words[4])
  match <- subset(match, select=c(w5, freq))
  match <- match[order(-match$freq), ]
  sumfreq <- sum(match$freq)
  match$freq <- round(match$freq / sumfreq * 100)
  colnames(match) <- c("nextword","ngram5.scores")
  if (nrow(match) < getNrows) {
    getNrows <- nrow(match)
  }
  match[1:getNrows, ]
}

check4gram <- function(x, ngram4, getNrows) {
  words <- getLastWords(x, 3)
  match <- subset(ngram4, w1 == words[1] & w2 == words[2] & w3 == words[3])
  match <- subset(match, select=c(w4, freq))
  match <- match[order(-match$freq), ] #in frequency decreasing order
  sumfreq <- sum(match$freq)
  match$freq <- round(match$freq / sumfreq * 100)
  colnames(match) <- c("nextword","ngram4.scores")
  if (nrow(match) < getNrows) {
    getNrows <- nrow(match)
  }
  match[1:getNrows, ]
}

check3gram <- function(x, ngram3, getNrows) {
  words <- getLastWords(x, 2)
  #paste(words)
  match <- subset(ngram3, w1 == words[1] & w2 == words[2])
  match <- subset(match, select=c(w3, freq))
  match <- match[order(-match$freq), ]
  sumfreq <- sum(match$freq)
  match$freq <- round(match$freq / sumfreq * 100) 
  colnames(match) <- c("nextword","ngram3.scores")
  if (nrow(match) < getNrows) {
    getNrows <- nrow(match)
  }
  match[1:getNrows, ]
}

check2gram <- function(x, ngram2, getNrows) { 
  words <- getLastWords(x, 1)
  match <- subset(ngram2, w1 == words[1])
  match <- subset(match, select=c(w2, freq))
  match <- match[order(-match$freq), ]
  sumfreq <- sum(match$freq)
  match$freq <- round(match$freq / sumfreq * 100)
  colnames(match) <- c("nextword","ngram2.scores")
  if (nrow(match) < getNrows) {
    getNrows <- nrow(match)
  }
  match[1:getNrows, ]
}
#nrows = 30
scoreNgrams <- function(x, nrows=30) {
  ngram5.match <- check5gram(x, ngram5, nrows)
  ngram4.match <- check4gram(x, ngram4, nrows)
  ngram3.match <- check3gram(x, ngram3, nrows)
  ngram2.match <- check2gram(x, ngram2, nrows)

  merge5n4 <- merge(ngram5.match, ngram4.match, by="nextword", all=TRUE)  # merge ngram data frame, by outer join 
  merge4n3 <- merge(merge5n4, ngram3.match, by="nextword", all=TRUE) 
  merge3n2 <- merge(merge4n3, ngram2.match, by="nextword", all=TRUE)
  df <- subset(merge3n2, !is.na(nextword))  # remove any zero-match results
  
  if (nrow(df) > 0) {
    df[is.na(df)] <- 0  # replace all the NAs with 0
    df <- df[order(-df$ngram5.scores, -df$ngram4.scores, -df$ngram3.scores, -df$ngram2.scores), ]

    # Calculate Stupid Back Off score and Rank result.
    alpha <- 0.4
    df$score <- round(
      ifelse(df$ngram5.scores > 0, df$ngram5.scores,
             ifelse(df$ngram4.scores > 0, df$ngram4.scores,
                    ifelse(df$ngram3.scores > 0, alpha*df$ngram3.scores,
                           ifelse(df$ngram2.scores > 0, alpha*alpha*df$ngram2.scores,0)))),1)
    df <- df[order(-df$score), ]
    # If result is less than 10, append highest frequenct single word to it.
    if (nrow(df)<10) {
      rest <- 10-nrow(df)
      df <- merge(df, ngram1[1:rest,], by.x=c("nextword","score"), by.y=c("w1","freq"), all=TRUE, sort = FALSE)
    }
  } else {
    df <- ngram1[1:10,]
    colnames(df) <- c("nextword", "score")
  }
  return(df)
}




