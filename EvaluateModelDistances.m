function [Cells]=EvaluateModelDistances(Cells,Spreads)
% Statistical evaluation of modelled cells
n=1;
sz=Cells;
for i=1:sz(2)
    data=Convert2Ratios(Cells(i).RGB);
    [EuD_all,~,EuD_mean,EuD_allMean]=mnl_GroupColourEuclidean(data); %Euclidean Distances
    Cells(i).EuD_all=EuD_all;
    Cells(i).EuD_mean=EuD_mean;
    Cells(i).EuD_All_Mean=EuD_allMean;
    sz3=size(EuD_all);
    if n<sz3(1)
        n=sz3(1);
    end
end
EuD_all_combined=NaN(n,sz(2));
sz2=size(Cells(1).EuD_mean);
EuD_mean_combined=NaN(sz2(1),sz(2));
for i=1:sz(2)
    sz3=size(Cells(i).EuD_all,1);
    sz4=size(Cells(i).EuD_mean,1);
    EuD_all_combined(1:sz3,i)=Cells(i).EuD_all;
    EuD_mean_combined(1:sz4,i)=Cells(i).EuD_mean;
end
SpreadTitles=num2str(Spreads');
mnl_boxplot(EuD_all_combined,SpreadTitles,'Euclidean Distance');% Stats Graph
mnl_boxplot(EuD_mean_combined,SpreadTitles,'Euclidean Distance');% Stats Graph
figure('Name','Euclidean Distance All')
mnl_CumulativePlot3(Cells(1).EuD_all,Cells(2).EuD_all,Cells(3).EuD_all,Cells(4).EuD_all,Cells(5).EuD_all,Cells(6).EuD_all,Cells(7).EuD_all,Cells(8).EuD_all,Cells(9).EuD_all,Cells(10).EuD_all,Cells(11).EuD_all)
figure('Name','Euclidean Distance to mean')
mnl_CumulativePlot3(Cells(1).EuD_mean,Cells(2).EuD_mean,Cells(3).EuD_mean,Cells(4).EuD_mean,Cells(5).EuD_mean,Cells(6).EuD_mean,Cells(7).EuD_mean,Cells(8).EuD_mean,Cells(9).EuD_mean,Cells(10).EuD_mean,Cells(11).EuD_mean)
end
function [data]=mnl_RatioVectors(Group)
maxVals=max(Group);
data=Group./maxVals;
end
function [data]=mnl_RatioVectors2(Group)
sz=size(Group);
data=zeros(sz);
for i=1:sz(1)
    MaxVal=max(Group(i,:));
    data(i,:)=Group(i,:)/MaxVal;
    if isnan(data(i,:))==1
        data(i,:)=0;
    end
end
end
function [nGroup]=Convert2Ratios(Group)
sz=size(Group);
nGroup=zeros(sz);
for i=1:sz(1)
    base=sum(Group(i,:));
    if base~=0
        nGroup(i,:)=Group(i,:)/base;
    else
        nGroup(i,:)=zeros(1,sz(2));
    end
end
end