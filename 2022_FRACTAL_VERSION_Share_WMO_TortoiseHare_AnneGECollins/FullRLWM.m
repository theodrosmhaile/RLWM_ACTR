%%  RLWM + test phase. Tortoise and the Hare, JoCN 2018

%%% Anne Collins
%%%% UC Berkeley
%%%% November 2014
%%%% annecollins@bberkeley.edu

%%%% Actual experiment code.

function [dataT,w,rect]=FullRLWM(blocks,stSets,stSeqs,Actions,stimuli,rules,subject_id,local_sujet)

directory = 'GroupedExpeData';

debug = 0;
load debugstate
nA = 3;
dataT=[];

% create input file to be saved within subject's output data
Entrees=[];
Entrees.local_sujet = local_sujet;
Entrees.blocks=blocks;
Entrees.stSets=stSets;
Entrees.stSeqs=stSeqs;
Entrees.Actions=Actions;
Entrees.stimuli=stimuli;
Entrees.rules=rules;
dataT{length(blocks)+1}=Entrees;


% Stim presentation time
prestime =1.5;
fj1 = 0;

% FB presentation time 
FBprestime = .5;%.6;
fj2 = 0;%+.4;

% interstimulus interval
ISI= .5;%.8;
fj3 = 0;%.4;

text{1} =  'Block ';
text{2} = 'Take some time to identify the images for this block.';
text{3} = '[Press a key to continue.]';
text{4} = '';
text{5} = '0';
text{6} = 'End of block ';
text{7} = 'End of Learning phase! \n\n\nYou are almost done!';
text{8} = 'No valid answer';

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
    
    % create stim sample display boxes
    x=rect(3)/7;
    x=min(x,rect(4)/5);
    boitesPresentation=[1*x 1*x 2*x 2*x;
                        3*x 1*x 4*x 2*x;
                        5*x 1*x 6*x 2*x;
                        1*x 3*x 2*x 4*x;
                        3*x 3*x 4*x 4*x;
                        5*x 3*x 6*x 4*x];
    
    HideCursor;	% Hide the mouse cursor
    %ListenChar(2);
    
    Screen('TextFont', w , 'Times');
    Screen('TextSize', w, 32 );
    

    Tinitial=GetSecs;
    if debug
        torun = [1,length(blocks)];
    else
        torun = [1:length(blocks)];
    end
        
    %Run experiment for 13 blocks
    for b=torun
        data=[];
        
        % Get stim set size
        nS=blocks(b);%%%Combien d'images
        % Create a matrix to store the stimuli
        SMat=zeros(300,300,3,nS);
        % get the specific stimuli numbers
        sordre=stimuli{b};%%%Quelles images dans la famille
        % get the specific stimulus type
        Type=stSets(b);%%%%Famille d'images
        % load stimuli and store them in matrix SMat for display
        for i=1:nS
            load(['imagesRLWM/images',num2str(Type),'/image',num2str(sordre(i))]);%%%load des stimuli
            SMat(:,:,:,i)=X;
        end
        
        %%%Get stim sequence for block b
        stimseq=stSeqs{b};
        taille=length(stimseq);
        
        %%%Get correct action sequence for block b, using predifined rules
        actionseq=0*stimseq;
        TS=rules{b};
        for i=1:nS
            actionseq(stimseq==i)=TS(i);
        end
        TMin=nS*3*3;
        
        %%%Get feedback prob sequence for block b - see lines 94:97 for
        
        %2/24/14 - changed from 75% for A to 80%
        
        %%%setup
        
        % Stim sets presentation in previously built boxes
        Screen('FillRect', w,0)
        Screen('TextColor',w,[255 255 255]);
        textI = [text{1},num2str(b),'\n\n\n',text{2},'\n\n\n',text{3}];        
        DrawFormattedText(w,textI,'center','center');
        Screen('Flip', w);
        
        WaitSecs(.2);
        kdown=0;
        while kdown==0;
            kdown=KbCheck;
        end
        
        Screen('FillRect', w, 0)
        for tt=1:nS
            Screen(w,'PutImage',SMat(:,:,:,tt),boitesPresentation(tt,:))
        end
        
        Screen('Flip', w);
        
        % wait for key press to begin block
        WaitSecs(2)
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
        Jitters = [];
        timeseq = [];
        DWinnings = [];
        DStimType = [];
        
        if debug;tmax = 10; else tmax = taille;end
        
        while t<tmax
            t=t+1;
            time = time+1;
            %get trial's stimulus
            sti=stimseq(t);
            acor=actionseq(t);
            corFB=1;
            imaget=SMat(:,:,:,sti);
            
            js = [fj1*rand FBprestime+fj2*rand ISI+fj3*rand];
            [RT,code,cor]=singleTrial(w,rect,crectP,Actions,text,imaget,acor,corFB,js);
            

            timeseq(t) = time;
            DCor(t)=cor;
            DRT(t)=RT;
            DCode(t)=code;
        end % ending sessions

        % build output structure with all info in
        data.Cor=DCor;
        data.RT=DRT;
        data.Code=DCode;
        data.seq=stimseq;
        data.actionseq=actionseq;
        data.timeseq = timeseq;
        dataT{b}=data;
        
        % Give block feedback on time saved
        Screen('TextSize', w, 32 );
        Screen('FillRect', w,0)
        textI = [text{6}, num2str(b),...
            '\n\nYou chose correctly ',num2str(sum(DCor==1)),...
            ' times out of ',num2str(t),' trials!',...
            '\n\n\n\n\n\n\n',text{3}];
        DrawFormattedText(w,textI,'center','center');
        %Screen(w,'DrawText',['End of block ',num2str(b)],(rect(3)/2)-150,rect(4)/2-100,255);
        %Screen(w,'DrawText',['Proportion of time saved: ',num2str(gain),' / 100'],(rect(3)/2)-400,rect(4)/2,255);
        %Screen(w,'DrawText','Press a key to continue',(rect(3)/2)-400,rect(4)/2+150,255);
        Screen('Flip', w);kdown=0;
        
        
        while kdown==0;
            kdown=KbCheck;
        end
        Screen('FillRect', w, 0)
        Screen('Flip', w);
        WaitSecs(2);
        save([directory,'/WMO_ID',num2str(subject_id)],'dataT')
        
    end
    TFinal=GetSecs;
    %bonus = computeBonus(dataT);
    
    Screen('FillRect', w,0)
     textI = text{7};
     DrawFormattedText(w,textI,'center','center');
%         Screen(w,'DrawText','End of main part.',(rect(3)/2)-150,rect(4)/2-100,255);
%     Screen(w,'DrawText',['It lasted ',num2str(minutes),' min, ',num2str(secondes),' sec.'],(rect(3)/2)-150,rect(4)/2,255);
     
    Screen('Flip', w);
    WaitSecs(2); 
        
        
    ShowCursor;
    %ListenChar(0);
%     Screen('CloseAll');
%     Snd('Close')
catch
    ShowCursor;
    %ListenChar(0);
    Screen('CloseAll');
    Snd('Close')
    rethrow(lasterror);
end




end


% 
% function bonus = computeBonus(dataT)
% 
% w = [];
% for b = 1:length(dataT)-1
%     if ~isempty(dataT{b})
%     w = [w dataT{b}.winnings];
%     end
% end
% 
% % mean winnings
% perf = mean(w);
% % rescale to 0/1
% perf = (min(max(perf,1),1.5)-1)/.5;
% 
% bonus = .5+1.5*perf;
%     bonus = floor(10*bonus)/10;
% 
% end