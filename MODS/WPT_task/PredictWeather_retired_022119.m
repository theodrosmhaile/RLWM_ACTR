%function  PredictWeather
%NOTES ON TASK HERE

%% Game Logic
% Card Probabilities - predicts Sun (ALMOST USELESS)
%Card1_prob = .8;
%Card2_prob = .6;
%Card3_prob = .4;
%Card4_prob = .2;
%ID = input('Please enter Participant ID and press ENTER: ');
N_trials   = 200;%0; %Number of trials to administer to participants
N_patterns = 14; %Number of possible combinations from Kaiun_li 2016

%Pattern cell contains the following data (just index assignment):  
%                                           correct outcome
num_ID = 1; prob = 2; freq = 3; pat_ID = 4; co = 5;co_prob = 6; Lseq = 7;
trial_im = 8; T_out = 9;
Pattern{num_ID} = 1:N_patterns;

%P = probability, from Kaiun_li 2016
Pattern{prob} = [.095 % 1110
             .045 % 1101
             .13  % 1100
             .045 % 1011
             .06  % 1010
             .03  % 1001
             .095 % 1000
             .095 % 0111
             .03  % 0110
             .06  % 0101
             .045 % 0100
             .13  % 0011 
             .045 % 0010
             .095];%0001

    % Pattern identitiy is based on its numerical location in this vector    
Pattern{pat_ID} = [1 2 3 0
                   1 2 0 4
                   1 2 0 0
                   1 0 3 4
                   1 0 3 0
                   1 0 0 4
                   1 0 0 0
                   0 2 3 4
                   0 2 3 0
                   0 2 0 4
                   0 2 0 0
                   0 0 3 4
                   0 0 3 0
                   0 0 0 4];
    

% Build Frequency table
Pattern{freq} = Pattern{prob} * N_trials;
Pattern{Lseq}    =[]; %initialize
%Feb 19/19 Update: A single saved random pattern of trials is used for
%everyone. 

load('./cards/RandomPat4everyone.mat')
Pattern{Lseq} = RandomPattern;
% for p = 1:length(Pattern{num_ID})
%     %dumb code but expands frequency
%   Pattern{Lseq} = vertcat(Pattern{Lseq},...
%       ones(Pattern{freq}(p),1)*Pattern{num_ID}(p));
% end
% % Randomize frequency table with the restriction that the same trial does
% temp_rand_index = randperm(N_trials); % Generate Randomiz-ing index
% 
% Pattern{Lseq} = Pattern{Lseq}(temp_rand_index); % Randomize
% 
% %Check if the first two are consecutive
% chk = diff(Pattern{Lseq});
% 
% %Fix if first two patterns are consecutive
% while chk(1)==0
%     temp_rand_index = randperm(N_trials);
%     Pattern{Lseq}    = Pattern{Lseq}(temp_rand_index);
%     chk = diff(Pattern{Lseq});
% 
% end
% 
%  %From Matlab Central: shuffling with constraint
% old_idx = unique(find(diff(Pattern{Lseq})==0));%find repeats
% while ~isempty(old_idx) %continue until no repeats
%     new_idx = unique(setdiff(1:length(Pattern{Lseq}),old_idx)); %find new spots
%     new_idx = new_idx((randi(length(new_idx),length(old_idx),1)))';
%     Pattern{Lseq}([new_idx;old_idx],:) = Pattern{Lseq}([old_idx;new_idx],:); %swap
%     old_idx = unique(find(diff(Pattern{Lseq})== 0));%find repeats
% end
disp('Creating Task...')


 %Optimal pattern outcome: 1 = sun, 0 = rain
Pattern{co}   = [1 
                 1
                 1
                 0
                 1
                 nan
                 1
                 0
                 nan
                 0
                 1
                 0
                 0
                 0];
             
Pattern{co_prob} = [.895
                    .778
                    .923
                    .222
                    .833
                    .5
                    .895
                    .105
                    .5
                    .167
                    .556
                    .077
                    .444
                    .105];
% Randomly assign CARD to cue for each Participant
card_names = {'sqr','dia','cir','tri'}; %card names
cardShuffle = randperm(4);
disp('Task Loaded.')
for x = 1:length(card_names)
    
Cards_this_session{x} = card_names{cardShuffle(x)};%cardShuffle
end
Record.Cards_this_session = Cards_this_session

% Generate entire set of trial images using the shuffled images
disp('Loading Images...')
for im = 1:N_trials
   
    ThisTrial   = Pattern{Lseq}(im); %Get trial
    ThisPattern = find(Pattern{pat_ID}(ThisTrial,:));% Get pattern
    ord         = randperm(length(ThisPattern)); % Randomize order of stim images
    
%Generate this trials stim
    Image_temp = [];
    for t = 1:length(ord)
        
        Image_temp = horzcat(Image_temp,...
                imread(['./cards/'...  directory
                Cards_this_session{ThisPattern(ord(t))} ... randomized image for concat
                         '.png']));
    end
    
    
    
        
Pattern{trial_im}{im} = Image_temp(:,:,1);
clear Image_tmp
end
disp('Images Ready')
 %% Display and action recording
HideCursor %Hide Mouse pointer
%Keys
ListenChar(2); % prevent keys from writing to matlab
KbName('UnifyKeyNames');
SpaceKey = KbName('space');
%RShift = KbName('rightshift');
%LShift = KbName('leftshift'); 
ESCKey = KbName('escape');
R_ain = KbName ('r');%Rain Report
S_un  = KbName ('s');%Sun report
resp_distribution(S_un)= 1; %Sun report
resp_distribution(R_ain)= 0; %Rain Report

