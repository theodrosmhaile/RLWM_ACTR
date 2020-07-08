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


use_ports=(2650 2651 2652 2653 2654 2655 2656 2657 2658 2659 2660 2661 2662 2670 2664 2665 2666 2667 2668 2669 2670 2671 2672 2673 2674 2675 2676 2677 2678 2679 2680 2681 2682 2683 2684 2685 2686 2687 2688 2689 2690 2691 2692 2693 2694 2695 2696 2697 2698 2699 2700 2701 2702 2703 2704 2705 2706 2707 2708 2709 2710 2711 2712 2713 2714 2715 2716 2717 2718 2719 2720 2721 2722 2723 2724 2725 2726 2727 2728 2729 2730 2731 2732 2733 2734 2735 2736 2737 2738 2739 2740 2741 2742 2743 2744 2745 2746 2747 2748 2749 2750)
# 2751 2752 2753 2754 2755 2756 2757 2758 2759 2760 2761 2762 2763 2764 2765 2766 2767 2768 2769 2770 2771 2772 2773 2774 2775 2776 2777 2778 2779 2780 2781 2782 2783 2784 2785 2786 2787 2788 2789 2790 2791 2792 2793 2794 2795 2796 2797 2798 2799 2800) #"$(echo {2650..2653})" 

fromi=(0 125 250 375 Ï500 625 750 875 1000 1125 1250 1375 1500 1625 1750 1875 2000 2125 2250 2375 2500 2625 2750 2875 3000 3125 3250 3375 3500 3625 3750 3875 4000 4125 4250 4375 4500 4625 4750 4875 5000 5125 5250 5375 5500 5625 5750 5875 6000 6125 6250 6375 6500 6625 6750 6875 7000 7125 7250 7375 7500 7625 7750 7875 8000 8125 8250 8375 8500 8625 8750 8875 9000 9125 9250 9375 9500 9625 9750 9875 10000 10125 10250 10375 10500 10625 10750 10875 11000 11125 11250 11375 11500 11625 11750 11875 12000 12125 12250 12375)

Toi=(124 249 374 499 624 749 874 999 1124 1249 1374 1499 1624 1749 1874 1999 2124 2249 2374 2499 2624 2749 2874 2999 3124 3249 3374 3499 3624 3749 3874 3999 4124 4249 4374 4499 4624 4749 4874 4999 5124 5249 5374 5499 5624 5749 5874 5999 6124 6249 6374 6499 6624 6749 6874 6999 7124 7249 7374 7499 7624 7749 7874 7999 8124 8249 8374 8499 8624 8749 8874 8999 9124 9249 9374 9499 9624 9749 9874 9999 10124 10249 10374 10499 10624 10749 10874 10999 11124 11249 11374 11499 11624 11749 11874 11999 12124 12249 12374 12499)

for (( i = 80; i < 90; i++ )); do
	#statements

#This starts the ACTR server in the background
	echo ${use_ports[$i]}
	#docker run -td -v /Users/theodros/RLWM_ACTR:/RLWM_ACTR -p ${use_ports[$i]}:2650 v10actr bash -c "cd RLWM_ACTR; sbcl --load "/actr7.x/load-act-r.lisp""
		#see if clozure does better
	docker run -td -v /home/ec2-user/RLWM_ACTR:/RLWM_ACTR -p ${use_ports[$i]}:2650 actr_aws bash -c "cd RLWM_ACTR; sbcl --load "/actr7.x/load-act-r.lisp""
	
#This starts the interface container --rm
	docker run -d --rm -v  /home/ec2-user/RLWM_ACTR/:/RLWM_ACTR  -p 8000-9000:${use_ports[$i]} --env temp_port=${use_ports[$i]} --env fi=${fromi[$i]} --env ti=${Toi[$i]} --env frac=$i actr_aws bash -c 'cd /root; printf "$temp_port">act-r-port-num.txt; cd /RLWM_ACTR/ ; echo "start sleep"; sleep 20; python3 -c "import strategy_integrated_model_interface as MI; MI.execute_sim(100,$fi,$ti,$frac)"'

done

#check on iteration number 2. 
#now checking if ccl works better, perhaps sbcl is the problem. 
# started ccl versions of 4 and 5 at 11:15 pm -  these have verbose on in clisp

#ran 0:50 and around 25 broke. so we need to re-run the broken ones. Currently moving forward with 50 to 79 (tmh 07/70-7:30pm)| adding 10 more

