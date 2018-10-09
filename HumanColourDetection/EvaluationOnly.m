function [Comparisons]=EvaluationOnly(DataSet,Th,NumTrials)
%% Step 4 - Evaluate Colour Discrimination
szTH=size(Th);
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
maxVal=(2^BitDepth)-1;
ColourMatrix=zeros(maxVal^3,3);
n=1;
a=linspace(0,255,256)';
for r=0:maxVal
    for g=0:maxVal
        rg=ones(256,2);
        rg(:,1)=rg(:,1)*r;
        rg(:,2)=rg(:,2)*g;
        ColourMatrix(n:(n+255),:)=[rg(:,1) rg(:,2) a];
        n=n+256;
    end
end
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
    UserDecision=UserDecision2;
end
close all
end