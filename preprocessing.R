#This file is preprocessing of data, including sampling, cleaning and tokenization.

#Load data and sample 1 percent of whole dataset (blogs, news, twitter).
setwd("~/online courses/JHU-DataScience/10 Capstone Project")
blogs <- readLines("final/en_US/en_US.blogs.txt", encoding = "UTF-8", skipNul = TRUE)
news <- readLines("final/en_US/en_US.news.txt", encoding = "UTF-8", skipNul = TRUE)
twitter <- readLines("final/en_US/en_US.twitter.txt", encoding = "UTF-8", skipNul = TRUE)

set.seed(66)
blogs1p <- blogs[sample(1:length(blogs),0.01*length(blogs))]
news1p <- news[sample(1:length(news),0.01*length(news))]
twitter1p <- twitter[sample(1:length(twitter),0.01*length(twitter))]
sample1p <- c(blogs1p,news1p,twitter1p)
#length(sample1p) # 42695 lines

#sample cleaning

library(tm)
library(quanteda)

profanitySource <- VectorSource(readLines("profanity.txt"))

mysample = VCorpus(VectorSource(sample1p))
mysample = tm_map(mysample, PlainTextDocument) 
mysample = tm_map(mysample, content_transformer(tolower))
mysample = tm_map(mysample, removeNumbers)
#mysample = tm_map(mysample, removeWords, stopwords("english")) 
mysample = tm_map(mysample, removePunctuation)
mysample = tm_map(mysample, removeWords, profanitySource) 
mysample = tm_map(mysample, stripWhitespace)

#N-Grams
mydfm<-data.frame(text=unlist(sapply(mysample, `[`, "content")), stringsAsFactors=F) #turn mysample to dataframe
sample_ch = mydfm[,1] 

unigrams = dfm(sample_ch, ngrams = 1, verbose = FALSE)
uni.freq <- colSums(unigrams)
uni.freq <- sort(uni.freq, decreasing=TRUE) 
nf.1 <- data.frame(word=names(uni.freq), freq1=uni.freq)
ngram1 <- data.frame(as.character(nf.1$word))
names(ngram1) <- c("w1")
ngram1$freq <- nf.1$freq1

bigrams = dfm(sample_ch, ngrams = 2, verbose = FALSE)
bi.freq <- colSums(bigrams)
bi.freq <- sort(bi.freq, decreasing=TRUE) 
nf.2 <- data.frame(word=names(bi.freq), freq2=bi.freq)
#split the word column
ngram2 <- data.frame(do.call('rbind', strsplit(as.character(nf.2$word),'_',fixed=TRUE)))
names(ngram2) <- c("w1","w2")
ngram2$freq <- nf.2$freq2

trigrams = dfm(sample_ch, ngrams = 3, verbose = FALSE)
tri.freq <- colSums(trigrams)
tri.freq <- sort(tri.freq, decreasing=TRUE) 
nf.3 <- data.frame(word=names(tri.freq), freq3=tri.freq)
#split the word column
ngram3 <- data.frame(do.call('rbind', strsplit(as.character(nf.3$word),'_',fixed=TRUE)))
names(ngram3) <- c("w1","w2","w3")
ngram3$freq <- nf.3$freq3

quadgrams = dfm(sample_ch, ngrams = 4, verbose = FALSE)
quad.freq <- colSums(quadgrams)
quad.freq <- sort(quad.freq, decreasing=TRUE) 
nf.4 <- data.frame(word=names(quad.freq), freq4=quad.freq)
#split the word column
ngram4 <- data.frame(do.call('rbind', strsplit(as.character(nf.4$word),'_',fixed=TRUE)))
names(ngram4) <- c("w1","w2","w3","w4")
ngram4$freq <- nf.4$freq4

pentagrams = dfm(sample_ch, ngrams = 5, verbose = FALSE)
penta.freq <- colSums(pentagrams)
penta.freq <- sort(penta.freq, decreasing=TRUE) 
nf.5 <- data.frame(word=names(penta.freq), freq5=penta.freq)
#split the word column
ngram5 <- data.frame(do.call('rbind', strsplit(as.character(nf.5$word),'_',fixed=TRUE)))
names(ngram5) <- c("w1","w2","w3","w4","w5")
ngram5$freq <- nf.5$freq5

#save ngrams as Rdata files for further use.
saveRDS(ngram5, "WordPredictApp2/ngram5.rds")
saveRDS(ngram4, "WordPredictApp2/ngram4.rds")
saveRDS(ngram3, "WordPredictApp2/ngram3.rds")
saveRDS(ngram2, "WordPredictApp2/ngram2.rds")
saveRDS(ngram1, "WordPredictApp2/ngram1.rds")

#save nf. as Rdata files for exploratory analysis in the App
# saveRDS(nf.4, "WordPredictApp2/nf4.rds")
# saveRDS(nf.3, "WordPredictApp2/nf3.rds")
# saveRDS(nf.2, "WordPredictApp2/nf2.rds")
# saveRDS(nf.1, "WordPredictApp2/nf1.rds")
