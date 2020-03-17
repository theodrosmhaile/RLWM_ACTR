#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(
    fluidPage(

    # Application title
    titlePanel("Parameter Explorer"),
    
    radioButtons(inputId = "modelselect", 
                       label= "Select Model to display", 
                       choices = c("RL only", "LTM only", "RL-LTM integrated"), 
                       selected = "RL-LTM integrated", inline = TRUE
                       
                       ),
    # Sidebar with a slider input for number of bins
    splitLayout( cellWidths = c("30%", "35%", "30%"),
        sidebarPanel( width = 10, fluid =FALSE,
            sliderInput("al",
                        "Learning Rate (Alpha):",
                        min = 0.05,
                        max = 0.25,
                        value = 0.05, 
                        step = 0.05, 
                        animate=TRUE),
     
            
            sliderInput("e",
                        "RL noise (egs):",
                        min = 0.1,
                        max = 0.5,
                        value = 0.1, 
                        step = 0.1, 
                        animate = TRUE),
        
       
            sliderInput("i",
                        "Attention/WM (imaginal-activation):",
                        min = 1,
                        max = 5,
                        value = 1, 
                        step = 1, 
                        animate = TRUE),
     
            sliderInput("an",
                        "LTM Retrieval noise (ans):",
                        min = 0.1,
                        max = 0.5,
                        value = 0.1, 
                        step = 0.1, 
                        animate = TRUE),
        
            sliderInput("b",
                        "LTM decay rate (bll):",
                        min = 0.3,
                        max = 0.7,
                        value = 0.3, 
                        step = 0.1, 
                        animate = TRUE)
       ),
       
        # Show a plot of the generated distribution
       # mainPanel(
        plotOutput("curvPlot", width = "100%", height = "500px"), 
        plotOutput("barPlot", width = "70%", height = "500px")
            
            
        ),
    
    p(h2("Some information will be displayed here"))
    )

)#)
