
!/usr/bin/env python
# coding: utf-8

#import integrated_model_strategy_interface
def simulate_this(model, nParams):
  global run_simulation 

  if model == 'RLLTM1':
    for i in range(nParams):
      print('%%%%%%%%%%%%%%%',  i,   '%%%%%%%%%%%%%%%%%%%%')
      run_simulation(param_combs[i][0], param_combs[i][1],param_combs[i][2], param_combs[i][3], param_combs[i][4],param_combs[i][5], 100)
      if i % 162 == 0 or i == len(param_combs): 
        sim = pd.DataFrame(sim_data, columns=['set3_learn','set6_learn', 'set3_test', 'set6_test','bll', 'alpha', 'egs', 'imag', 'ans' ])
        sim.to_pickle('RLLTM1_sim_data_at' + np.str(i) + 'partial')

  if model == 'RLLTM2':
    for i in range(nParams):
      print('%%%%%%%%%%%%%%%',  i,   '%%%%%%%%%%%%%%%%%%%%')
      run_simulation(param_combs[i][0], param_combs[i][1],param_combs[i][2], param_combs[i][3], param_combs[i][4], 100)
      if i % 162 == 0 or i == len(param_combs): 
        sim = pd.DataFrame(sim_data, columns=['set3_learn','set6_learn', 'set3_test', 'set6_test','bll', 'alpha', 'egs', 'imag', 'ans' ])
        sim.to_pickle('RLLTM2_sim_data_at' + np.str(i) + 'partial')



  if model == 'LTM':

    for i in range(nParams):
      print('%%%%%%%%%%%%%%%',  i,   '%%%%%%%%%%%%%%%%%%%%')
      run_simulation(param_combs[i][0], 0,0, param_combs[i][1], param_combs[i][2], 100)                                                                                   
      #if i % 250 == 0 or i == 3124: 
        #sim = pd.DataFrame(sim_data, columns=['set3_learn','set6_learn', 'set3_test', 'set6_test','bll', 'alpha', 'egs', 'imag', 'ans' ])
        #sim.to_pickle('sim_data_at' + np.str(i) + 'partial')