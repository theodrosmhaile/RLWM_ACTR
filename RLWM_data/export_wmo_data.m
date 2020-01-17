%% Reformat WMO data for analysis
clear all
%Notes: 14 learning blocks
%        3 or 6 items per trial: ns
%       39 (8 blocks) or 78 (6 blocks) presentations

Training_headers = {'subject','acc','RT','Code','seq','actionseq','timeseq','trial'};
    Test_headers = {'subject','acc','RT','Code','stim'}; 
%   Import data for each participant
% Path = '/Volumes/GoogleDrive/My Drive/CCDL Shared/Shared/Teddy/MM_WMO'
Path = './raw';
 SavePath = './processed';
%SavePath = '/Volumes/GoogleDrive/My Drive/CCDL Shared/Shared/Teddy/MM_WMO'
 Thesefiles =  csvread('wmo_uCLIMB_subjects.csv');%'Subjects_uclimb_and_subjectpool.csv');
%258852;%
 dir([Path,'/*ID*.mat']);
    Training = [];
    Test = [];
    missing_dat = [];
for n =1: length(Thesefiles)
    %Read in matfile
    try
    load([Path,'/','WMO_ID',num2str(Thesefiles(n))]);
    %Simplify
    
    for t = 1 : length(dataT)-1 %The 15th item is blearrgghh
        thisTrial  = ones(length(dataT{t}.timeseq),1) * length(dataT{t}.timeseq);
        thisParticipant = ones(length(dataT{t}.timeseq),1) * Thesefiles(n);
        Training = [Training;thisParticipant cell2mat(struct2cell(dataT{t}))' ,thisTrial] ;
   
    end 
    
    thisParticipant = ones(length(cell2mat(struct2cell(dataTest))), 1)* Thesefiles(n);%This participant
    Test = [Test;thisParticipant cell2mat(struct2cell(dataTest))' matricetest.stimBlockSeq];
   
       %Save as csv
       
%         writetable(array2table(Training,'VariableNames',Training_headers), ...
%            ['train_' Thesefiles(n).name(1:end-4)]) 
%        writetable(array2table(Test,'VariableNames',Test_headers), ...
%            ['test_' Thesefiles(n).name(1:end-4)])        


   % dlmwrite([Path,'/',Thesefiles(i).name(4:end-11),'_wpt.txt'],...
       % Training,'delimiter',',','precision',10)
    catch
       missing_dat = [missing_dat,Thesefiles(n)] ;
    end 
end
%Before running script above edit output name below
%Export
%cd(SavePath)
 %writetable(array2table(Training,'VariableNames',Training_headers), ...
  %          'wmo_training_uclimb') 
   %    writetable(array2table(Test,'VariableNames',Test_headers), ...
    %       'wmo_test_uclimb')        

       %writetable(array2table(missing_dat','VariableNames',"MissingSubjects"), ...
        %   'wmo_MissingWinter19Pooldata')
   %cd(Path);    
 %clearvars Record Pattern TempFile
