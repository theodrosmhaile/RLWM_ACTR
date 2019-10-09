;;------------------------------------
;; Model 1
;;------------------------------------
;;
;; This is a 'pure' reinforcement learning model of the RLWM task (COllins, 2018). This model has only two parameters: alpha(learning 
;;rate) and temperature(softmax function)

;; Stimulus is displayed --> processed --> disapears --> a response is selected --> feedback is given --> feedback is processed

(clear-all)

(define-model rlwm_model1

;; parameters - learning rate and temperature (expected gain s: amount of noise added to *utility*/selection)
(sgp :alpha 0.8
     :egs 0.5
     ) 

;; Chunk types 
(chunk-type goal fproc> no) ;; fproc= feedback processed
    
(chunk-type stimulus
            picture)
    
    
;; Chunks
    ;; Goal chunk (?) 
    
    ;; Stimulus chunks
    
;; **add chunks for all images? **
(add-dm stimulus
        picture cup
        ) 

(add-dm stimulus
        picture bowl
        ) 
(add-dm stimulus
        picture glass
        ) 
    
;;Productions: 1 for each image : 2 conditions (ns 6 & ns 3) * 
;;- visual, encode stimulus, check visual to see if its free,  make response (c, v or b)based on Q value, updates goal?. 
;;  If never   encountered, select arbitrarily

(p cup-k
   =visual>
       =picture cup 
   ?visual>
       state free
   ==> 
   
   ?manual>
   preparation free
     processor free
     execution free
   
   +manual>
       key c
   +goal>
       fproc no    
   )
 ;; Productions: processing feedback  
(p feedback )
    
    
    
    
    )