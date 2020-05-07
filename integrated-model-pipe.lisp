;;; ============================================================== ;;;
;;; INTEGRATED DECLARATIVE/PROCEDURAL MODEL FOR THE COLLINS TASK
;;; ============================================================== ;;;
;;; The model can perform the task in two possible ways:
;;;
;;;    1. Declarative strategy: The model first attempts to retrieve a
;;;       memory of a previously successful response with the given
;;;       stimulus.
;;;
;;;       1.1  If a memory is found, the response is used .
;;;
;;;       1.2  If no memory is found, the model responds randomly.
;;;
;;;    2. Procedural strategy: The model uses RL to sort out the best
;;;       S-R options. All the S-R combinations are available at the
;;;       beginning.
;;;
;;; At every trial, the model proceeds through the following steps:
;;;
;;;    1. Meta-arbitration: The model chooses whether to proceed
;;;       procedurally or declaratively.
;;;
;;;    2. Strategy execution. This is either declarative or
;;;       procedural.
;;;
;;;    3. Feedback processing. This is divided into two sub-phases:
;;;
;;;       3.1 Feedback parsing, in which the binary feedback is used
;;;           to propagate ack reward signals (for RL)
;;;
;;;       3.2 Feedback encoding, in which the
;;;           stimulus-response-outcome information is stored in DM.
;;;
;;; ============================================================== ;;;
;;; Change log: 
;;; (04/27/20 TMH)This version of the model 'pipes' information from RL to LTM: 
;;;
;;;  - modified (p choose-procedural) to put stimulus, associated-key and outcome 
;;;    in to imaginal buffer. 
;;;  
;;;  - Each of the RL productions write to imaginal buffer the 
;;;     keypressed and stimulus.
;;;
;;;  - Added production (p encode-feedback-RL) that encodes feedback 
;;;     RL trials. 
;;;
;;;  - Modified production (p commit-to-memory) to fire regardless of
;;;    strategy. 
;;;
;;;   - Removed (p reset-strategy-procedural) because it stops (p commit-to-memory)
;;; ============================================================== ;;;



(clear-all)

