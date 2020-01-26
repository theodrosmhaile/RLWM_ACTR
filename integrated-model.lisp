(clear-all)

(define-model collins-model-integrated

(sgp :alpha 0.2
     :egs 0.1
     :er t
     :ul t
     :esc t
     ) 

;;; --------------------------------------------------------  
;;; ----------------Chunk types-----------------------------

(chunk-type goal
            strategy
            fproc) ;; fproc= feedback processed
    
(chunk-type stimulus
            picture)

(chunk-type instance
            picture
            associated-key
            outcome)

(chunk-type feedback
            feedback)


(add-dm (make-response isa goal
                       fproc yes)
        (test-stim isa stimulus
                   picture cup)
        (test-feedback isa feedback
                       feedback yes)
        (yes) (no)
        (declarative) (procedural)
        (j) (k) (l) 
        (jeans) (cup) (hat)
        (shirt) (gloves) (shoes)
        (bowl) (plate) (jacket)
        )

;;; META
     

(p choose-declarative
   =visual>
   - picture nil
   
   ?visual>
     state free

   =goal>
     strategy nil  
     fproc yes
==>
   =visual>
     
   *goal>
     strategy declarative
)

(p choose-procedural
   =visual>
   - picture nil
   
   ?visual>
     state free

   =goal>
     strategy nil  
     fproc yes
==>
   =visual>
     
   *goal>
     strategy procedural
)

;;; ============================================================== ;;;
;;; RL PART
;;; ============================================================== ;;;

;;-------------object 1: cup-----------------------
(p cup-j
   =visual>
     picture cup
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
==> 
   +manual>
     cmd    punch
     hand   right
     finger index 

   *goal>
     fproc  no    
   )

(p cup-k
   =visual>
     picture cup
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
==> 
   +manual>
     cmd    punch
     hand   right
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
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
 ==> 
   +manual>
     cmd     punch
     hand    right
     finger  ring 

   *goal>
     fproc no    
   )


;;--------object 2: bowl--------------------------- 
(p bowl-j
   =visual>
     picture bowl
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
==> 
   +manual>
     cmd    punch
     hand   right
     finger index 

   *goal>
     fproc  no    
   )

(p bowl-k
   =visual>
     picture bowl
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
==> 
   +manual>
     cmd punch
     hand right
     finger middle 

   *goal>
     fproc no    
   )

(p bowl-l
   =visual>
     picture bowl
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
   ==> 
   +manual>
   cmd punch
       hand right
       finger ring 
   *goal>
       fproc no    
   )
    
    
    
;;---------object 3: plate-------------------------- 
(p plate-j
   =visual>
     picture plate
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
==> 
   +manual>
       cmd punch
       hand right
       finger index 
   *goal>
       fproc no    
   )

(p plate-k
   =visual>
     picture plate
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
==> 
   +manual>
       cmd punch
       hand right
       finger middle 
   *goal>
       fproc no    
   )

(p plate-l
   =visual>
     picture plate
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
==> 
   +manual>
     cmd punch
       hand right
       finger ring 
   *goal>
       fproc no    
   )
;;--------------- object 4: hat------------------
(p hat-j
   =visual>
     picture hat
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
==> 
   +manual>
       cmd punch
       hand right
       finger index 
   *goal>
       fproc no    
   )

(p hat-k
   =visual>
     picture hat
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
==> 
   +manual>
       cmd punch
       hand right
       finger middle 
   *goal>
       fproc no    
   )

(p hat-l
   =visual>
     picture hat
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
==>
   +manual>
     cmd punch
     hand right
     finger ring 

   *goal>
     fproc no    
   )
;;--------------object 5: gloves------------------

(p gloves-j
   =visual>
     picture gloves
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
 ==> 
   +manual>
       cmd punch
       hand right
       finger index 
   *goal>
       fproc no    
   )

(p gloves-k
   =visual>
     picture gloves
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
 ==>  
   +manual>
       cmd punch
       hand right
       finger middle 
   *goal>
       fproc no    
   )

(p gloves-l
   =visual>
     picture gloves
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
==>
   +manual>
     cmd punch
       hand right
       finger ring 
   *goal>
       fproc no    
   )
 ;;--------------- object 6: shoes-----------------------
(p shoes-j
   =visual>
     picture shoes
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
 ==>  
   +manual>
       cmd punch
       hand right
       finger index 
   *goal>
       fproc no    
   )

(p shoes-k
   =visual>
     picture shoes
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
 ==>  
   +manual>
       cmd punch
       hand right
       finger middle 
   *goal>
       fproc no    
   )

(p shoes-l
   =visual>
     picture shoes
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
 ==>  
   +manual>
   cmd punch
       hand right
       finger ring 
   *goal>
       fproc no    
   )
    
;;--------------- object 7: shirt ------------------------
(p shirt-j
   =visual>
     picture shirt
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
 ==>  
   +manual>
       cmd punch
       hand right
       finger index 
   *goal>
       fproc no    
   )

(p shirt-k
   =visual>
     picture shirt
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
 ==>   
   +manual>
       cmd punch
       hand right
       finger middle 
   *goal>
       fproc no    
   )

(p shirt-l
   =visual>
     picture shirt
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
 ==>   
   +manual>
   cmd punch
       hand right
       finger ring 
   *goal>
       fproc no    
   )
    
;;--------------- object 8: jacket ------------------------    
    
(p jacket-j
   =visual>
     picture jacket
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
 ==>   
   +manual>
       cmd punch
       hand right
       finger index 
   *goal>
       fproc no    
   )

(p jacket-k
   =visual>
     picture jacket
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
 ==> 
   +manual>
       cmd punch
       hand right
       finger middle 
   *goal>
       fproc no    
   )

(p jacket-l
   =visual>
     picture jacket
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
 ==> 
   +manual>
     cmd punch
     hand right
     finger ring 
   *goal>
       fproc no    
   )   
    
;;--------------- object 9: jeans ------------------------ 

(p jeans-j
   =visual>
     picture jeans
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
 ==> 
   +manual>
       cmd punch
       hand right
       finger index 
   *goal>
       fproc no    
   )

(p jeans-k
   =visual>
     picture jeans
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
 ==>  
   +manual>
       cmd punch
       hand right
       finger middle 
   *goal>
       fproc no    
   )

(p jeans-l
   =visual>
     picture jeans
   
   ?visual>
     state free

   =goal>
     strategy procedural  
     fproc    yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
 ==>  
   +manual>
     cmd punch
     hand right
     finger ring 
   *goal>
       fproc no    
   )


;;; ============================================================== ;;;
;;; THE DM PART
;;; ============================================================== ;;;

(p check-memory
   =visual>
     picture =cur_pic 

   ?visual>
     state free

   ?imaginal>
     state free
     buffer empty
     
   =goal>
     strategy declarative  
     fproc    yes
    
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
    strategy declarative   
    fproc    yes
    
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
    strategy declarative   
    fproc    yes

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
    strategy declarative   
    fproc    yes
    
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



;;; ============================================================== ;;;
;;; PROCESS FEEDBACK
;;; ============================================================== ;;;

(p parse-feedback-yes  
   =visual>
     feedback yes

   ?visual>
     state free

   =goal>
   - strategy nil   
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
   - strategy nil
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
    ;;strategy declarative  
    fproc    yes
  
  =imaginal>
    outcome nil	
	
==> 
  *imaginal>
    outcome =f

  =visual>
)


(p commit-to-memory
   "Creates an episodic traces of the previous decision"
  =visual>
    feedback =f

  =goal>
    ;;strategy declarative  
    fproc    yes
    
  =imaginal>
  - outcome nil	
	
==>
  =visual>  
  -imaginal>
)



;;;--------------------------------------------------------    
;;; Productions: processing feedback
;;;--------------------------------------------------------    
      
 
(spp parse-feedback-yes :reward +1)
(spp parse-feedback-no :reward -1)


(goal-focus make-response)


)

(defun quick-test ()
  (reload)
  (schedule-event-relative 0.01 #'(lambda () (set-buffer-chunk 'visual 'test-stim)))
  (schedule-event-relative 5 #'(lambda () (set-buffer-chunk 'visual 'test-feedback)))
  (run 10))
