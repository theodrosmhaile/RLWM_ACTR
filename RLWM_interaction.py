import random as rnd
import numpy as np
import os
import sys
import string
import actr


#get response

#present feedback
#list stim. 
stims_3 = ['cup','bowl','plate']
stims_6 = ['hat','gloves','shoes', 'shirt', 'jacket', 'jeans']

stims = None
chunks = None
current_response = None
i = 0

#index i needs defining

#Daisy chained python functions to present stimuli, get response and  present feedback

def present_stim():
    global chunks
    chunks = actr.define_chunks([['isa', 'stimulus', 'picture', stims[i]]])
    print(type(chunks))
    actr.set_buffer_chunk('visual', chunks[0])
    
    
def present_feedback():
    feedback = 'no'
    if current_response == 'j':
        feedback = 'yes'
        
    chunks = actr.define_chunks([['isa', 'feedback', 'feedback',feedback]])
    actr.set_buffer_chunk('visual', chunks[0])
    actr.schedule_event_relative(1, 'present_stim')
    
def get_response(model, key):
    global current_response
    global i
    current_response = key
    actr.schedule_event_relative(0, 'present_feedback')
    i = i + 1

def make_random_stim_list(LIST):
    return rnd.choices(LIST, k=50)

# This function builds ACT-R representations of the python functions

def model_loop():
    
    actr.add_command('present_stim', present_stim, 'presents stimulus') 
    actr.add_command('present_feedback', present_feedback, 'presents feedback')
    actr.add_command('get_response', get_response, 'gets response')
    
    actr.monitor_command('output-key', 'get_response')
    actr.schedule_event_relative(0, 'present_stim' )
    

#stims = make_random_stim_list(stims_6)   
#I think this needs a simulator?
#def simulator():
#actr.run(1)    

#actr.load_act_r_model('~/RLWM_ACTR/rlwm_model1.lisp')
#chunks=actr.define_chunks([['poptart-k', 'isa', 'stimulus', 'picture', 'Poptart']])



      


