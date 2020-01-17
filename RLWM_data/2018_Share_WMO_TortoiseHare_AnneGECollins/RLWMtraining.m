%%  RLWM + test phase. Tortoise and the Hare, JoCN 2018

%%% Anne Collins
%%%% UC Berkeley
%%%% November 2014
%%%% annecollins@bberkeley.edu
%%%% Training Code


function RLWMtraining(subject_id)
debug = 1;
load debugstate

rand('twister',sum(100*clock));
nA=3;

% Stim presentation time
prestime =1.5;
fj1 = 0;

% FB presentation time 
FBprestime = .5;%.6;
fj2 = 0;%+.4;

% interstimulus interval
ISI= .5;%.8;
fj3 = 0;%.4;

% key codes
buttonz = [KbName('C'),KbName('V'),KbName('B')];
Actions = Shuffle(buttonz);  % j k l the required response button codes(see  Kbname)



% --------------- 
% open the screen
% ---------------

text{1} =  'Block ';
text{2} = 'Take some time to identify the images for this block.';
text{3} = '[Press a key to continue.]';
text{4} = '';
text{5} = '0';
text{6} = 'End of block ';
text{8} = 'No valid answer';
text{9} = 'End of training.';

time=0;
try
    Screen('Preference', 'SkipSyncTests',1);
    if debug 
    screenRect = [0,0,1250,800]; % screen for debugging
    else
    screenRect = []; % full screen
    end
    [w, rect] = Screen('OpenWindow', 0, 0,screenRect,32,2);
    
    HideCursor;	% Hide the mouse cursor
    %ListenChar(2);
    
    % Give instructions
    InstructionsLSSt(w,rect);
    
    % Create screen center, center square
    center = [rect(3)/2 rect(4)/2];
    crect = CenterRectOnPoint([0 0 200 200],rect(3)/2,rect(4)/2);
    % 400 pixel rectangle for presentation. Adjust at will
    crectP = CenterRectOnPoint([0 0 400 400],rect(3)/2,rect(4)/2);
    
    % Create display boxes
    x=rect(3)/7;
    x=min(x,rect(4)/5);
    boitesPresentation=[
                        3*x 1*x 4*x 2*x;
                        3*x 3*x 4*x 4*x];
    
   
    Tinitial=GetSecs;
    
    % 1 training block
    for b = 0
        % Get stim set size
        nS=2;
        % Create a matrix to store the stimuli
        SMat=zeros(300,300,3,nS);
        % load stimuli and store them in matrix SMat for display
        for i=1:nS
            load(['imagesRLWM/TrainingImages/image',num2str(i)]);%%%load des stimuli
            SMat(:,:,:,i)=X;
        end
        
        %%%Get stim sequence for block b
        stimseq=Shuffle(repmat([1:2],1,25));
        actionseq=stimseq;
        taille=length(stimseq);
                
        %%%setup
        FBprobSeq = 0*ones(1,length(stimseq));
        
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
        
        critere=0;
        while t<tmax & critere<1
            t=t+1;
            time = time+1;
            %get trial's stimulus
            sti=stimseq(t);
            acor=actionseq(t);
            corFB=1+(rand<FBprobSeq(t));
            imaget=SMat(:,:,:,sti);
            
            js = [fj1*rand FBprestime+fj2*rand ISI+fj3*rand];
            [RT code cor winnings]=singleTrial(w,rect,crectP,Actions,text,imaget,acor,corFB,js);
            

            timeseq(t) = time;
            DCor(t)=cor;
            DRT(t)=RT;
            DCode(t)=code;
            DWinnings(t) = winnings;
            DStimType(t) = FBprobSeq(t); %
       
            if t>15
                perf = mean(DCor(t-9:t));
                critere = perf>=.8;
            else
                critere = 0;
            end
        end
        data = [];
        data.temps=t;
        data.Cor=DCor;
        data.RT=DRT;
        data.Code=DCode;
        data.seq=stimseq;
        data.actionseq=actionseq;
        data.timeseq = timeseq;
        data.winnings = DWinnings;
        data.FBSequence = DStimType;
        data.buttonz = Actions;
        
        directory = 'GroupedExpeData';
        save([directory,'/WMOTraining_Su',num2str(subject_id)],'data');
        
        % give block feedback 
        Screen('TextFont',w,'Arial');
        Screen('TextSize', w, 32 );
        Screen('FillRect', w,0)
        textI = ['End of practice! \n\n\n\n\n\n\n',...
            text{3}];
        DrawFormattedText(w,textI,'center','center');
            
%         Screen(w,'DrawText',['End of block ',num2str(b)],(rect(3)/2)-150,rect(4)/2-100,255);
%         Screen(w,'DrawText','Press a key to continue',(rect(3)/2)-400,rect(4)/2+150,255);
        Screen('Flip', w);kdown=0;
        while kdown==0;
            kdown=KbCheck;
        end
        Screen('FillRect', w, 0);
        Screen('Flip', w);
        WaitSecs(2);
        
        
    end
    TFinal=GetSecs;
    
    Duree=TFinal-Tinitial;
    minutes=floor(Duree/60);
    secondes=floor(Duree)-60*minutes;
    Screen('FillRect', w,0)
    Screen(w,'DrawText',text{9},(rect(3)/2)-150,rect(4)/2-100,255);
    %Screen(w,'DrawText',['It lasted ',num2str(minutes),' min, ',num2str(secondes),' sec.'],(rect(3)/2)-150,rect(4)/2,255);
        
    ShowCursor;
    %ListenChar(0);
    Snd('Close')
    Screen('CloseAll');
catch
    ShowCursor
    %ListenChar(0);
    Screen('CloseAll');
    Snd('Close')
    rethrow(lasterror);
end




end

% sound making function
function noteInterne(freq, duree, echant)
%%% note(freq, duree) joue une série de notes de fréquences contenues dans
%%% le tableau freq et de durée dans le tableau duree
%%% (en s) (on peut rajouter en 3eme argument la freq d'échantillonage, par
%%% défaut 8192Hz

if nargin==2, echant=4.5*8192; end
out=[];
for n=1:length(duree);

sery=zeros(1,sum(floor(echant*duree(n))));

ls=0;
sery(ls+1:ls+floor(echant*duree(n)))=sin(2*pi*freq(n)*[1/echant:1/echant:duree(n)]);
ls=ls+floor(echant*duree(n));

out=[out sery];
end

%player=audioplayer(sery, echant);
sound(out,echant);
end
