

param.influence <- function(this.data, model) {
  bll_param   = c(0.4, 0.5, 0.6)
  alpha_param = c(0.1, 0.15, 0.2)
  egs_param   = c(0.2, 0.3, 0.4)
  imag_param  = c(1, 2, 3)
  ans_param   = c(0.2, 0.3, 0.4)
 # model='RLLTM'
#  this.data = LTM.sim.dat
  
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
    
    reurn.data = data.frame('set3_learn' =  c(
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
    'set3_test' = c(
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
    
    'set6_learn' = c(
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
    'set6_test' = c(
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
    
    'parameter' = c( rep('bll',3), rep('imaginal-activation',3), rep('ans',3)),
    'level'=c(rep(1:3,3), rep(1:3,3), rep(1:3,3))
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