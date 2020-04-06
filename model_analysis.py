#!/usr/bin/env python
# coding: utf-8



import random as rnd
import numpy as np
import os
import sys
#import strings
import pandas as pd
import seaborn as sns 
from matplotlib import pyplot
import itertools


#----- import subject data
#
sdat = pd.read_csv('./RLWM_data/subject_learn_test_data.csv')
# sdat contains data fro 26 participants (columns), 
# rows 1:12 learn accuracy set 3 ; 
# rows 13:24 learn accuracy set 6 ;
# row 25 test set 3 accuracy ;
# row 26 test set 6 accuracy ;

#----- import model data
mdat = pd.read_json('sim_data_first_half_param_space_030620_integr_model100sTEST.JSON') 


#----- loop through subject data and check for fit against model data. 
# Save row index of model data that fit each participant best and extract 
