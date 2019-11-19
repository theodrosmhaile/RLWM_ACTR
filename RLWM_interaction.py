import random as rnd
import numpy as np
import os
import sys
import string
import actr


model = actr.load_act_r_model('/home/theodros/RLWM_ACTR/rlwm_model1.lisp')


#present feedback
#list stim. 
stims_3 = ['cup','bowl','plate']
stims_6 = ['hat','gloves','shoes', 'shirt', 'jacket', 'jeans']
nTrials = 25
#associated responses (these are arbitrary)
stims_3_resps = ['j', 'k', 'k'];
stims_6_resps = ['k','k', 'j', 'j', 'l', 'l'];

stims = rnd.choices(stims_3, k = nTrials)
chunks = None
current_response = current_response=np.repeat('x',nTrials)
cor_resps = rnd.choices(stims_3_resps, k= nTrials)
i = 0
win = None
#key = None


#index i needs defining

#Daisy chained python functions to present stimuli, get response and  present feedback

def present_stim():
    global chunks
    global stims
    global i
    chunks = actr.define_chunks(['isa', 'stimulus', 'picture', stims[i]])
    actr.set_buffer_chunk('visual', chunks[0])
    
    print(i)
       
    
def get_response(model, key):
    global current_response
    global i
    #global key
    
    actr.schedule_event_relative(0, 'present_feedback')# changes event to 1 from 0
    current_response[i] = key
   
    i = i + 1
    return current_response

def present_feedback():
    global current_response
    feedback = 'no'
 
    # check if response matches the appropriate key for the current stimulus in cue
    #need list of correct responses
    if current_response[i] == cor_resps[i]:
        feedback = 'yes'
    
    chunks = actr.define_chunks(['isa', 'feedback', 'feedback',feedback])
    actr.set_buffer_chunk('visual', chunks[0])
    actr.schedule_event_relative(1, 'present_stim')


def make_random_stim_list(LIST):
    return rnd.choices(LIST, k=50)

# This function builds ACT-R representations of the python functions

def model_loop():
    global win
    global welp
    actr.add_command('present_stim', present_stim, 'presents stimulus') 
    actr.add_command('present_feedback', present_feedback, 'presents feedback')
    actr.add_command('get_response', get_response, 'gets response')
    
    #open window for interaction
    win = actr.open_exp_window("test", visible = False)
    actr.install_device(win)
    actr.schedule_event_relative(0, 'present_stim' )
    
    #waits for a key press?
    actr.monitor_command("output-key", 'get_response')
    actr.run(35)
   


#I think this needs a simulator?
#def simulator():
#actr.run(1)    
#model_loop()
      

