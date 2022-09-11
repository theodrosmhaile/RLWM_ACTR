best.fits <- tibble('half1_N3' = half1.N3$model[half1.N3 %>% select(-contains('model')) %>% 
                                                      apply(., 2, which.min)],
                    'half1_N6' = half1.N6$model[half1.N6 %>% select(-contains('model')) %>% 
                                                      apply(., 2, which.min)],
                    'half2_N3' = half2.N3$model[half2.N3 %>% select(-contains('model')) %>% 
                                                      apply(., 2, which.min)],
                    'half2_N6' = half2.N6$model[half2.N6 %>% select(-contains('model')) %>% 
                                                      apply(., 2, which.min)]) %>% 
  data.frame() %>% 
  mutate(type = "index", 
         person = h1.subjects) %>%  
  pivot_longer(cols = starts_with("half"), 
               values_to = "model")


best.fit.idx <- tibble('half1_N3' = half1.N3$model.id[half1.N3 %>% select(-contains('model')) %>% apply(., 2, which.min)],
                       'half1_N6'=  half1.N6$model.id[half1.N6 %>% select(-contains('model')) %>% apply(., 2, which.min)], 
                       'half2_N3'= half2.N3$model.id[half2.N3 %>% select(-contains('model')) %>% apply(., 2, which.min)], 
                       'half2_N6'= half2.N6$model.id[half2.N6 %>% select(-contains('model')) %>% apply(., 2, which.min)]
) %>%  
  data.frame() %>%
  mutate(type = "index", 
         person = h1.subjects) %>%  
  pivot_longer(cols = starts_with("half"), 
               values_to = "index")


index_search = merge(
  best.fits
  ,best.fit.idx
  ,by = c('person', 'name')
) %>%  
  select(!contains("type"))

#bug fix========================================================================
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`
# 
# half1.N3 %>%  
#   colnames()
# 
# half1.N3 %>%  
#   select(starts_with("v")) %>%  
#   map(sum)
# 
# 
# half1.N3 = RL.BIC.half1.N3 %>% 
#   as_tibble() %>% 
#   mutate(model='RL', model.id=c(1:nrow(RL.sim)))

# yolo$model.id[yolo %>% select(starts_with("v"))  %>% apply(., 2, which.min)]



#teddy's function===============================================================
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~





data = RL.sim
x = "set3_learn"
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
                   model= c(1:nrow(data))
            )
      ) %>% 
      reduce(bind_rows) %>% 
      pivot_longer(cols = starts_with('x')
                   ,values_to = 'accuracy', names_to = 'iteration'),
    c('set3_test', 'set6_test') %>%
      map (~
             {
               temp = data %>% 
                 .[[.x]]
               
               data.frame(
                 condition=.x, 
                 iteration=paste0('x', rep(c(1:12), nrow(data))), 
                 accuracy=rep(temp, 12)
               )
               
             }
      )
  ) %>%  
    mutate(data_source = data_name)
}
RL.sim %>%  
  get_data(data = .)

yolo = 3
deparse(substitute(yolo))

c(RL.sim
  #, LTM.sim, STR.sim, META.sim
  ) %>%  
  map(get_data)


data_object =list(list(RL.sim, LTM.sim, STR.sim, META.sim),
     list("RL", "LTM", "STR", "META")) %>%  
  pmap(get_data) %>%  
  reduce(bind_rows) 

data_object = data_object %>%  
  mutate(iteration = str_remove_all(iteration, "[:alpha:]") %>%  
           as.numeric())



index_search %>% sample_n(5) %>% 
  merge(data_object
        ,by.x = c("model", "index")
        ,by.y = c("data_source", "model")
        ,all.x = T)




























get_data(RL.sim)mod.idx <-  cbind('subject'=h1.subjects, best.fits, best.fit.idx) 

c('half1_N3.mod', 'half1_N6.mod', 'half1_N3.idx') %>% 
  map(~ mod.idx %>% 
        .[[.x]] %>% 
        filter(.[.x]=='LTM')  
      
      
  )


h %>% 
  slice(pmatch(model, 
               (mod.idx %>% 
                  filter(half1_N3.mod == 'LTM') %>%  
                  select (subject, half1_N3.idx) %$% 
                  # bind_rows(.['subject'], 
                  .['half1_N3.idx'] %>% reduce(unlist) %>% as.numeric()),
               duplicates.ok = T))
#LTM.sim[.['half1_N3.idx'] %>% reduce(unlist) %>% as.numeric(),]   
#   )

#subjects model model_id half type setsize iteration accuracy parameter parameter value 




p.behav.model <- inner_join(
  rbind(
    sdat.h1 %>% mutate('subject'= h1.subjects, 'half'='half1') %>% 
      pivot_longer(cols = c(-half, -subject), names_to = 'iteration', values_to = 'accuracy')
    
    
    
    
    
    ,
    sdat.h2 %>% mutate('subject'= h1.subjects, 'half'='half2') %>% 
      pivot_longer(cols = c(-half, -subject), names_to = 'iteration', values_to = 'accuracy')
  ) %>% head()
  
  
  
  
  , 
)










