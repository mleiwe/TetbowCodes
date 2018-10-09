function [Tetbow]=TetbowConcentrationEvaluationAnalysis(Tetbow,GroupNames)
% Code that evalluates the spread of 3D colour distributions in euclidean
% space
%
%Inputs
% Tetbow - Structured Matrix containing the various concentrations/types of
% tetbow
% GroupNames - Names of each group e.g.GroupNames={'tTA 0.1','tTA 0.25','tTA 0.5'};

NumGroups=size(GroupNames,2);
MaxVal=1;
MaxCellNum=1;
TotalCellsPerGroup=zeros(size(GroupNames,2),1);
MaxSampleNum=0;
for i=1:NumGroups
    SampleNum=size(Tetbow(i).SampleNum,2);
    val=nan(SampleNum,1);
    %Convert to Ratios
    for j=1:SampleNum
        data=Tetbow(i).SampleNum(j).ColourData_Norm;
        Tetbow(i).SampleNum(j).NormVect=mnl_NomaliseVectors(data);
        [EuD_all,EuD_allM,EuD_mean,EuD_allMean]=mnl_GroupColourEuclidean(Tetbow(i).SampleNum(j).NormVect);
        Tetbow(i).SampleNum(j).EuD_all=EuD_all;
        Tetbow(i).SampleNum(j).EuD_allM=EuD_allM;
        Tetbow(i).SampleNum(j).EuD_mean=EuD_mean;
        Tetbow(i).SampleNum(j).EuD_allMean=EuD_allMean;
        numAll(i,j)=size(EuD_all,1);
        numMean(i,j)=size(EuD_mean,1);
        if MaxVal<size(EuD_all,1)
            MaxVal=size(EuD_all,1);
        end
        if MaxCellNum<size(Tetbow(i).SampleNum(j).ColourData_Raw,1)
            MaxCellNum=size(Tetbow(i).SampleNum(j).ColourData_Raw,1);
        end
        val(j)=size(Tetbow(i).SampleNum(j).ColourData_Raw,1);
        clear EuD_all EuD_allM EuD_mean EuD_allMean
    end
    GpAll(i)=sum(numAll(i,:));
    GpMean(i)=sum(numMean(i,:));
    TotalCellsPerGroup(i)=sum(val);
    if SampleNum>MaxSampleNum
        MaxSampleNum=SampleNum;
    end
end
MaxCellsPerGroup=max(TotalCellsPerGroup);
EuD_allMatrix=NaN(max(GpAll),3);
EuD_MeanCellSeg=NaN(max(GpMean),3);
%% Create Matrix for EuD All together
for i=1:NumGroups
    SampleNum=size(Tetbow(i).SampleNum,2);
    counter1=1;
    counter2=1;
    for j=1:SampleNum
        sz1=size(Tetbow(i).SampleNum(j).EuD_all,1);
        sz2=size(Tetbow(i).SampleNum(j).EuD_allMean,1);
        EuD_allMatrix(counter1:(counter1+sz1-1),i)=Tetbow(i).SampleNum(j).EuD_all;
        a=Tetbow(i).SampleNum(j).EuD_allMean';
        EuD_MeanCellSeg(counter2:(counter2+sz2-1),i)=a;
        counter1=counter1+sz1;
        counter2=counter2+sz2;
    end
end
mnl_boxplot(EuD_allMatrix,GroupNames,'Euclidean Distance');% Stats Graph
figure
mnl_boxplot(EuD_MeanCellSeg,GroupNames,'Mean Euclidean Distance per Cell');% Stats Graph
%% Create Individual EuD Matrix
columncounter=1;
xticklab=GroupNames;
sEuD_allMatrix=nan(max(numAll(:)),15);
sEuD_MeanCellSeg=nan(max(numMean(:)),15);
for r=1:NumGroups
    SampleNum=size(Tetbow(r).SampleNum,2);
    for c=1:SampleNum
        tot=size(Tetbow(r).SampleNum(c).EuD_all,1);
        sEuD_allMatrix(1:tot,columncounter)=Tetbow(r).SampleNum(c).EuD_all;
        a=Tetbow(r).SampleNum(c).EuD_allMean';
        sEuD_MeanCellSeg(1:size(a,2),columncounter)=a;
        labelmarkers(columncounter)=xticklab(r);
        columncounter=columncounter+1;
    end
end
figure
mnl_boxplot(sEuD_allMatrix,labelmarkers,'Euclidean Distance');% Stats Graph
figure
mnl_boxplot(sEuD_MeanCellSeg,labelmarkers,'Mean Euclidean Distance per Cell');% Stats Graph

