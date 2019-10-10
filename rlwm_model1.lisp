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
(chunk-type goal 
            fproc) ;; fproc= feedback processed
    
(chunk-type stimulus
            picture)
    
(chunk-type feedback
            feedback)
    
;; Chunks
    
    ;; Goal  
    
    ;; Stimulus chunks
    
;; **add chunks for all images? **
(add-dm (cup-stimulus
        isa stimulus
       picture cup)
        ) 
    
(add-dm (make-response
        isa goal
        fproc yes)
        )

;;(add-dm stimulus
 ;;       picture bowl
;;        ) 
;;(add-dm stimulus
 ;;       picture plate
  ;;      ) 
    
;;Productions: 1 for each image : 2 conditions (ns 6 & ns 3) * 3 response keys
;;- visual, encode stimulus, check visual to see if its free,  make response (j, k or l)based on Q value, updates goal?. 
;;  If never   encountered, select arbitrarily

 ;;object 1: cup
(p cup-j
   =visual>
       picture cup 
   ?visual>
       state free
    =goal>
   fproc yes
   
   ?manual>
   preparation free
     processor free
     execution free
   ==> 
   +manual>
       cmd punch
       hand right
       finger index 
   +goal>
       fproc no    
   )

(p cup-k
   =visual>
       picture cup 
   ?visual>
       state free
 =goal>
   fproc yes
   ?manual>
   preparation free
     processor free
     execution free
   ==> 
   +manual>
       cmd punch
       hand right
       finger middle 
   *goal>
       fproc no    
   )

(p cup-l
   =visual>
       picture cup 
   ?visual>
       state free
  =goal>
   fproc =x
   ?manual>
   preparation free
     processor free
     execution free
   ==> 
   +manual>
   cmd punch
       hand right
       finger ring 
   *goal>
       fproc no    
   )
    
 ;;  object 2: bowl 
(p bowl-j
   =visual>
       picture bowl 
   ?visual>
       state free
   =goal>
   fproc =x
   ?manual>
   preparation free
     processor free
     execution free
   ==>
   +manual>
   cmd punch
       hand right
       finger index 
   *goal>
       fproc no    
   )
    
 ;; Productions: processing feedback  

(p parse-feedback
   =visual>
       feedback yes
   ?visual>
       state free
   =goal>
       fproc no
   ==>
   *goal>
       fproc yes
   )
    
(goal-focus
 make-response)
 
(set-buffer-chunk 'visual 'cup-stimulus)    
    
    
    )