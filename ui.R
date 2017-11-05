#library(shiny)
#library(rsconnect)
shinyUI(fluidPage(
  
  titlePanel("Predict Next Word"),
  tabsetPanel(type='tab',
              tabPanel("App Main Page",
                       sidebarLayout(
                         
                         sidebarPanel(
                           textInput('userInput',label="Input your phrase here:",value="I want to..."),
                           #actionButton('goButton',"Guess!"),
                           br(),
                           helpText("Note:",br(),
                                    "The following predicted word will show up automatically as you input.")),

                         mainPanel(
                           h4("Voila! Here are the top 10 predictions:"),
                           tableOutput('guess')
                           )
                       )
              ),
              
              tabPanel("Exploratory Analysis",
                       h3("Dataset Summary"),
                       img(src='fileSummary.png', width='800px', height='140px'),
                       h3("Wordcloud on sample"),
                       img(src='wordcloud.png', width='700px', height='500px'),
                       h3("Highest Frequency Uni-Gram"),
                       img(src='topUnigram.png', width='700px', height='500px'),
                       h3("Highest Frequency Bi-Gram"),
                       img(src='topBigram.png', width='700px', height='500px'),
                       h3("Highest Frequency Tri-Gram"),
                       img(src='topTrigram.png', width='700px', height='500px'),
                       h3("Highest Frequency Quad-Gram"),
                       img(src='topQuadgram.png', width='700px', height='500px'),
                       #h5("Header 5")
                       h5("For more information of exploratory analysis of dateset, please refer to my milestone document."),
                       a(p("LINK"), href="http://rpubs.com/JessicaJi/wordpredictmilestone")
              )
  ),
  hr(),
  h4("Made by Jessica Xu Ji :-)",
     a(p("Click here to jump to the Github Repo."), href="http://github.com/continuejixu/Shiny-App-Predict-Next-Word")
     )
))