%% Calculated EuD Per Group
figure('Name','Vector Norm Euclidean Distance All')
mnl_CumulativePlot3(EuD_allMatrix(:,1),EuD_allMatrix(:,2),EuD_allMatrix(:,3))
legend(GroupNames)
figure('Name','Vector Norm Mean Euclidean Distance per Cell')
mnl_CumulativePlot3(EuD_MeanCellSeg(:,1),EuD_MeanCellSeg(:,2),EuD_MeanCellSeg(:,3))
legend(GroupNames)
figure('Name','Vector Norm Euclidean Distance All - Per Sample')
mnl_CumulativePlot3(sEuD_allMatrix(:,1),sEuD_allMatrix(:,2),sEuD_allMatrix(:,3),sEuD_allMatrix(:,4),sEuD_allMatrix(:,5),sEuD_allMatrix(:,6),sEuD_allMatrix(:,7),sEuD_allMatrix(:,8),sEuD_allMatrix(:,9),sEuD_allMatrix(:,10),sEuD_allMatrix(:,11),sEuD_allMatrix(:,12),sEuD_allMatrix(:,13))
legend(labelmarkers)
figure('Name','Vector Norm Mean Euclidean Distance per Cell - Per Sample')
mnl_CumulativePlot3(sEuD_MeanCellSeg(:,1),sEuD_MeanCellSeg(:,2),sEuD_MeanCellSeg(:,3),sEuD_MeanCellSeg(:,4),sEuD_MeanCellSeg(:,5),sEuD_MeanCellSeg(:,6),sEuD_MeanCellSeg(:,7),sEuD_MeanCellSeg(:,8),sEuD_MeanCellSeg(:,9),sEuD_MeanCellSeg(:,10),sEuD_MeanCellSeg(:,11),sEuD_MeanCellSeg(:,12),sEuD_MeanCellSeg(:,13))
legend(labelmarkers)
%% Percent Above Various EuD
EuD_Spreads=[0 0.01 0.02 0.03 0.04 0.05 0.1 0.15 0.2 0.25];
NumThresh=size(EuD_Spreads,2);
EuD_Percents=zeros(NumGroups,NumThresh);
sEuD_Percents=nan(NumGroups,NumThresh,4);
for r=1:NumGroups
    for c=1:NumThresh
        szSample=size(Tetbow(r).SampleNum,2);
        for s=1:szSample
            temp=[];
            temp=Tetbow(r).SampleNum(s).EuD_all;
            sz=size(temp,1);
            n=0;
            for i=1:sz
                if temp(i,1)>=EuD_Spreads(1,c)
                    n=n+1;
                end
            end
            if n==0
                sEuD_Percents(r,c,s)=0;
            elseif n>sz
                sEuD_Percents(r,c,s)=100;
            else
                sEuD_Percents(r,c,s)=(n/sz)*100;
            end
            Tetbow(r).SampleNum(s).ThresholdScore(c,:)=[EuD_Spreads(1,c) (n/sz)*100];
        end
        %% Now per group
        MeanVal=nanmean(sEuD_Percents(r,c,:));
        sdVal=std(sEuD_Percents(r,c,:));
        if MeanVal==0
            EuD_Percents(r,c)=0;
        else
            EuD_Percents(r,c)=MeanVal;
        end
    end
end
figure('Name','Percent Above Euclidean Distance')
bar(EuD_Percents')
xticklabels({0 0.01 0.02 0.03 0.04 0.05 0.1 0.15 0.2 0.25})
hold on
for r=1:NumGroups
    for c=1:NumThresh
        [y]=mnl_RemoveExtraDimensions(sEuD_Percents(r,c,:));
        %Calc X Pos
        if r==1
            Xpos=c-(0.0909*3);
        elseif r==2
            Xpos=c-0.0909;
        elseif r==3
            Xpos=c+0.0909;
        elseif r==4
            Xpos=c+(0.0909*3);
        end
        x=ones(4,1)*Xpos;
        col=colormap(jet(4));
        for i=1:4
            scatter(x(i),y(i),'o','MarkerEdgeColor',col(i,:))
        end
    end
end
ylabel('%age above threshold')
xlabel('Threshold Euclidean Distance')

%% ANOVA testing
sz3=size(sEuD_Percents);
sizeGroups=sz3(1);sizeThresholds=sz3(2);sizeTrials=sz3(3);
n=1;
ThresholdNames={'0' '0.01' '0.02' '0.03' '0.04' '0.05' '0.1' '0.15' '0.2' '0.25'};
for i=1:sz3(1) %Per Group
    for j=1:sz3(2) %Per Thresh
        for k=1:sz3(3) % Per Session
            if isnan(sEuD_Percents(i,j,k))==0
                y(n)=sEuD_Percents(i,j,k);
                g1(n)=GroupNames(i);
                g2(n)=ThresholdNames(j);
                g3(n)=k;
                n=n+1;
            end
        end
    end
end

[p,tbl,stats] = anovan(y,{g1 g2 g3},'varnames',{'Group','Threshold','Sample Number'});
figure
results = multcompare(stats,'Dimension',[1 2],'CType','tukey-kramer');   
save('Analysis')
close all
end