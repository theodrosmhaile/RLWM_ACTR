# This Function reduces the lists of simulations to long-form data-frames.
# Two inputs are required the JSON data and a name for the file to save to duing output

get_data = function(data, data_name){
  bind_rows(
    c('set3_learn','set6_learn') %>% 
      map(~
            #column is measurement at T, record is simulation
            data %>% 
            .[[.x]] %>% 
            reduce(rbind) %>% 
            data.frame() %>% 
            mutate(condition = .x, 
                   model_index= c(1:nrow(data))
            )
      ) %>% 
      reduce(bind_rows) %>% 
      pivot_longer(cols = starts_with('x')
                   ,values_to = 'accuracy', names_to = 'iteration'),
    
    c('set3_test', 'set6_test','alpha','egs', 'bll', 'imag','ans') %>%
      map (~
             {
               temp = data %>% 
                 .[[.x]]
               
               data.frame(
                 model_index= c(1:nrow(data)),
                 condition=.x, 
                 iteration=paste0('X', rep(c(1:12), nrow(data))), 
                 accuracy=rep(temp, 12)
               )
               
             }
      )
    
  ) %>%  
    mutate(data_source = data_name) #%>% 
  #  pivot_wider( values_from = accuracy, names_from = condition) %>% 
   # pivot_longer(cols = c('alpha', 'egs', 'bll','imag','ans'), names_to = 'parameter', values_to = 'param_vals') %>% 
    #pivot_longer(cols=contains('set'), names_to = 'condition', values_to = 'accuracy' )
}