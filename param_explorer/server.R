#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#    http://shiny.rstudio.com/
#

library(shiny)
library(jsonlite)

simsRL_LTM <- fromJSON('sim_data_all_params_integrated_model_100s_031620.JSON')
simsRL     <- fromJSON('sim_data_all_params_RL_100s_031620.JSON')
simsLTM    <- fromJSON('LTM_simdata_0708.JSON')#('LTM_visual_activation_allparams_evals26.JSON')#'03_mod_LTM_all_brokenTest.JSON')#fromJSON('03_mod_LTM_all.JSON') #fromJSON('sim_data_all_params_LTM_100s_031620.JSON') 

iter.n <- c(1:12)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$curvPlot <- renderPlot({

# Based on chosen model, this selects the right data and set of parameters. 
        if (input$modelselect == "RL only") {
            temp <- simsRL$data
            ind  <- (temp$alpha    == input$al & 
                         temp$bll  == 0 &  
                         temp$ans  == 0 &
                         temp$egs  == input$e & 
                         temp$imag == 0)
            
            
            set3.dat <- unlist(temp$set3_learn[ind])
            set6.dat <- unlist(temp$set6_learn[ind])
            
        }
        
        if (input$modelselect == "LTM only") {
            
            temp <- simsLTM$data
            ind  <- (temp$alpha    == 0 & 
                         temp$bll  == input$b &  
                         temp$ans  == input$an &
                         temp$egs  == 0 & 
                         temp$imag == input$i)
            
            
            set3.dat <- unlist(temp$set3_learn[ind])
            set6.dat <- unlist(temp$set6_learn[ind])
        }
        if (input$modelselect == "RL-LTM integrated") {
            
            temp <- simsRL_LTM$data
            ind  <- (temp$alpha    == input$al & 
                         temp$bll  == input$b &  
                         temp$ans  == input$an &
                         temp$egs  == input$e & 
                         temp$imag == input$i)
            
            
            set3.dat <- unlist(temp$set3_learn[ind])
            set6.dat <- unlist(temp$set6_learn[ind])
            
        }
         
        
        #Force in to data frame for lm function
        
        tempframe.3 <- data.frame("accuracy"   = set3.dat,
                                  "iterations" = iter.n )
        tempframe.6 <- data.frame("accuracy"   = set6.dat,
                                  "iterations" = iter.n )
        
        # compute y.pred to plot fit
        
        temp.lm.3 <- lm(accuracy ~ poly(iterations,2), data = tempframe.3)
        temp.lm.6 <- lm(accuracy ~ poly(iterations,2), data = tempframe.6)    
        
# plot data points
        plot(iter.n, set3.dat, 
             col = '#e41a1c', 
             cex = 2, lwd = 2, 
             pch = 19, xlab ='Stimulus presentations',ylab ='Accuracy', ylim = c(0,1), 
             main = "Learning curves" )
        points(iter.n, 
             set6.dat, 
             col = '#377eb8', 
             cex = 2, lwd = 2, 
             pch = 19, xlab ='Stimulus presentations',ylab ='Accuracy', asp =c(3,4))
        
#draw fitted lines
        
        lines(tempframe.3$iterations,temp.lm.3$fitted.values,lwd=4.3, col = '#e41a1c')
        lines(tempframe.6$iterations,temp.lm.6$fitted.values,lwd=4.3, col = '#377eb8')
        
        legend("bottomright", c("set size 3", "set size 6"),pch = c( 19, 19),
               text.col =c( "#e41a1c","#377eb8"), col = c("#e41a1c","#377eb8"))
        
    })
   output$barPlot <- renderPlot({
       
       if (input$modelselect == "RL only") {
           temp <- simsRL$data
           ind  <- (temp$alpha    == input$al & 
                        temp$bll  == 0 &  
                        temp$ans  == 0 &
                        temp$egs  == input$e & 
                        temp$imag == 0)
           
           
           set3.dat <- unlist(temp$set3_learn[ind])
           set6.dat <- unlist(temp$set6_learn[ind])
           
       }
       
       if (input$modelselect == "LTM only") {
           
           temp <- simsLTM$data
           ind  <- (temp$alpha    == 0 & 
                        temp$bll  == input$b &  
                        temp$ans  == input$an &
                        temp$egs  == 0 & 
                        temp$imag == input$i)
           
           
           set3.dat <- unlist(temp$set3_learn[ind])
           set6.dat <- unlist(temp$set6_learn[ind])
       }
       if (input$modelselect == "RL-LTM integrated") {
           
           temp <- simsRL_LTM$data
           ind  <- (temp$alpha    == input$al & 
                        temp$bll  == input$b &  
                        temp$ans  == input$an &
                        temp$egs  == input$e & 
                        temp$imag == input$i)
           
           
           set3.dat <- unlist(temp$set3_learn[ind])
           set6.dat <- unlist(temp$set6_learn[ind])
           
       }
       
        barplot(c(temp$set3_test[ind], temp$set6_test[ind] ), 
                c(1,1),ylab = 'Accuracy', xlab = 'set size', 
                col = c('#e41a1c', '#377eb8'), ylim = c(0, 1), 
                main = 'Test Accuracy')

        
    })

})
