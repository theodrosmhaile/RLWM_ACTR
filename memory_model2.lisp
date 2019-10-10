;;------------------------------------
;; Model 2
;;------------------------------------
;;

;; This model relies only on storage and retrieval of memory of past experience with stimuli and associated response. It relies on three parameters: memory decay, activation noise and retrieval threshold at which a memory will be...activated/retrieved. 

(clear-all)

(define-model rlwm_memory_model2

(sgp :bll 0.5
     :ans 0.5
     :rt  0.5
     )
    
    ;; Chunk types 
(chunk-type goal 
            fproc yes) ;; fproc= feedback processed
    
(chunk-type stimulus
            picture  )
    
(chunk-type feedback
            feedback yes)
    
;; productions
   ;; Check memory

(p memory
    visual picture cup 
    ==>
   ?retrieval>
   state free
   
   +retrieval> 
   picture =cup
   Outcome yes
   
   +imaginal>
   picture 
)
    
;; Depending on outcome: yes or no

   ;;Outcome is no: make random response (3 possible)
(p response-monkey-j
   =retrieval
   state error
   ==>
   +manual>
   key j
   )
    
(p response-monkey-k
   =retrieval
   state error
   ==>
   +manual>
   key k
   )

(p response-monkey-l
   =retrieval
   state error
   ==>
   +manual>
   key l
   )
    
    
   ;;Outcome is yes: make response based on memory
(p yes!
    =retrieval 
    Outcome yes 
    Key =k
    +imaginals 
    picture =cup
   ?manual
   ==>
   +manual
)

    
;;Encode response after feedback
    
(p encode feedback
    =visuals>
    feedback yes OR no
    ?Imaginal
    outcome nil
    ==> 
    +imaginal>
   
    Outcome = F
)



    
    
    )

