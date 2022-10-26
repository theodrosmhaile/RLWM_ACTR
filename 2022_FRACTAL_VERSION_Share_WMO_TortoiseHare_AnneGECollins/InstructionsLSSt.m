%%  RLWM + test phase. Tortoise and the Hare, JoCN 2018

%%% Anne Collins
%%%% UC Berkeley
%%%% November 2014
%%%% annecollins@bberkeley.edu

%%%% RLWM task instructions


function    InstructionsLSSt(w,rect)
debug = 0;
load debugstate
textE{1} = 'Working Memory Reinforcement Learning Task';
textD{1} = 'leertaak';

textE{2} = 'In this experiment, you will see an image on the screen.';
textD{2} = 'In dit experiment zal je steeds een plaatje op het scherm zien.';

textE{3} = 'You need to respond to each image by pressing one of the three buttons on the keyboard, \n\n C, V or B, with your dominant hand.';
textD{3} = 'Bij ieder plaatje moet je reageren door op ÈÈn van de drie toetsen op het toetsenbord te drukken, \n\n C, V of B, met je voorkeurs-hand.';

textE{4} = '[Press SPACEBAR to go through the instructions.]';
textD{4} = '[Druk op de SPATIE om door te gaan met de instructies.]';

textE{5} = 'Your goal is to figure out which button makes you win for each image.';
textD{5} = 'Het is aan jou om uit te vinden welke toets je moet drukken om te winnen bij ieder plaatje.';

textE{6} = 'You will have a few seconds to respond.';
textD{6} = 'Je hebt een paar seconden om te reageren.';

textE{7} = 'Please respond to every image as quickly and accurately as possible.';
textD{7} = 'Probeer bij ieder plaatje zo snel mogelijk, maar met zo weinig mogelijk fouten te antwoorden.';

textE{8} = 'If you do not respond, the trial will be counted as a loss.';
textD{8} = 'Als je niet reageert dan wordt de ronde als verloren beschouwd.';

textE{9} = 'If you select the correct button, you will gain points.';
textD{9} = 'Als je op de juiste toets drukt, dan win je punten.';

textE{10} = 'You can gain 1 point at each trial.';
textD{10} = 'Je kan 1 of 2 punten winnen.';

textE{11} = 'You only win points if you select the correct button for each image!';
textD{11} = 'De computer beslist hoeveel punten je win,';

%textE{12} = 'You may receive a bonus of up to $5 monetary reward, \n\nbased on how many points you win!';
textE{12} = 'Try to win as many points as possible!';
textD{12} = 'maar alleen als je de juiste toets hebt gekozen!';

textE{13} = '';
textD{13} = '';

nblocks = 14;
textE{14} = ['After the practice section, there will be ',num2str(nblocks),' short blocks.'];
textD{14} = ['Na de oefenrondes zijn er nog ',num2str(nblocks),' korte sessies.'];

textE{15} = 'You can rest between each block.';
textD{15} = 'Er is een pauze tussen iedere sessie.';

textE{16} = 'At the beginning of each block, you will be shown the set of images for that block.';
textD{16} = 'Aan het begin van iedere sessie tonen we alle plaatjes die je te zien krijgt tijdens die sessie.';

textE{17} = 'Take some time to identify and name each image!';
textD{17} = 'Neem de tijd om ze correct te kunnen herkennen.';

textE{18} = 'Note the following important rules:';
textD{18} = 'Let op de volgende belangrijke regels.';

textE{19} = '1. There is ONLY ONE correct response for each image.';
textD{19} = '1. Er is ALTIJD maar ……N juist antwoord voor ieder plaatje.';

textE{20} = '2. One response button MAY be correct for multiple images, or not be correct for any image.';
textD{20} = '2. Een antwoord toest KAN juist zijn voor meedere plaatjes of niet juist voor ieder plaatje.';

textE{21} = '3. Within each block, the correct response for each image will not change.';
textD{21} = '3. Het juiste antwoord voor ieder plaatje zal niet veranderen binnen een sessie.';

textE{22} = '4. The more correct responses you give, the faster you will finish the block.';
textD{22} = '4. Hoe vaker je het juiste antwoord geeft, hoe sneller je klaar bent met die sessie.';

textE{23} = 'Press a key to begin practice:';
textD{23} = 'Press a key to begin practice:';

textE{24} = 'Press R to read the instructions again';
textD{24} = 'Druk R om deze instructies nogeens te lezen:';

    text = textE;



% if debug
% [w, rect] = Screen('OpenWindow', 0, 0,[],32,2);
% end



wPtr=w;
Screen('TextSize',wPtr,28);
Screen('TextFont',wPtr,'Times');
Screen('TextStyle',wPtr,0);
Screen('TextColor',wPtr,[255 255 255]);
beginningText1 = text{1};
DrawFormattedText(wPtr,beginningText1,'center','center');
Screen(wPtr, 'Flip');
WaitSecs(3);

