# 2017-01-09 in response to Google Groups thread by mattek
# Response from Stephen McDaniel at PowerTrip Analytics
#
#   Topic: Shiny, using inputs in if else logic checks and triggering reactives
#
# Program: app.R 
#    Data: randomly generated 
#
# This should work without modification
# However, if you comment out the cat() line in the dataInBoth reactive
# You will see that input action button inDataGen2 is ignored once
#    input inDataGen1 is used at least once
# The morale of this example app is to use direct retrieval of inputs 
#    to guarantee they are available for if else logic checks
#
# License: MIT License
# Attribution, package authors for shiny on CRAN.

library(shiny)

ui <- shinyUI(fluidPage(
  titlePanel("2 Buttons, 1 Plot, Nuances of if else logic and using inputs"),
  absolutePanel(
    bottom = 10,
    left = 10,
    HTML('<a href="http://www.powertripanalytics.com/" target="_new"><span style="color:#CC0000">Power</span><span style="color:#004de6">Trip</span> 
    <span style="color:#009933">Analytics</span></a>	 
    </span></span>') # your organization name/logo here
  ),
  sidebarLayout(
    sidebarPanel(
      actionButton('inDataGen1', 'Generate dataset 1'),
      actionButton('inDataGen2', 'Generate dataset 2')
      ),
    mainPanel(plotOutput("plotHist", width = "100%"))
  )
))

server <- shinyServer(function(input, output, session) {

  # this is only set at session start
  # we use this as a way to determine which input was 
  # clicked in the dataInBoth reactive
  counter <- reactiveValues(
    one = isolate(input$inDataGen1), 
    two = isolate(input$inDataGen2)
  )

  # generate random dataset
  dataIn1 <- eventReactive(input$inDataGen1, {
    cat("dataIn1\n")
    rnorm(1000)
  })
  
  dataIn2 <- eventReactive(input$inDataGen2, {
    cat("dataIn2\n")
    rpois(1000, 2)
  })
  
  dataInBoth <- reactive({
    # If you comment out the cat() line, you will see that inDataGen2
    #    does not trigger running this reactive once inDataGen1 is used
    # This is one of the more nuanced areas of reactive programming in shiny
    #    due to the if else logic, it isn't fetched once inDataGen1 is available
    # The morale is use direct retrieval of inputs to guarantee they are available 
    #    for if else logic checks
    cat("dataInBoth\n1: ", input$inDataGen1, "\n2: ", input$inDataGen2, "\n")
    
    # isolate the checks of counter reactiveValues
    # as we set the values in this same reactive
    if (input$inDataGen1 != isolate(counter$one)) {
      cat("dataInBoth if inDataGen1\n")
      dm = dataIn1()
      # no need to isolate updating the counter reactive values!
      counter$one <- input$inDataGen1
    } else if (input$inDataGen2 != isolate(counter$two)) {
      cat("dataInBoth if inDataGen2\n")
      dm = dataIn2()
      # no need to isolate updating the counter reactive values!
      counter$two <- input$inDataGen2
    } else dm = NULL
    
    return(dm)
    
  })
    
  output$plotHist <- renderPlot({
    cat("plotHist\n")
    dm = dataInBoth()
    cat("plotHist on to plot\n\n")
    if (is.null(dm))
      return(NULL)
    else
      return(plot(hist(dm)))
    
  })
})

shinyApp(ui = ui, server = server)
