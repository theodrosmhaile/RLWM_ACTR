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
(chunk-type goal fproc no) ;; fproc= feedback processed
    
(chunk-type stimulus
            picture)
    
(chunk-type feedback
            feedback yes)
    
;; Chunks
    ;; Goal  
    
    ;; Stimulus chunks
    
;; **add chunks for all images? **
(add-dm stimulus
        picture cup
        ) 

(add-dm stimulus
        picture bowl
        ) 
(add-dm stimulus
        picture plate
        ) 
    
;;Productions: 1 for each image : 2 conditions (ns 6 & ns 3) * 
;;- visual, encode stimulus, check visual to see if its free,  make response (j, k or l)based on Q value, updates goal?. 
;;  If never   encountered, select arbitrarily

 ;;object 1: cup
(p cup
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
       key j
   +goal>
       fproc no    
   )
    
    
 ;;  object 2: bowl 
    (p bowl
   =visual>
       =picture bowl 
   ?visual>
       state free
   ==> 
   
   ?manual>
   preparation free
     processor free
     execution free
   
   +manual>
       key j
   +goal>
       fproc no    
   )
    
 ;; Productions: processing feedback  

    (p parse-feedback
   =visual>
       feedback yes
   ?visual
       state free
   =goal
       fproc n
   ==>
   *goal>
       frpoc yes
   )
    
    
    
    
    )