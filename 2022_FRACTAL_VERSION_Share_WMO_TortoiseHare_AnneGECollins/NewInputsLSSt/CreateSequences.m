clear all

folderstouse = Shuffle([2 3 5 6 7 9 10:15 17 18]);nf=length(folderstouse);
%%

for iter = [1:10];
    clc
    iter
matrice=[];

%% blocks' set size, get stimuli
matrice.blocks=[3 6 3 3 6 3 6 6 3 3 6 3 6 3];nb=length(matrice.blocks);
matrice.stSets=folderstouse(1+rem((1:nb)+(iter-1)*nb,nf));
for b=1:nb
    x=randperm(6);
matrice.stimuli{b} = x(1:matrice.blocks(b));
end
matrice.Actions=Shuffle([13:15]);
%% create sequences
reps=13;

failed=1;
while failed
    X3=createstimsequence(2,3);
    for i=1:3
        l(i)=length(find(X3==i));
    end
    failed=min(l)~=max(l);
end
failed=1;
while failed
    X6=createstimsequence(2,6);
    for i=1:3
        l(i)=length(find(X6==i));
    end
    failed=min(l)~=max(l);
end
matrice.stSeqs{1} = [X3 createstimsequence(reps-4,3)];
matrice.stSeqs{2} = [X6 createstimsequence(reps-4,6)];
for i = 3:length(matrice.blocks)
    matrice.stSeqs{i} = matrice.stSeqs{2-rem(matrice.blocks(i),2)};
end

%%

% create stim-action rules
matrice.R=[ 1 2 0;
            2 2 2;%2
            1 0 2;
            1 2 0;
            2 2 2;
            0 1 2;
            2 2 2;%7
            2 2 2;%8
            1 0 2;
            1 2 0;
            2 2 2;
            0 1 2;
            2 2 2;%13
            2 1 0];


matrice.rules{1}=[1 2 2];

matrice.rules{2}=[1 1 2 2 3 3];
matrice.rules{3}=[1 3 3];
matrice.rules{4}=[2 2 1];
matrice.rules{5}=[2 2 3 3 1 1];
matrice.rules{6}=[3 2 3];
matrice.rules{7}=[3 3 1 1 2 2];

matrice.rules{8}=[1 1 2 2 3 3];
matrice.rules{9}=[1 3 3];
matrice.rules{10}=[2 2 1];
matrice.rules{11}=[2 2 3 3 1 1];
matrice.rules{12}=[3 2 3];
matrice.rules{13}=[3 3 1 1 2 2];

matrice.rules{14}=[2 1 1];


%% test phase: create all stimuli matrix
matricetest=[];

X = [];
for bl = 2:13
    for i = 1:matrice.blocks(bl)
    X = [X;[bl i matrice.rules{bl}(i)]];
    end
end
X = X(randperm(length(X)),:);
X = repmat(X,4,1);
matricetest.stimBlockSeq= X(:,1);
matricetest.stimNumSeq=X(:,2);
matricetest.stimCorA=X(:,3);

%% test phase: create pair of stimuli


save(['Matrice_sujet',num2str(iter)], 'matrice','matricetest')
end