%%  RLWM + test phase. Tortoise and the Hare, JoCN 2018

%%% Anne Collins
%%%% UC Berkeley
%%%% November 2014
%%%% annecollins@bberkeley.edu

%Instructions for RLWM testing phase
language = 1;
text1 = 'Great!  You are almost done with this experiment.\n\nPress space to continue.';
text2 = 'It is time to test what you have learned. \n\n\n During this set of trials you will NOT see the feedback to your responses,\n\nbut the computer still assigns you points for the image you choose.';
text3 = ['You will see two images from the task on the screen at one time:',...
    '\n\nOne on the left and the other on the right. \n\n\nPick the picture that won you the most points during the previous learning task!',...
    '\n\n\n\nAt the end, we will tell you how many points you won in this part!'];
text4 = 'If you are not sure which one to pick, \n\n\n just go with your gut instinct!';
text5 = 'To choose the image on the left, hit the "1" key.\n\n\nTo choose the image on the right, hit the "0" key.';
text6 = 'If you have questions, call the experimenter into the room.\n\n\nIf not, press the spacebar to begin.';


DrawFormattedText(wPtr,text1,'center','center');
Screen(wPtr, 'Flip');
KbWait([],3); %Waits for keyboard(any) press

DrawFormattedText(wPtr,text2,'center','center');
Screen(wPtr, 'Flip');
KbWait([],3); %Waits for keyboard(any) press

DrawFormattedText(wPtr,text3,'center','center');
Screen(wPtr, 'Flip');
KbWait([],3); %Waits for keyboard(any) press

DrawFormattedText(wPtr,text4,'center','center');
Screen(wPtr, 'Flip');
KbWait([],3); %Waits for keyboard(any) press

DrawFormattedText(wPtr,text5,'center','center');
Screen(wPtr, 'Flip');
KbWait([],3); %Waits for keyboard(any) press

DrawFormattedText(wPtr,text6,'center','center');
Screen(wPtr, 'Flip');
KbWait([],3); %Waits for keyboard(any) press