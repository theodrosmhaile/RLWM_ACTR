#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#    http://shiny.rstudio.com/
#

library(shiny)
library(jsonlite)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        dat <- jsonlite::fromJSON('../sim_data_first_half_param_space_030620_integr_model100sTEST.JSON')
       
         #bins <- seq(min(x), max(x), length.out = input$bins + 1)
       al <- seq(0.05, 0.25, .05)
    ##    b  <- seq(0.3, 0.7, 0.1)
      #  an <- seq(0.1, 0.5, 0.1)
        
        
        # draw the histogram with the specified number of bins
        #hist(x, breaks = bins, col = 'darkgray', border = 'white')
        plot(c(1:12),
             dat$set3_learn[
                 dat$alpha==input$al & dat$bll==input$b & dat$ans==input$an & dat$input$egs==e & dat$imag == input$i
                 ]$`0`, 
             col = '#e41a1c',
             cex=1,lwd=2,pch=19, xlab ='Stimulus presentations',
             ylab ='Accuracy'
             )
        points(c(1:12),
             dat$set6_learn[
                 dat$alpha==input$al & dat$bll==input$b & dat$ans==input$an & dat$egs==e & dat$imag == input$i
                 ]$`0`, 
             cex=1,lwd=2,pch=19, 
        )
        
    })

})
