#library(shiny)
#library(rsconnect)
shinyServer(function(input, output, session) {
  
  resultList <- reactive({
    as.character(scoreNgrams(input$userInput)$nextword)[1:10]
    })
  
  output$guess <- renderTable({
    outputTable <- data.frame(resultList())
    outputTable$Order = (1:10)
    outputTable <- outputTable[c(2,1)]
    colnames(outputTable) <- c("Order", "Prediction")
    outputTable
  }, 
  caption=paste("Model: Ngram + Stupid Backoff"),
  width = '400px',
  spacing = 'l',
  hover = TRUE,
  align = "c",
  striped = TRUE
  )

})