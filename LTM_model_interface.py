#!/usr/bin/env python
# coding: utf-8

# ### Python interface for integrated model


import random as rnd
import numpy as np
import os
import sys
import string
import actr
import pandas as pd
import seaborn as sns 
from matplotlib import pyplot
import itertools


show_output = False

#Load model
curr_dir = os.path.dirname(os.path.realpath(__file__))
actr.load_act_r_model(os.path.join(curr_dir, "LTM_model.lisp")) #integrated-model-pipe.lisp

## Daisy chained python functions to present stimuli, get response and  present feedback

def present_stim():
    global chunks
    global stims
    global i
    global show_output

    if i < nTrials:
        
   
        chunks = actr.define_chunks(['isa', 'stimulus', 'picture', stims[i]])
        actr.set_buffer_chunk('visual', chunks[0])
        
        if(show_output):
            print('Presented: ', stims[i])
            print('correct response: ', cor_resps[i])   

    
def get_response(model, key):
    global current_response
    global i
    global strategy_used

    
    actr.schedule_event_relative(0, 'present_feedback')
    current_response[i] = key 
    #print('response')
    return current_response


def present_feedback():
    global i
    global current_response
    global accuracy


    if i > lastLearnTrial:
    # this tests whether the current trial is a test phase. This portion presents meaningless feedback and checks accuracy
        if current_response[i] == cor_resps[i]:
            accuracy[i] = 1

        feedback = "x"
        chunks = actr.define_chunks(['isa', 'feedback', 'feedback',feedback])
        actr.set_buffer_chunk('visual', chunks[0])
            
        actr.schedule_event_relative(1, 'present_stim')

        if (show_output):
            print("Feedback given: X, test phase" )
            print(accuracy)


  
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

        if (show_output):
            print("Feedback given: ", feedback )
            print(accuracy)
        
        if i == lastLearnTrial:
            #rint("BREAK HERE")
            actr.schedule_event_relative(600, 'present_stim')
        else:
            actr.schedule_event_relative(1, 'present_stim')
#increase index for next stimulus
    i = i + 1
    
   

# This function builds ACT-R representations of the python functions

def model_loop():
    
    global win
    global accuracy
    global nTrials
    global strategy_used
    
    accuracy = np.repeat(0, nTrials).tolist()
   


   
    
    #initial goal dm
    actr.define_chunks(['make-response','isa', 'goal', 'fproc','yes'])  
  #  actr.add_dm(['test-feedback', 'isa', 'feedback', 'feedback', 'yes'])
    
  #  actr.add_dm('yes'); actr.add_dm('no') 
    
   # actr.add_dm('declarative'); actr.add_dm('procedural')
    
   # actr.add_dm('j'); actr.add_dm('k'); actr.add_dm('l')

    #actr.add_dm('jeans'); actr.add_dm('cup'); actr.add_dm('hat'); 
    #actr.add_dm('shirt'); actr.add_dm('plate'); actr.add_dm('gloves')
    #actr.add_dm('shoes'); actr.add_dm('bowl'); actr.add_dm('jacket')

    actr.goal_focus('make-response')    
    
    #open window for interaction
    win = actr.open_exp_window("test", visible = False)
    actr.install_device(win)
    actr.schedule_event_relative(0, 'present_stim' )
   
    #waits for a key press?
   
    actr.run(2000)
    
    #print(accuracy)

actr.add_command('present_stim', present_stim, 'presents stimulus') 
actr.add_command('present_feedback', present_feedback, 'presents feedback')
actr.add_command('get_response', get_response, 'gets response')
actr.monitor_command("output-key", 'get_response')

## execute model and simulate data

#Stimuli to be used and exp parameters
stims_3 = ['cup','bowl','plate']
stims_6 = ['hat','gloves','shoes', 'shirt', 'jacket', 'jeans']
test_stims = ["bowl", "shirt", "jeans", "plate", "cup", "jacket"] #Each stimulus was presented 4 times during test
nPresentations = 12 #learning phase, items were presented 12-14 times during learning
nTestPresentations = 4
nTrials = (nPresentations * 9) + (nTestPresentations * np.size(test_stims))  #3 #for sets size three experiment/block
accuracy = np.repeat(0, nTrials).tolist()


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
lastLearnTrial = np.size(stims3 + stims6) -1

#parameter ranges for simulation
bll_param   = [0.3, 0.4, 0.5, 0.6, 0.7]   # decay rate of declarative memory,range around .5 actr rec val
alpha_param = [0.05, 0.1, 0.15, 0.2, 0.25] # learning rate of the RL utility selection 0.2 rec val
egs_param   = [0.1, 0.2, 0.3, 0.4, 0.5] # amount of noise added to the RL utility selection
imag_param  = [0.1, 0.2, 0.3 , 0.4, 0.5] #simulates working memory as attentional focus 
ans_param   = [0.1, 0.2, 0.3, 0.4, 0.5] #parameter for noise in dec. memory activation. Range recommended by ACTR manual.
# [0.4, 0.5, 0.6]#
# [0.1, 0.15, 0.2]#
# [0.2, 0.3, 0.4]#
# [0.2, 0.3, 0.4]#

#Integrated model params

#combine all params for a loop 
#params = [bll_param, alpha_param, egs_param, imag_param, ans_param]
#param_combs = list(itertools.product(*params))

#RL model params
#params = [alpha_param, egs_param]
#param_combs = list(itertools.product(*params))

# LTM model params
params = [bll_param, imag_param, ans_param]
param_combs = list(itertools.product(*params))

 ###########initialize variables to concat all outputs from simulations

sim_data3 = [] #saves mean curves and parameters
sim_data6 = []
sim_data  = []
sim_std = []
I_data = []
#i=0



