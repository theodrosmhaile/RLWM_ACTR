%%  RLWM + test phase. Tortoise and the Hare, JoCN 2018

%%% Anne Collins
%%%% UC Berkeley
%%%% November 2014
%%%% annecollins@bberkeley.edu



function runRLWM %(subject_id)

subject_id = input('Participant number:');
starttime=datetime;
RLWMtraining(subject_id);
endpracticetime=datetime;

local_sujet = 1+rem(subject_id-1,10);

folder = pwd;
folder = [folder,'/NewInputsLSSt/'];
load([folder,'Matrice_sujet',num2str(local_sujet)]);
%cd ..

% block/setsize assignation
blocks = matrice.blocks;

% block/stimset identity assignation
stSets = matrice.stSets;
% block/stim sequence assignation
stSeqs=matrice.stSeqs;

% [1 2 3]-->keys mapping
Actions=matrice.Actions;%%%%(modify: some keyboards have different keynumbers)
Actions(Actions == 13) = KbName('C');%6
Actions(Actions == 14) = KbName('V');%25
Actions(Actions == 15) = KbName('B');%5
% specific stimuli identity
stimuli=matrice.stimuli;

% stimulus/correct action mapping
rules=matrice.rules;
% get PST phase inputs
%testStimsSeq = matrice.testStimsSeqs;

save allworkspacetmp
% If bugs out before training, run:
% load allworkspacetmp
% [w, rect] = Screen('OpenWindow', 0);

% run experiment with these inputs: RLWM phase 
[dataT,w,rect] = FullRLWM(blocks,stSets,stSeqs,Actions,stimuli,rules,subject_id,local_sujet);

endlearningtime=datetime;

save allworkspacetmp
% If bugs out before N-back, run:
% load allworkspacetmp
% [w, rect] = Screen('OpenWindow', 0);

%PST test phase
% cd ExperimentDesign_NBackTask-master/
% [dataNback,labelsNback]=Run_N_back(w,rect);
% cd ..
% endNback=datetime;
% Can include a short independent task here before test (we had N-back in
% our paper)
%% short N-back task




% End Nback task
%% Testing Block
stimBlockSeq=matricetest.stimBlockSeq;
stimNumSeq=matricetest.stimNumSeq;
stimCorA=matricetest.stimCorA;

[dataTest] = RLWMtesting(stimBlockSeq,stimNumSeq,stimCorA,Actions,stSets,stimuli,w,rect);
endtestingtime=datetime;

% save in subject specific file
directory = 'GroupedExpeData';

save([directory,'/WMO_ID',num2str(subject_id)],...
    'dataT','matrice','dataTest','matricetest',...
    'starttime','endpracticetime','endlearningtime','endNback','endtestingtime')
%,'dataNback','labelsNback'

end
