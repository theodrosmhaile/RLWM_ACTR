%% take out st sets not to use
clear all

stSetsNotToUse = [1 8 16 19];
for si = 2:120
   load(['NewMatrice_Sujet_',num2str(si),'.mat']) 
   if intersect(stSetsNotToUse,matrice.stSets)
       %matrice.stSets
       [~,Im] = intersect(matrice.stSets,stSetsNotToUse);
       pickfrom = setdiff(1:19,[matrice.stSets stSetsNotToUse]);
       pickfrom = Shuffle(pickfrom);
       
       matrice.stSets(Im) = pickfrom(1:length(Im));
       for i = Im'
           matrice.allStim(matrice.allStim(:,1)==i,4)=matrice.stSets(i);
       end
%       boum
   end
   
   for t = 1:length(matrice.testStimsSeqs)
       for side = 1:2
            matrice.testStimsSeqs{t}(4,side) = matrice.allStim(matrice.pairs(t,side),4);
       end
   end
    save(['NewMatrice_Sujet_',num2str(si),'.mat'],'matrice')
end


%% % make a second session, controlled for first session

clear all

stSetsNotToUse = [1 8 16 19];
stSetsToKeep = setdiff(1:19,stSetsNotToUse);

for suj = 2:120

load(['NewMatrice_Sujet_',num2str(suj)])

design = [];
design{1} = matrice;

Bl1M = matrice; matrice = [];
matrice.blocks = Bl1M.blocks;

stSets = nan(1,length(matrice.blocks));
stimuli = cell(1,length(matrice.blocks));

% find set size 5 blocks, assign them new images
T = find(matrice.blocks==5);
% pick from admissible unused sets of images in first session
touse = Shuffle(setdiff(stSetsToKeep,Bl1M.stSets));
stSets(T) = touse;
% same image numbers
for t = T
stimuli{t} = Bl1M.stimuli{t};
end

% find set size 3 blocks, assign them same folders, new images in folder
T = find(matrice.blocks==3);
% pick from admissible unused sets of images in first session
touse = Bl1M.stSets(T);
stSets(T) = touse;
% complementary image numbers
for t = T
stimuli{t} = Shuffle(setdiff(1:6,Bl1M.stimuli{t}));
end

% find set size 4 blocks, assign them folders of set size 2 blocks, new images in folder
T2 = find(matrice.blocks==2);
T4 = find(matrice.blocks==4);
% pick from admissible unused sets of images in first session
touse2 = Bl1M.stSets(T2);
stSets(T4) = touse2(1:2);
stSets(T2) = [Bl1M.stSets(T4) touse2(end-1:end)]; 
% complementary image numbers
i =0;
for t = T4
    i = i+1;
stimuli{t} = Shuffle(setdiff(1:6,Bl1M.stimuli{T2(i)}));
stimuli{T2(i)} = Shuffle(setdiff(1:6,Bl1M.stimuli{t}));
end
touse = Shuffle(setdiff(1:6,Bl1M.stimuli{T2(3)}));
stimuli{T2(3)} = touse(1:2);
touse = Shuffle(setdiff(1:6,Bl1M.stimuli{T2(4)}));
stimuli{T2(4)} = touse(1:2);

matrice.stSets = stSets;
matrice.stSeqs = Bl1M.stSeqs;
matrice.stimuli = stimuli;
matrice.R = Bl1M.R;
matrice.Actions = Bl1M.Actions;
matrice.rules = Bl1M.rules;
matrice.stVals = Bl1M.stVals;

% create the allStim matrix with all stimuli characteristics (only images
% changed - folder and image number)
allStim = Bl1M.allStim;

t = 0;
for b = 1:length(matrice.blocks)
    for s=1:matrice.blocks(b)
        t = t+1;
        thisStim = allStim(t,:);
        if thisStim(1)~=b
            disp('wrong block');boum
        end
        if thisStim(2)~=s
            disp('wrong stim #');boum
        end
        if thisStim(5)~=matrice.blocks(b)
            disp('wrong set size');boum
        end
        if thisStim(6)~=matrice.stVals{b}(s)
            disp('wrong value');boum
        end
        if thisStim(7)~=matrice.rules{b}(s)
            disp('wrong action');
        end
        % 3rd column is image number
        thisStim(3) = matrice.stimuli{b}(s);
        % 4th column is folder number
        thisStim(4) = matrice.stSets(b);
        allStim(t,:) = thisStim;
    end
end

testOld = 100*Bl1M.allStim(:,4)+Bl1M.allStim(:,3);l1 =length(unique(testOld));
testNew = 100*allStim(:,4)+allStim(:,3);l2 =length(unique(testNew));
l3=length(unique([testOld;testNew]));
[l1 l2 l3]

matrice.allStim = allStim;
matrice. allStimCol = Bl1M.allStimCol;
matrice.FBseq = Bl1M.FBseq;
matrice.pairs =Bl1M.pairs;

% use allStim to change the sequence of images to display in test phase
testStimsSeqs = Bl1M.testStimsSeqs;
for t = 1:length(testStimsSeqs)
       for side = 1:2
           % folder number (4th row)
            testStimsSeqs{t}(4,side) = matrice.allStim(matrice.pairs(t,side),4);
            % image number (5th row)
            testStimsSeqs{t}(5,side) = matrice.allStim(matrice.pairs(t,side),3);
       end
end
matrice.testStimsSeqs = testStimsSeqs;
matrice.tst_stimuli_columns = Bl1M.tst_stimuli_columns;
matrice.tst_stimuli_rows = Bl1M.tst_stimuli_rows;

design{2} = matrice;


save(['NewMatrice_Sujet_',num2str(suj),'.mat'],'design')
end



%% counterbalance subjects

clear all
for i = 0:29
    load(['NewMatrice_Sujet_',num2str(4*i+3)]);
    
    for j = 1:4
        save(['NewMatrice_Sujet_',num2str(4*i+j)],'design');
    end
end
    
    