# Predict-Next-Word

This is **Coursera JHU Data Science Specialization** capstone project, to build a Shiny App with Natural Processing Model (NLP) to predict what user next input word fast and accurately. 

The dataset is from SwiftKey, a industry partner with JHU. The original text dataset can be downloaded [here](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip).

## Models I used
* **N-Gram Tokenization**. The usual n-gram consists of a sequence of n words, e.g. "I like to eat" is a Quandgram. This project used up to Pentagram (N=5).
* **Stupid-Backoff**. One of the most used scheme for large language models. For more infomation about this model, click [here](http://www.aclweb.org/anthology/D07-1090.pdf).

## Files/folders description

1. **preprocessing.R**: Loading,sampling text dataset. Data cleaning & profanity filtering. Building N-Grams.
2. **global.R**: Store all the functions and text analysis models to be used in the app.
3. **ui.R/server.R**: Shiny App file.
4. **ngram*.rds**: Cleaned ngrams data from preprocessing.
5. **Milestone2**: A folder with a report on exploratory analysis of original text data. 

## Main page of my Shiny App
![screenshot](screenshot/shinyApp.PNG)

## Links

* Check out my Shiny App [HERE](https://jessicaji.shinyapps.io/wordpredictapp/)
* Link to my milestone report on exploratory analysis about whole dataset [HERE](https://rpubs.com/JessicaJi/wordpredictmilestone).
