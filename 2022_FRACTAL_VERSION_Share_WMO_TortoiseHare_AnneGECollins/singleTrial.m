%%  RLWM + test phase. Tortoise and the Hare, JoCN 2018

%%% Anne Collins
%%%% UC Berkeley
%%%% November 2014
%%%% annecollins@bberkeley.edu


function [RT,code,cor,winnings]=singleTrial(w,rect,crectP,Actions,text,imaget,acor,corFB,js)

prestime =1.5;

red = [255 0 0];
green = [0 255 0];
%blue =[0 0 255];% 

% present it
Screen(w,'FillPoly',0, [0 0;0 rect(4);rect(3) rect(4);rect(3) 0]);%%Ecrean total noir
Screen(w,'PutImage',imaget,crectP);
Screen('Flip', w);

% wait for a key press
tstart=GetSecs;
press=0;
RT=-1;
code=-1;
before = 0;
[kdown]=KbCheck;
before = find(kdown);
while GetSecs<tstart + prestime & press==0
    [kdown,secs,code]=KbCheck;

    if kdown == 1;
        press = 1;
        if press == 1;
            RT = secs-tstart;
            keycode = find(code==1);
            if length(keycode)==1 & intersect(keycode,Actions);  % if buttons
                code = find(keycode == Actions);
            else
                code=-1;
                press = 0; %% this is so other keys don't count as non answers
            end
        end
    end
end
if before
    code = -1;
    RT = -1;
    j1 = prestime;
else
j1 = js(1);
end
WaitSecs(j1);

%deliver feedback if legal keypress ;occured
if code==1 | code==2 | code==3;
    if code==acor
        cor=1;
        word=text{4};
        couleur = green;
    else
        cor=0;
        word=text{5};
        couleur = red;
    end


    Screen('TextFont',w,'Arial');
    Screen('TextSize', w, 75 );
    if cor == 1 %also add winnings if correct
        %flip weighted coin to determine if +2 or + 1
        winnings = corFB; 
        if winnings == 2
        %plusWhat = [word,'+ ',num2str(winnings)]; %converts 1 to +2, and 0 to +1
        plusWhat = '!!!   + 2   !!!';
        couleur = green;
        else
            plusWhat = '+ 1';
        end
        Screen('TextColor',w,couleur);
        DrawFormattedText(w,plusWhat,'center','center'); %display +1 or +2 also

    else
        Screen('TextColor',w,couleur);
        DrawFormattedText(w,word,'center','center');
        winnings = 0;
    end
    %Screen(w,'DrawText',word,center(1)-150,center(2)-50,255);
    Screen('Flip', w);

else
    %no/illegal keypress: deliver no reward, encode as -1
    Screen('TextSize', w, 75 );
    Screen(w,'FillPoly',0, [0 0;0 rect(4);rect(3) rect(4);rect(3) 0]);%%Full black screen
    word = text{8};%,center(1)-150,center(2)-50,255);
    Screen('TextColor',w,red);
    DrawFormattedText(w,word,'center','center');
    Screen('Flip', w);

    winnings = -1;
    code=-1;
    cor=-1;
    RT=-1;
end
WaitSecs(max(0,js(2)));


Screen('TextColor',w,[255 255 255]);
Screen(w,'FillPoly',0, [0 0;0 rect(4);rect(3) rect(4);rect(3) 0]);%%Ecrean total noir
Screen('TextSize', w, 32 );
DrawFormattedText(w,'+','center','center');
Screen('Flip', w);

WaitSecs(js(3));