Screen('Preference', 'SkipSyncTests',1);
%Screen('Preference', 'VisualDebugLevel', 3);
Screen('Preference', 'SuppressAllWarnings', 1);
%Screen Size for debug
%screenRect = [0,0,1200,700];%For debug

%Select screen
use_screen = max(Screen('screens'));
[window, rect] = Screen('OpenWindow', 0, use_screen);% screenRect
%may not be necessary 
wht = [255 255 255];
Screen('FillRect',window,wht);
Screen('Flip',window);

%initial instructions
instruct_1 = ['You will be predicting the weather in this task.\n\n\n ', ...
'You will see 1 to 3 cards on the screen.\n\n\n',... 
'Each card predicts SUN or RAIN with some likelihood.\n\n\n',...
'Your job is to view the cards and decide if the weather will be SUN or RAIN in every trial.\n\n\n\n', ...
'Press the S key to indicate SUN and R key to indicate RAIN after each decision.\n\n\n'...
'You will receive feedback CORRECT! or WRONG! \n\n\n to help you learn to make more accurate predictions.\n\n\n ',...
'PLEASE ANSWER AS FAST AS POSSIBLE!\n\n\n\n' ...
'You will feel like you are guessing at the beginning but you will learn quickly.\n\n\n\n',...
' Press the SPACEBAR to start. ' ];
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, 28);
DrawFormattedText( window,instruct_1,'center',150,[],300);
Screen('Flip',window);

%press key to advance
while KbCheck; end
while 1
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    
    if keyIsDown
        if find(keyCode) == SpaceKey
            Record.startTime = seconds;
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
trials = 1;

WaitSecs(.1);
save(['./data/ID_' num2str(ID) '_record'],'Pattern');
%try
curr_accuracy = 0; %init
while trials ~= N_trials + 1
    
    %WaitSecs(.5);
    % KbWait;
    %compute accuracy
   
    %get image stats
        [size_y,size_x] = size(Pattern{trial_im}{trials});
        %compute location on screen
          
      
        %Screen centers
        X_center = rect(3) / 2;
        Y_center = rect(4) / 2;
       
         PixelOffsetX = X_center -(size_x / 2);%320;
        PixelOffsetY = Y_center -(size_y / 2);%500;
        window_stim = [PixelOffsetX,PixelOffsetY, PixelOffsetX + size_x,PixelOffsetY + size_y] ;
        
        ThisImage = Screen('MakeTexture',window,Pattern{trial_im}{trials});
        Screen('DrawTexture',window,ThisImage,[],window_stim)
         %Screen('DrawText',window,['Trial Number: ',num2str(trials)] ,50,50,[0 0 0]);
         
         %format accuracy value
       thisText = num2str(curr_accuracy);


        Screen('Flip',window);
         if length(thisText)> 4 
          Screen('DrawText',window,['Accuracy: ',thisText(1:4),' %'] ,50,50,[0 0 0]);
         else   
          Screen('DrawText',window,['Accuracy: ',thisText,' %'] ,50,50,[0 0 0]);
        end
      
        
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    
    
        
    if keyIsDown
         
        %WaitSecs(5);
        if length(find(keyCode)) == 1
        if find(keyCode) == R_ain   ||  find(keyCode) == S_un
            
            Record.keypresses(trials) = seconds;%save reaction time
            %ThisTrial_Outcome = Pattern{co  }(Pattern{Lseq}(trials));
           ThisTrial_prob = Pattern{co_prob}(Pattern{Lseq}(trials));
           % if isnan(ThisTrial_Outcome)
                ThisTrial_Outcome = double(rand < ThisTrial_prob); %return a 'Sun' with predetermined probability
            %end
            
            Response = resp_distribution(find(keyCode));
            
            %Save data
            Record.trialOutcome(trials) = ThisTrial_Outcome;
            Record.Response(trials) = Response;
            
            if ThisTrial_Outcome == Response
                Screen('DrawText',window,'CORRECT!' ,X_center-85,Y_center,[76 165 76]);
                Screen('TextSize', window, 24);
                Screen('Flip',window);
               WaitSecs(.2); %1.5 
                curr_accuracy = sum(Record.trialOutcome==Record.Response)/trials * 100;
                save(['./data/ID_' num2str(ID) '_record'],'Record','-append')
            else
                Screen('DrawText',window,'WRONG!' ,X_center-85,Y_center,[249 0 0]);
                Screen('TextSize', window, 24);
                Screen('Flip',window);
               WaitSecs(.2);%1.5
                curr_accuracy = sum(Record.trialOutcome==Record.Response)/trials * 100;
                save(['./data/ID_' num2str(ID) '_record'],'Record','-append')
            end
            trials = trials+1;
            
        end
        
            
        end
        
        if find(keyCode) == ESCKey
            ShowCursor
            ListenChar(0);%Re-enable key access to matlab
            sca
            break
            
        end     
    end
   
    if trials == N_trials + 1
        DrawFormattedText( window,'You are all done!\n\n\n Thank you for playing.','center','center',[0 0 249],300);
       
        Screen('Flip',window);
        WaitSecs(2);
        break
    end
    
    % WaitSecs(1);sca;
end
        ShowCursor
       ListenChar(0); %Re-enable key access to matlab
Screen('CloseAll');
        
%Error Handling
%catch
%     disp('ERROR')
%     ShowCursor
%      ListenChar(0);
%      sca;
 
%end
save(['./data/ID_' num2str(ID) '_record'],'Record','-append')













