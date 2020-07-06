#!/usr/bin/env bash

################################################
# This shell scrip is designed to run dockers in parallel - 2 per process ACTR + interface
#
#




#  TOdo
# - need iterator
# - flexible port assign: 
#	  - the HOST ports can be arbitrary for all interface containers
#     - the HOST ports for the ACTR containers will have to match the CONTAINER ports for the interface containers
#     - the CONTAINER ports on ACTR containers have to always be 2650
#
#
#
#
# Docker run flags used: 
# -d: run in background
# -t: simulate tty(no idea what that means but it keeps the docker container from exiting)
# --rm: remove container after exit
# -v mount shared location HOST:CONTAINER
# -p port forwarding HOST:CONTAINER

p=(25) # this will equal to the number of iterations planned, which will be the same as (p)orts. Can be input from stdin

#sim_param=(125) #This will vary by experiment. 125 for LTM model
use_ports=(2650 2651 2652 2653 2654 2655 2656 2657 2658) #"$(echo {2650..2653})" 


fromi=(0 15 30 45 55 70 85 100 115)
Toi=(14 29 44 54 69 84 99 114 124)

for (( i = 0; i < 1; i++ )); do
	#statements

#This starts the ACTR server in the background
	echo ${use_ports[$i]}
	docker run -td -v /Users/theodros/RLWM_ACTR:/RLWM_ACTR -p ${use_ports[$i]}:2650 v10actr bash -c "cd RLWM_ACTR; sbcl --load "/actr7.x/load-act-r.lisp""
		
#This starts the interface container --rm
	docker run -d -v /Users/theodros/RLWM_ACTR/:/RLWM_ACTR  -p 8000-9000:${use_ports[$i]} --env temp_port=${use_ports[$i]} --env fi=${fromi[$i]} --env ti=${Toi[$i]} --env frac=$i v10actr bash -c 'cd /root; printf "$temp_port">act-r-port-num.txt; cd /RLWM_ACTR/ ; echo "start sleep"; sleep 20; python3 -c "import LTM_model_interface as MI; MI.execute_sim(100,$fi,$ti,$frac)"'

done





