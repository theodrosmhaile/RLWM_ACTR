PredictWeather
%Keys
ListenChar(2); % prevent keys from writing to matlab
KbName('UnifyKeyNames');
SpaceKey = KbName('space');
RShift = KbName('rightshift');
LShift = KbName('leftshift'); 
ESCKey = KbName('escape');
R_ain = KbName ('r');%Rain Report
S_un  = KbName ('s');%Sun report
resp_distribution(LShift)= 1; %Sun report
resp_distribution(RShift)= 0; %Rain Report

Screen('Preference', 'SkipSyncTests',1);
%Screen('Preference', 'VisualDebugLevel', 3);
Screen('Preference', 'SuppressAllWarnings', 1);
%Screen Size for debug
screenRect = [0,0,1200,700];

%Select screen
use_screen = max(Screen('screens'));
[window, rect] = Screen('OpenWindow', 0, use_screen,screenRect);% screenRect
%may not be necessary 
wht = [255 255 255];
Screen('FillRect',window,wht);
Screen('Flip',window);

%initial instructions
instruct_1 = 'These are your instructions. Press SPACE';
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, 18);
Screen('DrawText', window,instruct_1,floor(rect(3)/4),floor(rect(4)/2));
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
            sca
            
            
            
        end
    end
end
trials = 1;

WaitSecs(.1);

while trials ~= N_trials + 1
    
    %WaitSecs(.5);
    % KbWait;

    %get image stats
        [size_y,size_x] = size(Pattern{7}{trials});
        %compute location on screen
          
        PixelOffsetY = 100;%320;
        PixelOffsetX = 100;%500;
        
        window_stim = [PixelOffsetX,PixelOffsetY, PixelOffsetX + size_x,PixelOffsetY + size_y] ;
        
        ThisImage = Screen('MakeTexture',window,Pattern{7}{trials});
        Screen('DrawTexture',window,ThisImage,[],window_stim)
        Screen('DrawText',window,['Trial Number: ',num2str(trials)] ,50,50,[0 0 0]);
        Screen('Flip',window);
        
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    
    
        
    if keyIsDown
         
        %WaitSecs(5);
        if find(keyCode) == R_ain   ||  find(keyCode) == S_un
            
            Record.keypresses(trials) = seconds;%save reaction time
            ThisTrial_Outcome = Pattern{co  }(Pattern{Lseq}(trials));
           
            if isnan(ThisTrial_Outcome)
                ThisTrial_Outcome = double(rand> .5); %return a 'rain' ~ half the time
            end
            
            Response = resp_distribution(find(keyCode));
            
            %Save data
            Record.trialOutcome(trials) = ThisTrial_Outcome;
            Record.Response(trials) = Response;
            
            if ThisTrial_Outcome == Response
                Screen('DrawText',window,'CORRECT!' ,150,150,[0 255 0]);
                Screen('TextSize', window, 24);
                Screen('Flip',window);
               WaitSecs(2); 
            else
                Screen('DrawText',window,'WRONG!' ,150,150,[255 0 0]);
                Screen('TextSize', window, 24);
                Screen('Flip',window);
               WaitSecs(2);
            end
            trials = trials+1;
            
        end
        
        if find(keyCode) == ESCKey
            sca
            break
            
        end     
    end
    
    if trials == N_trials + 1
        Screen('DrawText',window,'You"re all done! Thank you for playing' ,50,350);
        Screen('Flip',window);
        WaitSecs(10);
        break
    end
    
    % WaitSecs(1);sca;
end

%save('./data/name_record','record'
ListenChar(0); %Re-enable key access to matlab












