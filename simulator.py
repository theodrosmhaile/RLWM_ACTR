


for i in range(3):
	print('%%%%%%%%%%%%%%%',  i,   '%%%%%%%%%%%%%%%%%%%%')
	run_simulation(param_combs[i][0], param_combs[i][1],param_combs[i][2], param_combs[i][3], param_combs[i][4], 2)                                                                                     
	if i % 250 == 0 or i == 3124:	
		sim = pd.DataFrame(sim_data, columns=['set3_learn','set6_learn', 'set3_test', 'set6_test','bll', 'alpha', 'egs', 'imag', 'ans' ])
		sim.to_pickle('sim_data_at' + np.str(i) + 'partial')

		#np.write_csv
		#generate line of data, separate by tabs and write to open tsv file (lists would be delim by commas) 	
# sim_all.to_json('sim_all.JSON', index=False, orient='table') 


 
#  acc3 = pd.DataFrame(acc_by_presentation3)
           # print("mean accuracy set 3: " , np.mean(acc_by_presentation3))
           # print(acc_by_presentation3)
            #plot 
            #pyplot.figure(dpi=120)
            #pyplot.title("bll ",)
            #sns.regplot(np.arange(12)+1, acc_by_presentation3, order=2, label="set_3")
            #pyplot.show()arange():
 #acc6=pd.DataFrame(acc_by_presentation6)
            #print("mean accuracy set6: ", np.mean(acc6))

            #plot 
           # pyplot.figure(dpi=300)
           #sns.regplot(np.arange(12)+1, acc_by_presentation6, order=2,label="set_6")
            #pyplot.show()

for i in range(125):
  print('%%%%%%%%%%%%%%%',  i,   '%%%%%%%%%%%%%%%%%%%%')
  run_simulation(param_combs[i][0], 0,0, param_combs[i][1], param_combs[i][2], 100)                                                                                   
  #if i % 250 == 0 or i == 3124: 
    #sim = pd.DataFrame(sim_data, columns=['set3_learn','set6_learn', 'set3_test', 'set6_test','bll', 'alpha', 'egs', 'imag', 'ans' ])
    #sim.to_pickle('sim_data_at' + np.str(i) + 'partial')