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
(chunk-type goal fproc yes) ;; fproc= feedback processed
    
(chunk-type stimulus
            picture     )
    
(chunk-type feedback
            feedback yes)
    
    
    )

