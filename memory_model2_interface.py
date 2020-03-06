#!/usr/bin/env python
# coding: utf-8

# ### Python interface for Model 2


import random as rnd
import numpy as np
import os
import sys
import string
import actr
import pandas as pd
import seaborn as sns 
from matplotlib import pyplot







#Load model
curr_dir = os.path.dirname(os.path.realpath(__file__))
actr.load_act_r_model(os.path.join(curr_dir, "integrated-model.lisp"))
#model = actr.load_act_r_model('/home/theodros/RLWM_ACTR/memory_model2.lisp')

## Daisy chained python functions to present stimuli, get response and  present feedback

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

    if i > lastLearnTrial:
    # this tests whether the current trial is a test phase. This portion does not present feedback but checks accuracy
        if current_response[i] == cor_resps[i]:
            accuracy[i] = 1
            feedback = "x"
            chunks = actr.define_chunks(['isa', 'feedback', 'feedback',feedback])
            actr.set_buffer_chunk('visual', chunks[0])
            
        actr.schedule_event_relative(1, 'present_stim')
        print("Feedback given: X, test phase" )
  
    else:
    # This runs for learning phase. This portion presents feedback
        feedback = 'no'
        
    # check if response matches the appropriate key for the current stimulus in cue
        if current_response[i] == cor_resps[i]:
            feedback = 'yes'
            accuracy[i] = 1
    # present feedback    
        chunks = actr.define_chunks(['isa', 'feedback', 'feedback',feedback])
        actr.set_buffer_chunk('visual', chunks[0])
        print("Feedback given: ", feedback )
        
        if i == lastLearnTrial:
            print("BREAK HERE")
            actr.schedule_event_relative(600, 'present_stim')
        else:
            actr.schedule_event_relative(1, 'present_stim')
#increase index for next stimulus
    i = i + 1
   

# This function builds ACT-R representations of the python functions

def model_loop():
    
    global win
    actr.add_command('present_stim', present_stim, 'presents stimulus') 
    actr.add_command('present_feedback', present_feedback, 'presents feedback')
    actr.add_command('get_response', get_response, 'gets response')
    
    #initial goal dm
    actr.define_chunks(['make-response','isa', 'goal', 'fproc','yes'])  
    actr.goal_focus('make-response')    

    #open window for interaction
    win = actr.open_exp_window("test", visible = False)
    actr.install_device(win)
    actr.schedule_event_relative(0, 'present_stim' )
    
    #waits for a key press?
    actr.monitor_command("output-key", 'get_response')
    actr.run(2000)
    


## execute model
temp3   = [] #initialize variables to concat all outputs from simulations
temp6   = []
simData = []
nsimulations = np.arange(3) #set the number of simulations "subjects"
for x in nsimulations:
    actr.reset()
    #Stimuli to be used and exp parameters
    stims_3 = ['cup','bowl','plate']
    stims_6 = ['hat','gloves','shoes', 'shirt', 'jacket', 'jeans']
    test_stims = ["bowl", "shirt", "jeans", "plate", "cup", "jacket"] #Each stimulus was presented 4 times during test
    nPresentations = 12 #learning phase, items were presented 12-14 times during learning
    nTestPresentations = 4
    nTrials = (nPresentations * 9) + (nTestPresentations * np.size(test_stims))  #3 #for sets size three experiment/block

    #associated responses (matches Collins' patterns of response-stim associations)
    stims_3_resps = ['j', 'j', 'l']
    stims_6_resps = ['k','k', 'j', 'j', 'l', 'l']
    test_resps    = ["j", "j", "l", "l", "j", "l"]

    #generate stimult to present to model **Edit as needed **

    #this shuffles both lists, stimuli and associated correct responses, in the same order

    # 3 set block
    stims_temp3 = list( zip(np.repeat(stims_3, 12).tolist(),
             np.repeat(stims_3_resps,12).tolist()
            ))

    rnd.shuffle(stims_temp3)

    stims3, cor_resps3 = zip(*stims_temp3)
    
    # 6 set block
    stims_temp6 = list( zip(np.repeat(stims_6, 12).tolist(),
        np.repeat(stims_6_resps, 12).tolist()
        ))
    rnd.shuffle(stims_temp6)
    stims6, cor_resps6 = (zip(*stims_temp6))

   
   # test phase 
    test_temp = list(zip(np.repeat(test_stims, 4).tolist(),
	np.repeat(test_resps, 4).tolist()
  	  ))

    rnd.shuffle(test_temp)
    teststims, cor_testresps = (zip(*test_temp))
     
    # concat all stimuli and responses together to present
    
    stims = stims3 + stims6 + teststims
    cor_resps = cor_resps3 + cor_resps6 + cor_testresps
  
    #variables needed
    chunks = None
    current_response  = np.repeat('x', nTrials * 2).tolist() #multiply by 2 for number of blocks
    accuracy = np.repeat(0, nTrials).tolist()
    lastLearnTrial = np.size(stims3 + stims6) -1
    
    i = 0
    win = None
    model_loop()
    


