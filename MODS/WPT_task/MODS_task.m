%function  MODS_task
%NOTES ON TASK HERE
%This is the first version of the MODS task by Tedwardian
%from Pattern2load.mat
%% Game parameters
clear all;
N_trials   = 64;%0; %Number of trials to administer to participants

Record = struct; %All subject data is saved to this struct
% These are the parameters for the MODS task that make up the two
% conditions: Filler character length and span lenght
filler_letters =   ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]; 
% Digits used in the task are sampled randomly from 0 - 9

% Initialize table with all conditions to construct the 64 trials
mods_trials = table();
mods_trials.span        = (reshape(repmat(3:6,16,1),64,1)); % this populates the string diff (2) X digit span (4) X (8) Trials
mods_trials.filler_type = (reshape(repmat(["easy";"hard"],32,1),64,1)); %this provides indicator for 3/4 or 5/6 random seleciton within trial
% if needed reshape(transpose(repmat(3:6, 16,1)), 64,1)


%% Construct Practice trials 
practice(1).trials = {'C', 'H', '5', 'F', 'D', '3'};
%practice(3).trials = {'E', 'A', 'F', 'C','I','7', 'J', 'D', 'B','G','A', '2', 'F','C','I','B','9', 'D', 'H', 'C', 'G', '5'};
practice(2).trials = {'F','E', '3','B', 'A', '0','D', 'I', 'A', '7', 'J', 'C', '1'};
practice(1).instruct  = ['In this practice, you should have read aloud "C", "H", "5", "F", "D", "3", and typed "53", since "5" appeared first.\n\n'...
    'In the actual test there will be longer sequences and they will appear faster.\n\n'...
    'The next demo will give you practice on the task in these more difficult conditions.\n\n\n'...
    'Press the SPACE bar to when you are ready.'];

practice(2).instruct =   ['In this demo, the numbers you should have typed were "3071". The rest of the trials will follow this speed and format.\n\n'... 
	 'Note that you can get partial credit so long as the numbers are in the correct position. If you only remembered 3 and 1 for example,\n\n'...
		'then you should type 3 0 0 1, with blanks filled by 0 or your best guess for partial credit.\n\n' ...
		'If you have any questions about the test, please ask the experimenter at this time.\n\n\n'...
        'Press the SPACE key when you are ready to begin the experiment.'];
		

practice(1).presentation_time = 1.5;
practice(2).presentation_time = [.81];
N_practice_trials = 2;

%% construct Experiment trials
this_subject = randperm(64);
card_presentations = {};
 stim_present =struct;
for i = 1:N_trials
    
    this_subject(i);
    this_span       = mods_trials.span(this_subject(i));
    this_fillr_type = mods_trials.filler_type(this_subject(i));
   
    %This store the distractor letters generated across task for back up
    in_trial_string = nan(1,this_span);
    
    % Here, random sequence of digits fro the current span are generated 
    %try
    seq_targets      = unique(randi([0 9],32,1),"stable"); % generate random sequence of targets
    in_trial_targets = seq_targets(1:this_span);
    %catch
        %error('Task genereation failed because of random number generator. Simply re-start the task.')
        %break
    %end
    % Within each span a variable length of distractors 2 or 3 for easy and
    % 4 or 5 for hard were used. This block randomly selects
     for s = 1:this_span
       
        if this_fillr_type == "hard"

            if rand > 0.5 % randomly select either 5 or 6
            this_n_chars = 5;
            else
            this_n_chars = 6;
            end

        else
            if rand > 0.5 % randomly select either 3 or 4
                this_n_chars = 4;
            else
                this_n_chars = 3;
            end

        end
        
       
         % construct a set of letters, randomly selected from above, to use for this digit in current span
        temp_index       = unique(randi(10, 18,1),'stable'); % letters are refreshed for each digit in current span
       
        in_trial_letters = filler_letters(temp_index(1:this_n_chars-1));
    
        % This is only for backup purposes
        in_trial_string(s) = this_n_chars;
        
        % accumulate sequence of distractor letters, target digits, and 'X'
        % designates time when input is solicited from the participant. 
      
        stim_present(i).distractors(s) = {in_trial_letters};
        stim_present(i).digits(s)      = in_trial_targets(s);
        stim_present(i).order          = this_subject(i);
        stim_present(i).difficulty     = this_fillr_type;
        stim_present(i).span_size      = this_span;
        stim_present(i).str_Length(s)  = this_n_chars; 



    end
    
   
   
     
end

stim_present

%% Display and action recording
if 1
% HideCursor %Hide Mouse pointer
% Keys

ListenChar(2); % prevent keys from writing to matlab
KbName('UnifyKeyNames');
SpaceKey  = KbName('space');
ESCKey    = KbName('escape');
ReturnKey = KbName('return');
ReturnKey = ReturnKey(1);

