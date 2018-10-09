function [DataSet,Comparisons]=EvaluateColourDiscrimination
%% Step 1 - Generate Colours
BitDepth=8;
[ColourMatrix]=mnl_GenerateColours(BitDepth);
szCM=size(ColourMatrix);
%% Step 2 - VectorNomalise
[NormColourMatrix]=mnl_NormaliseVectors(ColourMatrix);
%% Step 3 - Process for each Threshold
Th=[0 0.01 0.02 0.03 0.04 0.05 0.1 0.15 0.2 0.25];
szTH=size(Th);
NumTrials=100;
for i=1:szTH(2)
    %Step 3a... Choose A Colour
    DataSet(i).ColourRow=round(rand(1)*szCM(1));
    DataSet(i).ColourA=ColourMatrix(DataSet(i).ColourRow,:);
    DataSet(i).NormColourA=NormColourMatrix(DataSet(i).ColourRow,:);
    %Step 3b... Measure the Euclidean Distances to the colour (In Vector
    %Normalised Space)
    for j=1:szCM(1)
        [EuD]=MNL_EuclideanDistance(DataSet(i).NormColourA,NormColourMatrix(j,:));
        DataSet(i).EuD(j)=round(EuD,3);
    end
    % Step 3c...Find those within 0.05 of the threshold
    %index=DataSet(i).EuD>=Th(i)-0.01 & DataSet(i).EuD<=Th(i)+0.01; %index is a logical matrix 1=true
    if Th(i)==0
        for j=1:NumTrials
            ColourBs(j,:)=DataSet(i).ColourA;%fill in!!!!!
            NormColourBs(j,:)=DataSet(i).NormColourA;
            EuD_Bs(j)=0;
        end
    else
        index=DataSet(i).EuD==Th(i); %index is a logical matrix 1=true
        szInd=size(index);
        c=1;
        for j=1:szInd(2)
            if index(j)==1
                ColourBs(c,:)=ColourMatrix(j,:);
                NormColourBs(c,:)=NormColourMatrix(j,:);
                EuD_Bs(c)=DataSet(i).EuD(j);
                c=c+1;
            end
        end
    end
    % Step 3d...Reduce it down to 30
    szB=size(ColourBs,1);
    ChosenOnes=round((rand(NumTrials,1))*szB);%if it's less than 30 they should be duplicated
    for j=1:NumTrials
        if ChosenOnes(j)==0
            ChosenOnes(j)=1;
        end
        DataSet(i).ColourBs(j,:)=ColourBs(ChosenOnes(j),:);
        DataSet(i).NormColourBs(j,:)=NormColourBs(ChosenOnes(j),:);
        DataSet(i).EuD_Bs(j)=EuD_Bs(ChosenOnes(j));
    end
    clear ColourBs
    clear NormColourBs
    clear EuD_Bs
    clear index
end

%% Step 4 - Evaluate Colour Discrimination
ShuffledOrder=randperm(szTH(2));
for i=1:szTH(2)
    %Step 4a... Preallocate and Create Image
    Comparisons(ShuffledOrder(i)).Threshold=Th(ShuffledOrder(i));% The selected threshold
    Comparisons(ShuffledOrder(i)).NormColourA=DataSet(ShuffledOrder(i)).NormColourA;
    Comparisons(ShuffledOrder(i)).NormColourBs=DataSet(ShuffledOrder(i)).NormColourBs;
    ImA=ones(20,20,3);
    ImB=ones(20,20,3);
    for x=1:20
        for y=1:20
            ImA(x,y,:)=DataSet(ShuffledOrder(i)).ColourA;
            for j=1:NumTrials
                ImBs(j).ImB(x,y,:)=DataSet(ShuffledOrder(i)).ColourBs(j,:);
            end
        end
    end
    ImA=uint8(ImA);
    for j=1:NumTrials
        ImBs(j).ImB=uint8(ImBs(j).ImB);
    end
    %Step 4b... Compare Colours
    UserDecisions=zeros(NumTrials,1);
    UserDecisions=char(UserDecisions);
    CorrectDecisions=zeros(NumTrials,1);
    for j=1:NumTrials
        [UserDecision(j),CorrectDecision(j)]=mnl_AssessColours(ImA,ImBs(j).ImB);
    end
    Comparisons(ShuffledOrder(i)).EuclideanDistance=DataSet(ShuffledOrder(i)).EuD_Bs;
    Comparisons(ShuffledOrder(i)).UserDecisions=UserDecision;
    Comparisons(ShuffledOrder(i)).CorrectDecisions=CorrectDecision;
    Comparisons(ShuffledOrder(i)).PercentageCorrect=mean(CorrectDecision)*100;
end

end
function [ColourMatrix]=mnl_GenerateColours(BitDepth)
c
end
function [UserDecision,CorrectDecision]=mnl_AssessColours(ImA,ImB)
figure('Name','Are the Colours Crossed (c) Or Straight (s)?')
set(gcf, 'Color', [0,0,0]);
rOrg=round(rand(1)); %0= straight, 1= Crossed
if rOrg==0
    subplot(2,2,1)
    image(ImA*((rand(1)+1)/2));
    axis off
    subplot(2,2,2)
    image(ImA*((rand(1)+1)/2))
    axis off
    subplot(2,2,3)
    image(ImB*((rand(1)+1)/2))
    axis off
    subplot(2,2,4)
    image(ImB*((rand(1)+1)/2))
    axis off
else
    subplot(2,2,1)
    image(ImA*((rand(1)+1)/2))
    axis off
    subplot(2,2,2)
    image(ImB*((rand(1)+1)/2))
    axis off
    subplot(2,2,3)
    image(ImB*((rand(1)+1)/2))
    axis off
    subplot(2,2,4)
    image(ImA*((rand(1)+1)/2))
    axis off
end
%% User Decision
prompt='Are the Colours Crossed (c) Or Straight (s)?';
UserDecision=input(prompt,'s');
S=strcmp(UserDecision,'s');
C=strcmp(UserDecision,'c');
if rOrg==0 && S==1
    CorrectDecision=1;
elseif rOrg==0 && C==1
    CorrectDecision=0;
elseif rOrg==1 && C==1
    CorrectDecision=1;
elseif rOrg==1 && S==1
    CorrectDecision=0;
elseif C==0 && S==0
    prompt2='Invalid response please try again.... Are the Colours Crossed (c) Or Straight (s)?';
    UserDecision2=input(prompt2,'s');
    S2=strcmp(UserDecision2,'s');
    C2=strcmp(UserDecision2,'c');
    if rOrg==0 && S2==1
        CorrectDecision=1;
    elseif rOrg==0 && C2==1
        CorrectDecision=0;
    elseif rOrg==1 && C2==1
        CorrectDecision=1;
    elseif rOrg==1 && S2==1
        CorrectDecision=0;
    elseif C2==0 && S2==0
        prompt='Invalid response please try again.... Are the Colours Crossed (c) Or Straight (s)?';
        UserDecision=input(prompt,'s');
    end
end
close all
end
function [EuD]=MNL_EuclideanDistance(X,Y)
EuD=sqrt(sum((X-Y).^2));
end
function [Matrix]=mnl_NormaliseVectors(Matrix)
% Input
% Matrix - row of points,columns represent dimensions
% Output
% Matrix - same as above but now normalised
matrix_Norm=sqrt(sum((Matrix.*Matrix),2));
Matrix=Matrix./repmat(matrix_Norm,1,size(Matrix,2));
end