def simulation(bll, alpha, egs, imag, ans, nSims):
   
    global i
    global sim_data3
    global sim_data
    global sim_data6
    global accuracy
    global sim_std
    
    print('vars reset')
    temp3 = [] 
    temp6 = []
    temp_test3 = []
    temp_test6 = []
    #accuracy = np.repeat(0, nTrials).tolist()
    nsimulations = np.arange(nSims) #set the number of simulations "subjects"
    for n in nsimulations:
        print("sim ", n)
        actr.reset()
        actr.hide_output()

        actr.set_parameter_value(":bll", bll)
       # actr.set_parameter_value(":alpha", alpha)
        #actr.set_parameter_value(":egs", egs)
        actr.set_parameter_value(":visual-activation", imag)#formerly imaginal activation
        actr.set_parameter_value(":ans", ans)
        
        i = 0
        win = None
        print(i)
        model_loop()

       
       ### Analyze generated data: LEARNING
            ##set 3 analysis 

        stims_array = np.asarray(stims[0:lastLearnTrial + 1]) 
        acc_array   = np.asarray(accuracy[0:lastLearnTrial + 1]) 

        cup_presented   = np.where(stims_array == 'cup') 
        bowl_presented  = np.where(stims_array == 'bowl') 
        plate_presented = np.where(stims_array == 'plate') 

        acc3 = np.mean([acc_array[cup_presented], acc_array[plate_presented], acc_array[bowl_presented]],0)
          
               ##set 6 analysis 
        
       
        hat_presented    = np.where(stims_array == 'hat') 
        gloves_presented = np.where(stims_array == 'gloves') 
        shoes_presented  = np.where(stims_array == 'shoes') 
        shirt_presented  = np.where(stims_array == 'shirt') 
        jacket_presented = np.where(stims_array == 'jacket') 
        jeans_presented  = np.where(stims_array == 'jeans') 

        acc6 = np.mean([acc_array[hat_presented], 
            acc_array[gloves_presented], 
            acc_array[shoes_presented],
            acc_array[shirt_presented],
            acc_array[jacket_presented],
            acc_array[jeans_presented]], 0)
       
        temp3.append(acc3)
        temp6.append(acc6)

            ### Analyze generated data:  TESTING PHASE
    
        test_array = np.asarray(stims[lastLearnTrial+1 : np.size(stims)]) 
        test_acc_array   = np.asarray(accuracy[lastLearnTrial+1 : np.size(stims)]) 


        cup_presented_t   = np.where(test_array == 'cup') 
        bowl_presented_t  = np.where(test_array == 'bowl') 
        plate_presented_t = np.where(test_array == 'plate') 

        hat_presented_t    = np.where(test_array == 'hat') 
        gloves_presented_t = np.where(test_array == 'gloves') 
        shoes_presented_t  = np.where(test_array == 'shoes') 
        shirt_presented_t  = np.where(test_array == 'shirt') 
        jacket_presented_t = np.where(test_array == 'jacket') 
        jeans_presented_t  = np.where(test_array == 'jeans') 

        test_3 = np.mean([test_acc_array[cup_presented_t], test_acc_array[plate_presented_t], test_acc_array[bowl_presented_t]],0)

        test_6 = np.mean([ 
            test_acc_array[shirt_presented_t],
            test_acc_array[jacket_presented_t],
            test_acc_array[jeans_presented_t]], 0)
        
        #aggregate accuracies across simulations
        temp_test3.append(test_3)
        temp_test6.append(test_6)

       # print('accuracy ', np.mean(accuracy))
            #pyplot.figure(dpi=120)
            #sns.barplot(x=["set 3", "set 6"], y=[np.mean(test_3),np.mean(test_6)]) 
        
        if False:
            #save data to files
            f3 = open("set3.csv", 'a')
            f6 = open("set6.csv", 'a')
            acc6.transpose().to_csv(f6, mode='a', header = False)
            acc3.transpose().to_csv(f3, mode='a', header = False)
            f3.close()
            f6.close()
        I_data.append(i)

       

#                   save averaged resluts from simulations along with parameters

        #sim_data.append([temp3, temp6, np.mean(test_3), np.mean(test_6), bll, alpha, egs, imag, ans ])
        #del temp3, temp6
    #changelog: saving all instances of the simulation by moving the sim_data insidr the simulator loop
    sim_data.append([np.mean(temp3,0), np.mean(temp6,0), np.mean(np.mean(temp_test3,1)), np.mean(np.mean(temp_test6, 1)), bll, alpha, egs, imag, ans ])
    
    sim_std.append([np.std(temp3,0), np.std(temp6,0), np.std(np.mean(temp_test3,1)), np.std(np.mean(temp_test6, 1))])

    sim_data3.append(temp_test3)
    #sim_data6.append(temp6)
        #del temp3, temp6   
    #return np.mean(test_6)
#sum(np.array(pd.DataFrame(I_data)<132))        

def execute_sim(n,fromI,toI, frac):

    for i in range(fromI, toI):

        simulation(param_combs[i][0], 0,0, param_combs[i][1], param_combs[i][2], n)
      
    sim = pd.DataFrame(sim_data, columns=['set3_learn','set6_learn', 'set3_test', 'set6_test','bll', 'alpha', 'egs', 'imag', 'ans' ])
    sim_st = pd.DataFrame(sim_std, columns=['set3_learn','set6_learn', 'set3_test', 'set6_test'])
    sim_st.to_JSON('./simulated_data/LTM_model/LTM_sim_std_date.JSON',orient='table')
    sim.to_pickle('./simulated_data/LTM_model/LTM_sim_data_' + 'frac_' +np.str(frac) +'_'+ np.str(fromI) + '_to_' + np.str(toI))  





        