done = 1;

while done
% %****BEGINNING OF INSTRUCTIONS****
% %Instructions 1
Screen('TextSize',wPtr,28);
Screen('TextFont',wPtr,'Times');
Screen('TextStyle',wPtr,0);
Screen('TextColor',wPtr,[255 255 255]);


%Instructions1
textI = [text{2},'\n\n\n',text{3},'\n\n\n\n\n',text{4}];
DrawFormattedText(wPtr,textI,'center','center');
Screen(wPtr, 'Flip');
KbWait([],3); %Waits for keyboard(any) press


%Instructions 2
textI = [text{5},'\n\n\n',text{6},'\n\n\n',text{7},'\n\n\n',text{8},'\n\n\n\n\n',text{4}];
DrawFormattedText(wPtr,textI,'center','center')
Screen(wPtr, 'Flip');

KbWait([],3); %Waits for keyboard(any) press

%Instructions 3
textI = [text{9},'\n\n\n',text{10},'\n\n\n',text{11},'\n\n\n',text{12},'\n\n\n\n\n',text{4}];
DrawFormattedText(wPtr,textI,'center','center')
Screen(wPtr, 'Flip');

KbWait([],3); %Waits for keyboard(any) press

% corSound = wavread('corrSound.wav');corSound = [corSound';corSound'];
% incSound = wavread('incorSound.wav');incSound = [incSound';incSound'];
% Snd('Open')
% [keyIsDown, RT, keyCode] = KbCheck();
% while true
%     if keyIsDown 
%         if keyCode(KbName('C'))
%             Snd('Play',corSound);
%             WaitSecs(.5)
%         elseif keyCode(KbName('I'))
%             Snd('Play',incSound);
%             WaitSecs(.5)
%         elseif keyCode(KbName('R'))
%             break;
%         end
%     end % if next key detected
%     [keyIsDown, RT, keyCode] = KbCheck();
% end % endless loop
% Snd('Close')

%Instruction 4
textI = [text{14},'\n\n\n',text{15},'\n\n\n',text{16},'\n\n\n',text{17},'\n\n\n\n\n',text{4}];
DrawFormattedText(wPtr,textI,'center','center');
Screen(wPtr, 'Flip');

KbWait([],3); %Waits for keyboard(any) press

%Instruction 5
textI = [text{18},'\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n',text{4}];
DrawFormattedText(wPtr,textI,'center','center');
Screen(wPtr, 'Flip');

KbWait([],3); %Waits for keyboard(any) press
%Instruction 5
textI = [text{18},'\n\n\n',text{19},'\n\n\n\n\n\n\n\n\n\n\n\n\n\n',text{4}];
DrawFormattedText(wPtr,textI,'center','center');
Screen(wPtr, 'Flip');

KbWait([],3); %Waits for keyboard(any) press
%Instruction 5
textI = [text{18},'\n\n\n',text{19},'\n\n',text{20},'\n\n\n\n\n\n\n\n\n\n\n\n',text{4}];
DrawFormattedText(wPtr,textI,'center','center');
Screen(wPtr, 'Flip');

KbWait([],3); %Waits for keyboard(any) press
%Instruction 5
textI = [text{18},'\n\n\n',text{19},'\n\n',text{20},...
    '\n\n',text{21},'\n\n\n\n\n\n\n\n\n\n',text{4}];
DrawFormattedText(wPtr,textI,'center','center');
Screen(wPtr, 'Flip');

KbWait([],3); %Waits for keyboard(any) press
%Instruction 5
textI = [text{18},'\n\n\n',text{19},'\n\n',text{20},...
    '\n\n',text{21},'\n\n',text{22},'\n\n\n\n\n\n\n\n',text{4}];
DrawFormattedText(wPtr,textI,'center','center');
Screen(wPtr, 'Flip');

KbWait([],3); %Waits for keyboard(any) press

% Propose to repeat instructions
instructionText1 = [text{24},'\n\n\n\n\n\n\n\n\n',text{23}];
DrawFormattedText(wPtr,instructionText1,'center','center');
Screen(wPtr, 'Flip');

[keyIsDown, RT, keyCode] = KbCheck();
repeat = 0;
while repeat==0
    if keyIsDown 
        if keyCode(KbName('R'))
            repeat = 1;
        else
            repeat = -1;
        end
    end % if next key detected
    [keyIsDown, RT, keyCode] = KbCheck();
end % endless loop

if repeat == -1
    done = 0;
end
end

% textI = [text{23}];
% DrawFormattedText(wPtr,textI,'center','center');
% Screen(wPtr, 'Flip');
if debug
%Screen('CloseAll');
end
%****END OF INSTRUCTIONS****
