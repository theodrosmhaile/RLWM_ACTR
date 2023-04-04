clear all
N_trials   = 200;%0; %Number of trials to administer to participants
N_patterns = 14; %Number of possible combinations from Kaiun_li 2016

%Pattern cell contains the following data (just index assignment):
%                                           correct outcome
num_ID = 1; prob = 2; freq = 3; pat_ID = 4; co = 5;co_prob = 6; Lseq = 7;
trial_im = 8; T_out = 9;
Pattern{num_ID} = 1:N_patterns;

%P = probability, from Kaiun_li 2016
Pattern{prob} = [.095 % 1110
    .045 % 1101
    .13  % 1100
    .045 % 1011
    .06  % 1010
    .03  % 1001
    .095 % 1000
    .095 % 0111
    .03  % 0110
    .06  % 0101
    .045 % 0100
    .13  % 0011
    .045 % 0010
    .095];%0001

% Pattern identitiy is based on its numerical location in this vector
Pattern{pat_ID} = [1 2 3 0
    1 2 0 4
    1 2 0 0
    1 0 3 4
    1 0 3 0
    1 0 0 4
     1 0 0 0
    0 2 3 4
    0 2 3 0
    0 2 0 4
    0 2 0 0
    0 0 3 4
    0 0 3 0
    0 0 0 4];
Pattern{co_prob} = [.895
    .778
    .923
    .222
    .833
    .5
    .895
    .105
    .5
    .167
    .556
    .077
    .444
    .105];
Pattern{co}   = [1 
                 1
                 1
                 0
                 1
                 nan
                 1
                 0
                 nan
                 0
                 1
                 0
                 0
                 0];
             

Pattern{freq} = Pattern{prob} * N_trials
Pattern{Lseq}    =[];
Pattern{T_out}    =[];%initialize
%Feb 19/19 Update: A single saved random pattern of trials is used for
%everyone.


for p = 1:length(Pattern{num_ID})
    %dumb code but expands frequency
    TempExp = ones(Pattern{freq}(p),1);
    size(TempExp,1)
    p
    Pattern{Lseq} = vertcat(Pattern{Lseq},TempExp * Pattern{num_ID}(p));
    %Expand the outcome matrix as well
    
end
testMat=ones(200,14).*Pattern{7};
sum(testMat==1:14)
% Randomize frequency table with the restriction that the same trial does
temp_rand_index = randperm(N_trials); % Generate Randomiz-ing index
%%%%%%%%%Checks out till here
Pattern{Lseq} = Pattern{Lseq}(temp_rand_index); % Randomize

%Check if the first two are consecutive
chk = diff(Pattern{Lseq});
testMat=ones(200,14).*Pattern{7};
sum(testMat==1:14)
%Fix if first two patterns are consecutive
while chk(1)==0
    temp_rand_index = randperm(N_trials);
    Pattern{Lseq}    = Pattern{Lseq}(temp_rand_index);
    chk = diff(Pattern{Lseq});
    
end
testMat=ones(200,14).*Pattern{7};
sum(testMat==1:14)
%From Matlab Central: shuffling with constraint
old_idx = unique(find(diff(Pattern{Lseq})==0));%find repeats
while ~isempty(old_idx) %continue until no repeats
    new_idx = unique(setdiff(1:length(Pattern{Lseq}),old_idx)); %find new spots
    new_idx = new_idx((randi(length(new_idx),length(old_idx),1)))';
    Pattern{Lseq}([new_idx;old_idx],:) = Pattern{Lseq}([old_idx;new_idx],:); %swap
    old_idx = unique(find(diff(Pattern{Lseq})== 0));%find repeats
end
testMat=ones(200,14).*Pattern{7};
sum(testMat==1:14)
%Set Outcome matrix
OutMat = nan(200,1);
Tempout=[];
testMat=ones(200,14).*Pattern{7};
sum(testMat==1:14)
%Populate outcome matrix
for i = 1:14 %for the number of pattern types
Tempout= ones(Pattern{freq}(i),1);
   TempPartition = round(Pattern{co_prob}(i) * Pattern{freq}(i));
    Tempout = Tempout * 0;
    Tempout(1:TempPartition) = 1;
    Tempout = Tempout(randperm(length(Tempout)));
    
    OutMat(find(Pattern{Lseq}==i)) = Tempout;
end
Pattern{T_out} = OutMat;
%save('./Pattern2load','Pattern')