simData.append(i)


   

    #set parameters, if needed....
    #actr.set_parameter_value(":ans",0.9) 
    #actr.set_parameter_value(":bll",0.9) 


## data analysis and plotting


     if False :
        print('mean accuracy: ', np.mean(accuracy))


        stims_array = np.asarray(stims[0:lastLearnTrial + 1]) 
        acc_array   = np.asarray(accuracy[0:lastLearnTrial + 1]) 

        cup_presented   = np.where(stims_array == 'cup') 
        bowl_presented  = np.where(stims_array == 'bowl') 
        plate_presented = np.where(stims_array == 'plate') 

        acc_by_presentation3 = np.mean([acc_array[cup_presented], acc_array[plate_presented], acc_array[bowl_presented]],0)
        acc3 = pd.DataFrame(acc_by_presentation3)
       # print("mean accuracy set 3: " , np.mean(acc_by_presentation3))
       # print(acc_by_presentation3)
        #plot 
        #pyplot.figure(dpi=120)
        #sns.regplot(np.arange(12)+1, acc_by_presentation3, order=2, label="set_3")
        #pyplot.show()

    # 6 items plot (will be fixed later)
    if False : 
        hat_presented    = np.where(stims_array == 'hat') 
        gloves_presented = np.where(stims_array == 'gloves') 
        shoes_presented  = np.where(stims_array == 'shoes') 
        shirt_presented  = np.where(stims_array == 'shirt') 
        jacket_presented = np.where(stims_array == 'jacket') 
        jeans_presented  = np.where(stims_array == 'jeans') 

        acc_by_presentation6 = np.mean([acc_array[hat_presented], 
            acc_array[gloves_presented], 
            acc_array[shoes_presented],
            acc_array[shirt_presented],
            acc_array[jacket_presented],1
            acc_array[jeans_presented]], 0)
        acc6=pd.DataFrame(acc_by_presentation6)
        print("mean accuracy set6: ", np.mean(acc_by_presentation6))
       
        #plot 
       # pyplot.figure(dpi=300)
        #sns.regplot(np.arange(12)+1, acc_by_presentation6, order=2,label="set_6")
        #pyplot.show()
        temp3.append(acc_by_presentation3)
        temp6.append(acc_by_presentation6)
        # plot test accuracy
    if False:
        test_array = np.asarray(stims[lastLearnTrial+1 : np.size(stims)]) 
        test_acc_array   = np.asarray(accuracy[lastLearnTrial+1 : np.size(stims)]) 


        cup_presented   = np.where(test_array == 'cup') 
        bowl_presented  = np.where(test_array == 'bowl') 
        plate_presented = np.where(test_array == 'plate') 

        hat_presented    = np.where(test_array == 'hat') 
        gloves_presented = np.where(test_array == 'gloves') 
        shoes_presented  = np.where(test_array == 'shoes') 
        shirt_presented  = np.where(test_array == 'shirt') 
        jacket_presented = np.where(test_array == 'jacket') 
        jeans_presented  = np.where(test_array == 'jeans') 

        test_3 = pd.DataFrame(np.mean([test_acc_array[cup_presented], test_acc_array[plate_presented], test_acc_array[bowl_presented]],0))

        test_6 = pd.DataFrame(np.mean([ 
            test_acc_array[shirt_presented],
            test_acc_array[jacket_presented],
            test_acc_array[jeans_presented]], 0))

        #pyplot.figure(dpi=120)
        sns.barplot(x=["set 3", "set 6"], y=[np.mean(test_3),np.mean(test_6)]) 
        



    if False:
        #save data to files
        f3 = open("set3.csv", 'a')
        f6 = open("set6.csv", 'a')
        acc6.transpose().to_csv(f6, mode='a', header = False)
        acc3.transpose().to_csv(f3, mode='a', header = False)
        f3.close()
        f6.close()