(define-model collins-model-integrated-pipe

(sgp :alpha 0.2
     :egs 0.1
     :visual-activation 5.0
     :mas 5.0
   ;;:imaginal-activation
     :bll 0.5
     :ans 0.1
     :er t
     :ul t
     :esc t
     :v nil ;;"/home/master-tedward/RLWM_ACTR/v_output.txt"
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


;(add-dm 
  ;;(make-response isa goal
    ;;                  fproc yes)
       ;; (test-stim isa stimulus
        ;;          picture cup)
        ;;(test-feedback isa feedback
         ;;             feedback yes)
       ; (yes) (no)
       ; (declarative) (procedural)
       ; (j) (k) (l) 
       ; (jeans) (cup) (hat)
       ; (shirt) (gloves) (shoes)
       ; (bowl) (plate) (jacket)
       ; )

;;; ============================================================== ;;;
;;; META-ARBITRATION
;;; ============================================================== ;;;

(p choose-declarative
   =visual>
   - picture nil
   
   ?visual>
     state free

   =goal>
     strategy nil  
     fproc yes
   
     ?manual>
     preparation free
     processor   free
     execution   free
==>
   =visual>
     
   *goal>
     strategy declarative

   +manual> 
   cmd  press-key
   key  0

)

(p choose-procedural
   =visual>
   - picture nil
   
   ?visual>
     state free

   =goal>
     strategy nil  
     fproc yes
   
   ?manual>
     preparation free
     processor   free
     execution   free
==>
   =visual>
     
   *goal>
     strategy procedural

  +imaginal>
  picture  nil
  associated-key nil
  outcome  nil

  +manual>
   cmd press-key
   key 1
)


;;; ============================================================== ;;;
;;; TEST PHASE PROCESS FEEDBACK
;;; ============================================================== ;;;

(p parse-test-feedback
   =visual>
     feedback x

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



;;; ============================================================== ;;;
;;; RL PROCEDURAL STRATEGY
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

     ?imaginal>
      state free
      buffer empty

    =imaginal>
    ;picture  nil
    ;associated-key nil
==> 
   +manual>
     cmd    punch
     hand   right
     finger index 

   *goal>
     fproc  no 
    
    =imaginal>
    picture  cup
    associated-key j

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

   ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
==> 
   +manual>
     cmd    punch
     hand   right
     finger middle 

   *goal>
     fproc no

    *imaginal>
    picture  cup
    associated-key k
    
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
  
  ?imaginal>
    state free 

  =imaginal>
    ;picture  nil
    ;associated-key nil

 ==> 
   +manual>
     cmd     punch
     hand    right
     finger  ring 

   *goal>
     fproc no  

    *imaginal>
    picture  cup
    associated-key l  
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

    ?imaginal>
    state free

  =imaginal>
   ; picture  nil
   ; associated-key nil

==> 
   +manual>
     cmd    punch
     hand   right
     finger index 

   *goal>
     fproc  no  

   *imaginal>
    picture bowl
    associated-key j    
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
==> 
   +manual>
     cmd punch
     hand right
     finger middle 

   *goal>
     fproc no  

   *imaginal>
    picture  bowl
    associated-key k   
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

    ?imaginal>
    state free

  =imaginal>
   ; picture  nil
   ;associated-key nil
   ==> 
   +manual>
   cmd punch
       hand right
       finger ring 
   *goal>
       fproc no 

     *imaginal>
    picture  bowl
    associated-key l   
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
==> 
   +manual>
       cmd punch
       hand right
       finger index 
   *goal>
       fproc no  

    *imaginal>
    picture plate
    associated-key j   
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
==> 
   +manual>
       cmd punch
       hand right
       finger middle 
   *goal>
       fproc no

    *imaginal>
    picture plate
    associated-key k    
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
==> 
   +manual>
     cmd punch
       hand right
       finger ring 
   *goal>
       fproc no    

    *imaginal>
    picture plate
    associated-key l

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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
==> 
   +manual>
       cmd punch
       hand right
       finger index 
   *goal>
       fproc no    

    *imaginal>
    picture hat
    associated-key j
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
==> 
   +manual>
       cmd punch
       hand right
       finger middle 
   *goal>
       fproc no   

     *imaginal>
    picture hat
    associated-key k 
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
==>
   +manual>
     cmd punch
     hand right
     finger ring 

   *goal>
     fproc no    

   *imaginal>
    picture hat
    associated-key l
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

     ?imaginal>
     state free

    =imaginal>
    ;picture  nil
    ;associated-key nil
 ==> 
   +manual>
       cmd punch
       hand right
       finger index 
   *goal>
       fproc no 

     *imaginal>
    picture gloves
    associated-key j   
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
 ==>  
   +manual>
       cmd punch
       hand right
       finger middle 
   *goal>
       fproc no   

     *imaginal>
    picture gloves
    associated-key k 
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
==>
   +manual>
     cmd punch
       hand right
       finger ring 
   *goal>
       fproc no   

     *imaginal>
    picture gloves
    associated-key l 
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
 ==>  
   +manual>
       cmd punch
       hand right
       finger index 
   *goal>
       fproc no  

     *imaginal>
    picture shoes
    associated-key j  
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
 ==>  
   +manual>
       cmd punch
       hand right
       finger middle 
   *goal>
       fproc no  

    *imaginal>
    picture  shoes
    associated-key k   
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
 ==>  
   +manual>
   cmd punch
       hand right
       finger ring 
   *goal>
       fproc no   


     *imaginal>
    picture shoes
    associated-key l 
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
 ==>  
   +manual>
       cmd punch
       hand right
       finger index 
   *goal>
       fproc no  

     *imaginal>
    picture shirt
    associated-key j  
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
 ==>   
   +manual>
       cmd punch
       hand right
       finger middle 
   *goal>
       fproc no 

     *imaginal>
    picture shirt
    associated-key k    
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
 ==>   
   +manual>
   cmd punch
       hand right
       finger ring 
   *goal>
       fproc no  

    *imaginal>
    picture shirt
    associated-key l
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
 ==>   
   +manual>
       cmd punch
       hand right
       finger index 
   *goal>
       fproc no  

     *imaginal>
    picture jacket
    associated-key j    
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
 ==> 
   +manual>
       cmd punch
       hand right
       finger middle 
   *goal>
       fproc no 

    *imaginal>
    picture jacket
    associated-key k   
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
 ==> 
   +manual>
     cmd punch
     hand right
     finger ring 
   *goal>
       fproc no 

    *imaginal>
    picture jacket
    associated-key l   
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
 ==> 
   +manual>
       cmd punch
       hand right
       finger index 
   *goal>
       fproc no

    *imaginal>
    picture jeans
    associated-key j     
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

    ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
 ==>  
   +manual>
       cmd punch
       hand right
       finger middle 
   *goal>
       fproc no 


     *imaginal>
    picture jeans
    associated-key k  
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

   ?imaginal>
    state free

  =imaginal>
    ;picture  nil
    ;associated-key nil
 ==>  
   +manual>
     cmd punch
     hand right
     finger ring 
   *goal>
       fproc no   

     *imaginal>
    picture jeans
    associated-key l 
   )


;;; ============================================================== ;;;
;;; DECLARATIVE (LTM + WM) STRATEGY
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

; (p reset-strategy-procedural
;    "Encodes the visual response"
;   =visual>
;     feedback =f
   
;   ?imaginal>
;     state free
  

;   =goal>
;     strategy procedural
;     fproc    yes
   
;    =imaginal>
;     outcome nil 
; ==> 
;   ;*goal>
;    ; strategy nil

  
  
;   =visual>
; )


(p encode-feedback-RL
     =visual>
    feedback =f

   ?visual>
     state free

   ?imaginal>
     state free
     
   =goal>
     strategy procedural  
     fproc    yes
   
   =imaginal>
    outcome nil 
  ==>
         
   *imaginal>
    outcome =f

   =visual>
  )

(p encode-feedback
   "Encodes the visual response"
  =visual>
    feedback =f
   
  ?imaginal>
    state free

  =goal>
    strategy declarative  
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
   - strategy nil
   ; strategy declarative
    fproc    yes
    
  =imaginal>
  - outcome nil	
	
==>
  *goal>
    strategy nil
  -visual>  
  -imaginal>
) 



;;;--------------------------------------------------------    
;;; INITIALIZATION
;;;--------------------------------------------------------    
      
 
(spp parse-feedback-yes :reward +1)
(spp parse-feedback-no :reward -1)

;;(spp choose-declarative :u -10000)

;;(goal-focus make-response) ;;maybe?
)  ;; END OF MODEL



(defun quick-test ()
  (reload)
  (schedule-event-relative 0.01 #'(lambda () (set-buffer-chunk 'visual 'test-stim)))
  (schedule-event-relative 5 #'(lambda () (set-buffer-chunk 'visual 'test-feedback)))
  (run 10))
