function  PredictWeather
%NOTES ON TASK HERE
%This is version 2 of WPT task, current as of 02/21/19.
%Changes: All participants now recieve a set random set of trials loaded
%from Pattern2load.mat
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
trial_im = 8;T_out = 9;
load('./cards/Pattern2load.mat');


% Randomly assign CARD to cue for each Participant
card_names = {'sqr','dia','cir','tri'}; %card names
%Kaiun probs=  0.8   0.6   0.4   0.2
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
    ThisPattern = find(Pattern{pat_ID}(ThisTrial, :));% Get pattern
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
                %return a 'Sun' with predetermined probability
                ThisTrial_Outcome = Pattern{T_out}(trials);
                       
                % ThisTrial_Outcome = double(rand < ThisTrial_prob); OLD
                Response = resp_distribution(find(keyCode));
                
                %Save data
                Record.trialOutcome(trials) = ThisTrial_Outcome;
                Record.Response(trials) = Response;
                
                if ThisTrial_Outcome == Response
                    Screen('DrawText',window,'CORRECT!' ,X_center-85,Y_center,[76 165 76]);
                    Screen('TextSize', window, 24);
                    Screen('Flip',window);
                    WaitSecs(1.2); %1.5
                    curr_accuracy = sum(Record.trialOutcome==Record.Response)/trials * 100;
                    save(['./data/ID_' num2str(ID) '_record'],'Record','-append')
                else
                    Screen('DrawText',window,'WRONG!' ,X_center-85,Y_center,[249 0 0]);
                    Screen('TextSize', window, 24);
                    Screen('Flip',window);
                    WaitSecs(1.2);%1.5
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