Screen('Preference', 'SkipSyncTests',1);
%Screen('Preference', 'VisualDebugLevel', 3);
Screen('Preference', 'SuppressAllWarnings', 1);
%Screen Size for debug

%Select screen
use_screen = max(Screen('screens'));
[window, rect] = Screen('OpenWindow', 0, use_screen);% screenRect
%may not be necessary  xcs
wht = [255 255 255];
Screen('FillRect',window,wht);
Screen('Flip',window);

%% initial instructions

instruct_1 = ['In this task, you will be tested on your memory for digits.\n\n' ...
    'You will see letters and digits in the center of the screen, one at a time.\n\n'... 
    'As soon as a letter or digit appears, say them aloud.\n\n\n'...
  'Press the SPACE bar to continue.'  ];

instruct_2 = ['Each trial will have specific sequences of letters and digits.\n\n'...
    'All sequences end with a digit.\n\n'...
    'The number of letters before a digit is not fixed and will vary.\n\n'...
    'The number of sequences of letters and digits will also vary in a trial.\n\n'...
    'Remember that you have to read aloud all letters and digits as they appear.\n\n\n'...
    'Press the SPACE bar to continue.'];

instruct_3 = ['When all the sequences for a trial have been presented, you will see the "|" cursor.\n\n'...the same number of boxes or dashes that you saw
    'This is an indication for you to type in only the digits, in the exact order that they appeared.\n\n'...
    'When you are done entering your numbers, press ENTER to move on to the next trial.\n\n'...
    'You will get partial credit for numbers as long as they are in the same order so fill everything out with your best guess.\n\n\n'...
    ' Press the SPACE bar for a short practice when you are ready.'];
%"When you have filled in " +'all the digits needed you will be unable to type more, but you can still use backspace to change your answer. " +
   
% instruction page 1   
Screen('TextFont', window, 'Times');
Screen('TextSize', window, 32);
DrawFormattedText( window,instruct_1,'center','center',[],300);
Screen('Flip',window);

while 1
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    
    if keyIsDown
        KbReleaseWait;
        if find(keyCode) == SpaceKey
          
            % Screen('DrawText', window,'START',floor(rect(3)/4),floor(rect(4)/2));
            %Screen('Flip',window);
            %WaitSecs(.5)
            break
        end
        
        if find(keyCode) == ESCKey
            ShowCursor
            sca
              
        end
    end
end

% instruction page 2   
Screen('TextFont', window, 'Times');
Screen('TextSize', window, 32);
DrawFormattedText( window,instruct_2,'center','center',[],300);
Screen('Flip',window);

while 1
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    
    if keyIsDown
         KbReleaseWait;
        if find(keyCode) == SpaceKey
           
            % Screen('DrawText', window,'START',floor(rect(3)/4),floor(rect(4)/2));
            %Screen('Flip',window);
            %WaitSecs(.5)
            break
        end
        
        if find(keyCode) == ESCKey
            ShowCursor
            sca
              
        end
    end
end
% instruction page 3   
Screen('TextFont', window, 'Times');
Screen('TextSize', window, 32);
DrawFormattedText( window,instruct_3,'center','center',[],300);
Screen('Flip',window);

while 1
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    
    if keyIsDown
         KbReleaseWait;
        if find(keyCode) == SpaceKey
            
            % Screen('DrawText', window,'START',floor(rect(3)/4),floor(rect(4)/2));
            %Screen('Flip',window);
            %WaitSecs(.5)
            break
        end
        
        if find(keyCode) == ESCKey
            ShowCursor
            sca
              
        end
    end
end

%% practice trials

ptrials = 1; %initialize practice trial index
while ptrials ~= N_practice_trials + 1
    this_practice_response = ''; 
    WaitSecs(1);
    % present stimuli
    
    for i = 1:length(practice(ptrials).trials)
         Screen('TextSize', window, 64); 
       
       DrawFormattedText(window, practice(ptrials).trials{i},'center', 'center');
      %  
        Screen('Flip',window);
        % inter-stimulus interval 1
        WaitSecs(practice(ptrials).presentation_time);
    end
    WaitSecs(.5);
    
    % gather input
    
     cue = ' |';
     Screen('TextSize', window, 64);  
     DrawFormattedText(window, cue,'center', 'center');
     Screen('Flip',window);
     ListenChar(2);
     
     while 1
        
         [ keyIsDown, seconds, keyCode ] = KbCheck;
         
         if keyIsDown
             if find(keyCode,1) == ESCKey
                 ShowCursor
                 ListenChar(0);%Re-enable key access to matlab
                 sca
                 break
            elseif find(keyCode,1) == ReturnKey
               % KbReleaseWait;
                %Record(trials).response = this_span_response;
                %Record(trials).span     = stim_present(trials).digits;
               
                 break
                 
            elseif  find(keyCode,1) < 40 &&  find(keyCode,1) > 29
          
             %else
            
                 % obtain and clean up character
                   KbReleaseWait;
                   temp_char = KbName(keyCode);
                   this_practice_response  = [this_practice_response, temp_char(1) ];              

                   % Display character to subject
                    Screen('TextSize', window, 64);  
                    DrawFormattedText(window, [this_practice_response, cue],'center', 'center');
                    Screen('Flip',window);   
                   
             %else
              %   continue
             end
  
         end
     
     end
     
     WaitSecs(.4);
     
     %Deliver feedback
      keyIsDown = 0;
     Screen('TextSize', window, 32); 
     DrawFormattedText(window, practice(ptrials).instruct ,'center', 'center');
     Screen('Flip',window);    
   
   
    
     
      
      while 1
            [ keyIsDown, seconds, keyCode ] = KbCheck;
        
             if keyIsDown
                   KbReleaseWait;
                if find(keyCode) == SpaceKey
                    ptrials = ptrials + 1; % advance trial index
                    Screen('TextSize', window, 64);  
                    DrawFormattedText(window, 'Ready','center', 'center');
                    Screen('Flip',window);       
                   
                    break
                end
        
             elseif find(keyCode) == ESCKey
                ShowCursor
                ListenChar(0);
                sca
               
             end
           
    
       end
    
