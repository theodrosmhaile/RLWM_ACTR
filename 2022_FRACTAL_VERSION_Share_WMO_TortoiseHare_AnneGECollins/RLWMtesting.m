%%  RLWM + test phase. Tortoise and the Hare, JoCN 2018

%%% Anne Collins
%%%% UC Berkeley
%%%% November 2014
%%%% annecollins@berkeley.edu

% PST test phase running


function [dataTest]=RLWMtesting(stimBlockSeq,stimNumSeq,stimCorA,Actions,stSets,stimuli,w,rect);
% stimBlockSeq contains for each test trial stimulus the block number in which 
%the stimulus was learned
% stimNumSeq contains for each test trial stimulus the stim ID number in which 
%the stimulus was learned
% stimCorA contains for each test trial stimulus the correct action number
% for this stimulus
%stSets is the image folder number for each learning block
%stimuli{b}(i) is the image number from that folder for stim i in block b
% w and rect are screen info

%dataTest is a structure with arrays containing RT, Cor/Incorrect, and
%chosen action for each trial

directory = 'GroupedExpeData';

debug = 0;
load debugstate
nA = 3;
dataTest=[];


% Stim presentation time
prestime =1.5;
fj1 = 0;

% FB presentation time 
FBprestime = .5;%.6;
fj2 = 0;%+.4;

% interstimulus interval
ISI= .5;%.8;
fj3 = 0;%.4;

text{1} =  'We are now going back to the first learning task for one final block!';
text{2} = ['In this block, you will see again the images you saw in previous blocks.',...
    '\n\n Use the information you learned previously to try to win points, by pressing C, V or B.\n\n',...
    '\n\nYou will not see the points you win at each trial, but we are still counting them,'...
    '\n\nso try to select the correct action for each image to win points!'];
text{3} = ['[Call the experimenter if you have questions. \n\n',...
    'Otherwise, press a key to continue.]'];
text{4} = '';
text{5} = '0';
text{6} = 'End of block ';
text{7} = 'End of the experiment! \n\n\nThank you for your participation!';
text{8} = 'Too slow';

% --------------- 
% open the screen
% ---------------
time = 0;

try
    
    
    % get screen parameters
    Screen('Preference', 'SkipSyncTests',1);
    if debug 
    screenRect = [0,0,1250,800]; % screen for debugging
    else
    screenRect = []; % full screen
    end
    [w, rect] = Screen('OpenWindow', 0, 0,screenRect,32,2);
    % create screen center, central square
    center=[rect(3)/2 rect(4)/2];
    crect = CenterRectOnPoint([0 0 200 200],rect(3)/2,rect(4)/2);
    % 400 pixel rectangle for presentation. Adjust at will
    crectP = CenterRectOnPoint([0 0 400 400],rect(3)/2,rect(4)/2);
    
    
    HideCursor;	% Hide the mouse cursor
    %ListenChar(2);
    
    Screen('TextFont', w , 'Times');
    Screen('TextSize', w, 32 );
    

    Tinitial=GetSecs;
        
    dataT=[];

    % Create a matrix to store the stimuli
    SMat=zeros(300,300,3,6,7);% stimuli, block numi=1:
    taille=length(stimBlockSeq);
    for it=1:taille%,stimNumSeq,stimCorA
        b = stimBlockSeq(it);
        i = stimNumSeq(it);
        % get the specific stimuli numbers
        sordre=stimuli{b};%%%Quelles images dans la famille
        % get the specific stimulus type
        Type=stSets(b);%%%%Famille d'images
        % load stimuli and store them in matrix SMat for display
        load(['imagesRLWM/images',num2str(Type),'/image',num2str(sordre(i))]);%%%load des stimuli
        SMat(:,:,:,i,b)=X;
    end
        
        
    % Stim sets presentation in previously built boxes
    Screen('FillRect', w,0)
    Screen('TextColor',w,[255 255 255]);
    textI = [text{1},'\n\n\n',text{2},'\n\n\n',text{3}];        
    DrawFormattedText(w,textI,'center','center');
    Screen('Flip', w);

    WaitSecs(.2);
    kdown=0;
    while kdown==0;
        kdown=KbCheck;
    end
    Screen('FillRect', w, 0)
    Screen('Flip', w);
    WaitSecs(2)
    Screen('TextSize', w, 75 );


    % set up criterion
    t=0;
    DCor=[];
    DCode=[];
    DRT=[];

    if debug;tmax = 10; else tmax = taille;end

    while t<tmax
        t=t+1;
        time = time+1;
        %get trial's stimulus
        b = stimBlockSeq(t);
        i = stimNumSeq(t);
        acor=stimCorA(t);
        imaget=SMat(:,:,:,i,b);

        js = [fj1*rand FBprestime+fj2*rand ISI+fj3*rand];
        [RT,code,cor]=singleTrialTest(w,rect,crectP,Actions,text,imaget,acor,js);


        timeseq(t) = time;
        DCor(t)=cor;
        DRT(t)=RT;
        DCode(t)=code;
    end % ending sessions

    % build output structure with all info in
    dataTest.Cor=DCor;
    dataTest.RT=DRT;
    dataTest.Code=DCode;
    data.timeseq = timeseq;
    dataT{b}=data;

    % Give block feedback on time saved
    Screen('TextSize', w, 32 );
    Screen('FillRect', w,0)
%     textI = [text{6}, num2str(b),'\n\n\n\n\n\n\n',...
%         text{3}];
%     DrawFormattedText(w,textI,'center','center');
    textI = ['End of block. \n\n You were correct ',num2str(sum(DCor==1)),...
        ' times out of ',num2str(t),' trials! \n\n\n\n\n\n\n [Press a key to finish.]'];
    DrawFormattedText(w,textI,'center','center');
    %Screen(w,'DrawText',,(rect(3)/2)-150,rect(4)/2-100,255);
    %Screen(w,'DrawText',['Proportion of time saved: ',num2str(gain),' / 100'],(rect(3)/2)-400,rect(4)/2,255);
    %Screen(w,'DrawText','Press a key to continue',(rect(3)/2)-400,rect(4)/2+150,255);
    Screen('Flip', w);kdown=0;


    while kdown==0;
        kdown=KbCheck;
    end
    Screen('FillRect', w, 0)
    Screen('Flip', w);
    WaitSecs(2);
    TFinal=GetSecs;
    bonus = computeBonus(dataT);
    
    Screen('FillRect', w,0)
     textI = text{7};
     DrawFormattedText(w,textI,'center','center');
%         Screen(w,'DrawText','End of main part.',(rect(3)/2)-150,rect(4)/2-100,255);
%     Screen(w,'DrawText',['It lasted ',num2str(minutes),' min, ',num2str(secondes),' sec.'],(rect(3)/2)-150,rect(4)/2,255);
     
    Screen('Flip', w);
    WaitSecs(2); 
        
        
    ShowCursor;
    %ListenChar(0);
    Screen('CloseAll');
    Snd('Close')
catch
    ShowCursor;
    %ListenChar(0);
    Screen('CloseAll');
    Snd('Close')
    rethrow(lasterror);
end




end



function bonus = computeBonus(dataT)

w = [];
for b = 1:length(dataT)-1
    if ~isempty(dataT{b})
    w = [w dataT{b}.winnings];
    end
end

% mean winnings
perf = mean(w);
% rescale to 0/1
perf = (min(max(perf,1),1.5)-1)/.5;

bonus = .5+1.5*perf;
    bonus = floor(10*bonus)/10;

end