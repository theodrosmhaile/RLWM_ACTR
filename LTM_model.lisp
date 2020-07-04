;;------------------------------------
;; LTM Model 2
;;------------------------------------
;;

;; This model relies only on storage and retrieval of memory of past experience 
;; with stimuli and associated response. 
;; It relies on three parameters: memory decay(BLL), activation noise(ANS) and 
;; retrieval threshold(RT) at which a memory will be...activated/retrieved. 
;; Important features: Stiumulus, associate-key and feedback 

;;------------------------------------
;; Change log
;;------------------------------------
;; 03/30/20TMH updated commit-to-memory production to match integrated-model.lisp
;;            - Added parse-feedback-yes and parse-feedback-no productions
;;            - Enabled subsymbolic computations
;;            - Minor modifications to encode-feedback and commit-to-memory productions
;;            - Added parse-feedback-test productions 
;;
;;------------------------------------




(clear-all)

(define-model LTM_model

(sgp ;;:bll 0.
     ;;:ans nil
     ;; :rt  0.5  ;; Not needed
     :er  t
     :v nil
     :esc t
     :mas 8.0
     ;:visual-activation 5.0 
     )

;;---------------------------------------    
;; Chunk types
;;--------------------------------------- 

(chunk-type goal
            responded ;; Whether a response was chosen or not
            fproc)    ;; fproc= feedback processed
    
(chunk-type stimulus
            picture
            associated-key
            outcome 
            )
    
(chunk-type feedback
            feedback)

;;---------------------------------------
;; Chunks
;;---------------------------------------

;;(add-dm (yes isa chunk)
 ;;       (no  isa chunk)
   ;;     (make-response isa       goal
     ;;                  responded no
       ;;                fproc     yes)
        ;)


;;----------------------------------------
;; productions
;;----------------------------------------
   ;; Check memory: picture cur_pic, current picture presented is a variable. 
   ;; This is a general purpose production that just takes in whatever presented stimulus
   ;; and checks against declarative memory in the retrieval buffer

(p check-memory
   =visual>
     picture =cur_pic 

   ?visual>
     state free

   ?imaginal>
     state free
     buffer empty
     
   =goal>
     fproc yes
    
   ?retrieval>
     state free
   - buffer full
  ==>
       
   +retrieval> 
      picture =cur_pic
      outcome yes
   
   +imaginal>
      picture =cur_pic

   =visual>
)
;;-------------------------------------    
;; Depending on outcome: yes or no (retrieval error)

   ;;outcome is no (retrieval error): make random response (3 possible)
;;-------------------------------------

(p response-monkey-j
  ?retrieval>
    state error

  ?imaginal>
    state free

  =imaginal>
    associated-key nil

  =goal>
    fproc yes
  
  =visual>
  - picture nil

  ?manual>
    preparation free
    processor free
    execution free
==>
  +manual>
    cmd punch
    hand right
    finger index

  =imaginal>
    associated-key j
  
  *goal>
    fproc no

  =visual>
  )
    
(p response-monkey-k
  ?retrieval>
    state error

  =goal>
    fproc yes

  =visual>
  - picture nil

  ?imaginal>
    state free

  =imaginal>
    associated-key nil

  ?manual>
    preparation free
    processor free
    execution free
==>
  +manual>
    cmd punch
    hand right
    finger middle

  =imaginal>
    associated-key k

  *goal>
    fproc no
  
  =visual>
  )


(p response-monkey-l
  ?retrieval>
    state error

  =visual>
  - picture nil

  ?imaginal>
    state free

  =goal>
    fproc yes

  =imaginal>
    associated-key nil

  ?manual>
    preparation free
    processor free
    execution free

==>
  +manual>
    cmd punch
    hand right
    finger ring

  =imaginal>
    associated-key l

  *goal>
    fproc no

  =visual>
  )
   
;;-------------------------------------    
;;outcome is yes: make response based on memory 
;; How do I select, conditionally, the right key to press if we have only one production?
;;-------------------------------------

(p outcome-yes
  =retrieval> 
    outcome yes 
    associated-key =k

  =goal>
    fproc yes

  ?imaginal>
    state free

  =imaginal>
    associated-key nil
  
  ?manual>
    preparation free
    processor free
    execution free

==>

  +manual>
    cmd press-key
    key =k

  *imaginal>
    associated-key =k
  
  *goal>
    fproc no   
)

    
;;Encode response after feedback
 
(p parse-feedback-yes  
   =visual>
     feedback yes

   ?visual>
     state free

   =goal>
    fproc no
==>
   =visual>

   *goal>
     fproc yes
)


(p parse-feedback-no
   =visual>
     feedback no

   ?visual>
     state free

   =goal>
      fproc no
==>
   =visual>

   *goal>
     fproc yes
)

(p encode-feedback
   "Encodes the visual response"
  =visual>
    feedback =f
   
  ?imaginal>
    state free

  =goal>
    fproc yes
  
  =imaginal>
    outcome nil	
	
==> 
  *imaginal>
    outcome =f

  ;*goal>
   ; fproc yes  

  =visual>
  )


(p commit-to-memory
   "Creates an episodic traces of the previous decision"
  =visual>
    feedback =f

  =goal>
    fproc  yes
    
  =imaginal>

  - outcome nil 
  
==>
  
  -visual>  
  -imaginal>
) 

(p parse-test-feedback
   =visual>
     feedback x

   ?visual>
     state free

   =goal>
       fproc no
==>
   =visual>

   *goal>
     fproc yes
)

;;(p outcome-no-commit-to-memory

  ;;)

;;(goal-focus make-response)
 


;;(set-buffer-chunk 'visual 'cup-stimulus)    
    
)