end


%% Experiment
trials = 1;

WaitSecs(3);



while trials ~= N_trials + 1
    
  %%  This block loops through each span item and presents all stimuli
   for span_digit = 1:stim_present(trials).span_size
      
   %  this initializes response for recording and display to participant; 
   %  it should be cleared at the end of each span trial. 
       this_span_response = ''; 
   % This block displays the stimuli    
   
       for distractor = 1:stim_present(trials).str_Length(span_digit)-1
       % Select distractor letter for presentaion
       this_letter =  stim_present(trials).distractors{span_digit}{distractor};
       % Prepare screen and present
       Screen('TextSize', window, 64); 
       
       DrawFormattedText(window, this_letter,'center', 'center');
      %  
        Screen('Flip',window);
        % inter-stimulus interval 1
        WaitSecs(.81);
       end
       
      this_digit =  num2str(stim_present(trials).digits(span_digit));
      
      Screen('TextSize', window, 64);  
      DrawFormattedText(window, this_digit,'center', 'center');
      % 
        Screen('Flip',window);
        % inter-stimulus interval 2
        WaitSecs(.91);
   end
   Screen('Flip',window);
    WaitSecs(.5);
     
  
%% This block gathers inputs from subject, provides feedback and saves     
    
    
     cue = ' |';
     Screen('TextSize', window, 64);  
     DrawFormattedText(window, cue,'center', 'center');
     Screen('Flip',window);
       ListenChar(2);
        
    while 1
        
         [ keyIsDown, seconds, keyCode ] = KbCheck;
         
         if keyIsDown
             if find(keyCode,1) == ESCKey
                 ShowCursor
                 ListenChar(0);%Re-enable key access to matlab
                 sca
                 break
            elseif find(keyCode,1) == ReturnKey
                Record(trials).response = this_span_response;
                Record(trials).span     = stim_present(trials).digits;
               
                 break
                 
            elseif  find(keyCode,1) < 40 &&  find(keyCode,1) > 29
          
             %else
            
                 % obtain and clean up character
                   KbReleaseWait;
                   temp_char = KbName(keyCode);
                   this_span_response  = [this_span_response, temp_char(1) ];              

                   % Display character to subject
                    Screen('TextSize', window, 64);  
                    DrawFormattedText(window, [this_span_response, cue],'center', 'center');
                    Screen('Flip',window);       
             %else
              %   continue
             end
  
         end
     
    end
   % 
   WaitSecs(1);
   
   Screen('TextSize', window, 64);  
   DrawFormattedText(window, 'Great!\n Press the SPACE bar to go to the next trial!','center', 'center');
   Screen('Flip',window);
   
   while 1
        [ keyIsDown, seconds, keyCode ] = KbCheck;
    
    if keyIsDown
        if find(keyCode) == SpaceKey
            fprintf('next trial request ran')
            % Screen('DrawText', window,'START',floor(rect(3)/4),floor(rect(4)/2));
            %Screen('Flip',window);
            %WaitSecs(.5)
            break
        end
        
        if find(keyCode) == ESCKey
            ShowCursor
            ListenChar(0);
            sca
               
        end
    end
    
   end
    trials = trials+1;
    if trials == N_trials + 1
        DrawFormattedText( window,'You are all done!\n\n\n Thank you for playing.','center','center',[0 0 249],300);
        
        Screen('Flip',window);
        WaitSecs(5);
        break
    end
    
 WaitSecs(1);
 
   
    
  
    % WaitSecs(1);sca;
end

ListenChar(0); %Re-enable key access to matlab
Screen('CloseAll');

%Error Handling
%catch
%     disp('ERROR')
%     ShowCursor
%      ListenChar(0);
%      sca;

%end
%save(['./data/ID_' num2str(ID) '_record'],'Record','-append')


end






