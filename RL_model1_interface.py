#!/usr/bin/env python
# coding: utf-8

# ### Python interface

import random as rnd
import numpy as np
import os
import sys
import string
import actr
import pandas as pd
import csv
import seaborn as sns 
from matplotlib import pyplot


sub_ID = 'A2E1'
#Stimuli to be used and exp parameters
stims_3 = ['cup','bowl','plate']
stims_6 = ['hat','gloves','shoes', 'shirt', 'jacket', 'jeans']
nPresentations = 12
nTrials = nPresentations * 3 #for sets size three experiment/block

#associated responses (these are arbitrary)
stims_3_resps = ['j', 'k', 'l'];
stims_6_resps = ['k','k', 'j', 'j', 'l', 'l'];

#generate stimult to present to model **Edit as needed **

#this shuffles both lists, stimuli and associated correct responses, in the same order
stims_temp = list( zip(np.repeat(stims_3, 12).tolist(),
         np.repeat(stims_3_resps,12).tolist()
        ))

rnd.shuffle(stims_temp)

stims, cor_resps = zip(*stims_temp)


# ### Python interface for Model 1




#Load model
model = actr.load_act_r_model('/home/theodros/RLWM_ACTR/RL_model1.lisp')


#variables needed
chunks = None
current_response  = np.repeat('x', nTrials).tolist()
accuracy = np.repeat(0, nTrials).tolist()

i = 0
win = None


#Daisy chained python functions to present stimuli, get response and  present feedback

def present_stim():
    global chunks
    global stims
    global i
   
    chunks = actr.define_chunks(['isa', 'stimulus', 'picture', stims[i]])
    actr.set_buffer_chunk('visual', chunks[0])
    
    print('Presented: ', stims[i])
    print('correct response: ', cor_resps[i])   
    
def get_response(model, key):
    global current_response
    global i
    
    actr.schedule_event_relative(0, 'present_feedback')
    
    current_response[i] = key
   
    return current_response

def present_feedback():
    global i
    global current_response
    global accuracy
    
    feedback = 'no'
     
    # check if response matches the appropriate key for the current stimulus in cue
    #need list of correct responses
    if current_response[i] == cor_resps[i]:
        feedback = 'yes'
        accuracy[i] = 1
    
    chunks = actr.define_chunks(['isa', 'feedback', 'feedback',feedback])
    actr.set_buffer_chunk('visual', chunks[0])
    print("Feedback given: ", feedback )
  
    #increase index for next stimulus
    i = i + 1
    actr.schedule_event_relative(1, 'present_stim')
    

# This function builds ACT-R representations of the python functions

def model_loop():
    
    global win
    actr.add_command('present_stim', present_stim, 'presents stimulus') 
    actr.add_command('present_feedback', present_feedback, 'presents feedback')
    actr.add_command('get_response', get_response, 'gets response')
    
    #open window for interaction
    win = actr.open_exp_window("test", visible = False)
    actr.install_device(win)
    actr.schedule_event_relative(0, 'present_stim' )
    
    #waits for a key press?
    actr.monitor_command("output-key", 'get_response')
    actr.run(45)
   





model_loop()
      
print('mean accuracy: ', np.mean(accuracy))


# ### Response analysis
#
#print(current_response)
#print(accuracy)

#print(stims)
#print(cor_resps)

stims_array = np.asarray(stims)
acc_array = np.asarray(accuracy)

cup_presented   = np.where(stims_array == 'cup') 
bowl_presented  = np.where(stims_array == 'bowl') 
plate_presented = np.where(stims_array == 'plate') 

acc_by_presentation = np.mean([acc_array[cup_presented], acc_array[plate_presented], acc_array[bowl_presented]],0)
print(acc_by_presentation)
#plot 
pyplot.figure(dpi=300)
sns.lineplot(np.arange(12) + 1, acc_by_presentation, markers=True)

#save file to csv
#if 0:
    #reshape stimuli into stimulus x presentation. Note nRows will either be 3 or 6 depending on number of stimuli
   # stims_df = pd.DataFrame(np.reshape(stims, (3,12), order='F').tolist())     
    





