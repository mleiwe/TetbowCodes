function [EuD_all,EuD_allM,EuD_mean,EuD_allMean]=mnl_GroupColourEuclidean(data)
%% Help Section
%
% Inputs
% data - data points as vector (cells*3)
%
% Outputs
% EuD_all - Euclidean Distance between all points
% EuD_mean - Euclidean Distance to mean
% EuD_allM - Euclidean Distance between all points in a matrix format
% EuD_allMean - the mean euclidean distance for each cell when measuring
% the distance to the other cells
%
% Written by Marcus Leiwe, Kyushu University, 2018. If used please cite
% Sakaguchi et al 2018

%% Basic Info
sz=size(data);
EuD_mean=nan(sz(1),1);
EuD_all=zeros((sz(1)*(sz(1)+1))/2,1);
EuD_allM=nan(sz(1),1);
EuD_allMean=zeros(sz(1),1);
n=1;
%% Calculate Euclidean Distances
CentrePoint=mean(data);
for i=1:sz(1)
    m=1;
    EuD_mean(i)=MNL_EuclideanDistance(data(i,:),CentrePoint);
    EuD_temp=zeros(sz(1)-i+1,1);
    for j=i:sz(1)
        val=MNL_EuclideanDistance(data(i,:),data(j,:));
        EuD_allM(i,j)=val;
        EuD_allM(j,i)=val;
        EuD_all(n,1)=val;
        EuD_temp(m,1)=val;
        n=n+1;
        m=m+1;
    end
    EuD_allMean(i)=mean(EuD_temp);
end
end

function [EuD]=MNL_EuclideanDistance(X,Y)
EuD=sqrt(sum((X-Y).^2));
end