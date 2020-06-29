

param.influence <- function(this.data, model) {
  bll_param   = c(0.4, 0.5, 0.6)
  alpha_param = c(0.1, 0.15, 0.2)
  egs_param   = c(0.2, 0.3, 0.4)
  imag_param  = c(1, 2, 3)
  ans_param   = c(0.2, 0.3, 0.4)
 # model='RLLTM'
this.data = LTM.sim.dat
  
  if (model=='RL') {
   reurn.data = data.table('set3_learn' = this.data[(alpha %in% alpha_param), 11:12] %>% 
                             rowMeans() %>% 
                             as.matrix() %>% 
                             reshape(., 3,3) %>% 
                             colMeans(),
               'set3_test' = this.data[(alpha %in% alpha_param), 25] %>% 
                                      as.matrix() %>% 
                                       reshape(., 3,3) %>% 
                                       colMeans(),
               'set6_learn' = this.data[(alpha %in% alpha_param), 23:24] %>% 
                                           rowMeans() %>% 
                                           as.matrix() %>% 
                                          reshape(., 3,3) %>% 
                                             colMeans(),
                'set6_test' = this.data[(alpha %in% alpha_param), 37] %>% 
                                as.matrix() %>% 
                                reshape(., 3,3) %>% 
                                colMeans(),
               'parameter' = c(rep('alpha',3), rep('egs',3)), 
                'level'= c(rep(1:3,3), rep(1:3,3))
    )  
  }
  
  
  
  if (model=='LTM') {
    
    reurn.data =data.frame( 'set3'=rbind(
                                 this.data[(bll == bll_param[1]), 1:12] %>% 
                                     colMeans(), 
                                 this.data[(bll == bll_param[2]), 1:12] %>% 
                                  colMeans(),
                                 this.data[(bll == bll_param[3]), 1:12] %>% 
                                    colMeans(),
                                 this.data[(imag == imag_param[1]), 1:12] %>% 
                                    colMeans(), 
                                 this.data[(imag == imag_param[2]), 1:12] %>% 
                                    colMeans(),
                                 this.data[(imag == imag_param[3]), 1:12] %>% 
                                    colMeans(),
                                 this.data[(ans == ans_param[1]), 1:12] %>% 
                                    colMeans(), 
                                 this.data[(ans == ans_param[2]), 1:12] %>% 
                                    colMeans(),
                                 this.data[(ans == ans_param[3]), 1:12] %>% 
                                    colMeans()
    ),
    
    
    'set6' =rbind(
                     this.data[(bll == bll_param[1]), 13:24] %>% 
                        colMeans(), 
                     this.data[(bll == bll_param[2]), 13:24] %>% 
                        colMeans(),
                     this.data[(bll == bll_param[3]), 13:24] %>% 
                        colMeans(),
                     this.data[(imag == imag_param[1]), 13:24] %>% 
                        colMeans(), 
                     this.data[(imag == imag_param[2]), 13:24] %>% 
                        colMeans(),
                     this.data[(imag == imag_param[3]), 13:24] %>% 
                        colMeans(),
                     this.data[(ans == ans_param[1]), 13:24] %>% 
                        colMeans(), 
                     this.data[(ans == ans_param[2]), 13:24] %>% 
                        colMeans(),
                     this.data[(ans == ans_param[3]), 13:24] %>% 
                        colMeans()
    ),
    
    
   # 'parameter'= c( rep('bll',3), rep('imaginal-activation',3), rep('ans',3)),
     'level'=rep(1:3,3)
    ) 
    
  
    
      
  }
  
  
  
  if (model=='RLLTM') {
    
  
    reurn.data = data.frame('set3_learn' =  c(this.data[(alpha == alpha_param[1]), 11:12] %>% 
                                 rowMeans() %>% mean(), 
                               this.data[(alpha == alpha_param[2]), 11:12] %>% 
                                 rowMeans() %>% mean(),
                               this.data[(alpha == alpha_param[3]), 11:12] %>% 
                                 rowMeans() %>% mean(),
                               this.data[(egs == egs_param[1]), 11:12] %>% 
                                 rowMeans() %>% mean(), 
                               this.data[(egs == egs_param[2]), 11:12] %>% 
                                 rowMeans() %>% mean(),
                               this.data[(egs == egs_param[3]), 11:12] %>% 
                                 rowMeans() %>% mean(),
                               this.data[(bll == bll_param[1]), 11:12] %>% 
                                 rowMeans() %>% mean(), 
                               this.data[(bll == bll_param[2]), 11:12] %>% 
                                 rowMeans() %>% mean(),
                               this.data[(bll == bll_param[3]), 11:12] %>% 
                                 rowMeans() %>% mean(),
                               this.data[(imag == imag_param[1]), 11:12] %>% 
                                 rowMeans() %>% mean(), 
                               this.data[(imag == imag_param[2]), 11:12] %>% 
                                 rowMeans() %>% mean(),
                               this.data[(imag == imag_param[3]), 11:12] %>% 
                                 rowMeans() %>% mean(),
                               this.data[(ans == ans_param[1]), 11:12] %>% 
                                 rowMeans() %>% mean(), 
                               this.data[(ans == ans_param[2]), 11:12] %>% 
                                 rowMeans() %>% mean(),
                               this.data[(ans == ans_param[3]), 11:12] %>% 
                                 rowMeans() %>% mean()
                               ),
             'set3_test' = c(this.data[(alpha == alpha_param[1]), 25] %>% 
                               rowMeans() %>% mean(), 
                             this.data[(alpha == alpha_param[2]), 25] %>% 
                               rowMeans() %>% mean(),
                             this.data[(alpha == alpha_param[3]), 25] %>% 
                               rowMeans() %>% mean(),
                             this.data[(egs == egs_param[1]), 25] %>% 
                               rowMeans() %>% mean(), 
                             this.data[(egs == egs_param[2]), 25] %>% 
                               rowMeans() %>% mean(),
                             this.data[(egs == egs_param[3]), 25] %>% 
                               rowMeans() %>% mean(),
                             this.data[(bll == bll_param[1]), 25] %>% 
                               rowMeans() %>% mean(),
                             this.data[(bll == bll_param[2]), 25] %>% 
                               rowMeans() %>% mean(),
                             this.data[(bll == bll_param[3]), 25] %>% 
                               rowMeans() %>% mean(),
                             this.data[(imag == imag_param[1]), 25] %>% 
                               rowMeans() %>% mean(), 
                             this.data[(imag == imag_param[2]), 25] %>% 
                               rowMeans() %>% mean(),
                             this.data[(imag == imag_param[3]), 25] %>% 
                               rowMeans() %>% mean(),
                             this.data[(ans == ans_param[1]), 25] %>% 
                               rowMeans() %>% mean(), 
                             this.data[(ans == ans_param[2]), 25] %>% 
                               rowMeans() %>% mean(),
                             this.data[(ans == ans_param[3]), 25] %>% 
                               rowMeans() %>% mean()
             ),
             
             'set6_learn' = c(this.data[(alpha == alpha_param[1]), 23:24] %>% 
                                rowMeans() %>% mean(), 
                              this.data[(alpha == alpha_param[2]), 23:24] %>% 
                                rowMeans() %>% mean(),
                              this.data[(alpha == alpha_param[3]), 23:24] %>% 
                                rowMeans() %>% mean(),
                              this.data[(egs == egs_param[1]), 23:24] %>% 
                                rowMeans() %>% mean(), 
                              this.data[(egs == egs_param[2]), 23:24] %>% 
                                rowMeans() %>% mean(),
                              this.data[(egs == egs_param[3]), 23:24] %>% 
                                rowMeans() %>% mean(),
                              this.data[(bll == bll_param[1]), 23:24] %>% 
                                rowMeans() %>% mean(), 
                              this.data[(bll == bll_param[2]), 23:24] %>% 
                                rowMeans() %>% mean(),
                              this.data[(bll == bll_param[3]), 23:24] %>% 
                                rowMeans() %>% mean(),
                              this.data[(imag == imag_param[1]), 23:24] %>% 
                                rowMeans() %>% mean(), 
                              this.data[(imag == imag_param[2]), 23:24] %>% 
                                rowMeans() %>% mean(),
                              this.data[(imag == imag_param[3]), 23:24] %>% 
                                rowMeans() %>% mean(),
                              this.data[(ans == ans_param[1]), 23:24] %>% 
                                rowMeans() %>% mean(), 
                              this.data[(ans == ans_param[2]), 23:24] %>% 
                                rowMeans() %>% mean(),
                              this.data[(ans == ans_param[3]), 23:24] %>% 
                                rowMeans() %>% mean()
             ),
             'set6_test' = c(this.data[(alpha == alpha_param[1]), 37] %>% 
                               rowMeans() %>% mean(), 
                             this.data[(alpha == alpha_param[2]), 37] %>% 
                               rowMeans() %>% mean(),
                             this.data[(alpha == alpha_param[3]), 37] %>% 
                               rowMeans() %>% mean(),
                             this.data[(egs == egs_param[1]), 37] %>% 
                               rowMeans() %>% mean(), 
                             this.data[(egs == egs_param[2]), 37] %>% 
                               rowMeans() %>% mean(),
                             this.data[(egs == egs_param[3]), 37] %>% 
                               rowMeans() %>% mean(),
                             this.data[(bll == bll_param[1]), 37] %>% 
                               rowMeans() %>% mean(), 
                             this.data[(bll == bll_param[2]), 37] %>% 
                               rowMeans() %>% mean(),
                             this.data[(bll == bll_param[3]), 37] %>% 
                               rowMeans() %>% mean(),
                             this.data[(imag == imag_param[1]), 37] %>% 
                               rowMeans() %>% mean(), 
                             this.data[(imag == imag_param[2]), 37] %>% 
                               rowMeans() %>% mean(),
                             this.data[(imag == imag_param[3]), 37] %>% 
                               rowMeans() %>% mean(),
                             this.data[(ans == ans_param[1]), 37] %>% 
                               rowMeans() %>% mean(), 
                             this.data[(ans == ans_param[2]), 37] %>% 
                               rowMeans() %>% mean(),
                             this.data[(ans == ans_param[3]), 37] %>% 
                               rowMeans() %>% mean()),
            'parameter' = c(rep('alpha',3), rep('egs',3), rep('bll',3), rep('imaginal-activation',3), rep('ans',3)),
            'level'=c(rep(1:3,3), rep(1:3,3), rep(1:3,3), rep(1:3,3), rep(1:3,3))
             
             
  )
  }
return(reurn.data)
}






tmp = cbind(set3,set6, rep(1:3,3)) %>% 
  data.table() 

colnames(tmp)[1:12] = paste0("s3_", colnames(tmp)[1:12])
colnames(tmp)[13:24] = paste0("s3_", colnames(tmp)[13:24])

tmp$other = c(rep("g1", 3), rep("g2", 3), rep("g3", 3))

tmp = tmp %>% 
  melt.data.table(id.vars = c("V25", "other")) %>%  
  .[order(other, V25)]

tmp = tmp %>% 
  .[,`:=`(herro = rep(seq(1:12), 18))]

tmp %>% 
  ggplot() + 
  geom_line(aes(herro, value#, color = as.factor(V25)
                )) + 
  facet_grid(other~V25)








