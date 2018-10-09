function [Distance]=mnl_TernaryAxons(Image1,Image2,Image3,ChNames)
% Function to plot the positions of n*3 data points across multiple images.
% Each column should represent a colour channel, and each row  represents a
% data point (axon).
%% Calculate the Euclidean Distances between all the points
%Step 1 - Normalise the Vectors per Image
Image1=mnl_NormaliseVectors(Image1);
Image2=mnl_NormaliseVectors(Image2);
Image3=mnl_NormaliseVectors(Image3);
%Step 2 - Calculate the distances across the images
sz1=size(Image1,1);
sz2=size(Image2,1);
sz3=size(Image3,1);
if sz1~=sz2||sz1~=sz3||sz2~=sz3
    error('Matrices are uneven, cannot compute gaps')
else
    for i=1:sz1
        distance12(i)=MNL_EuclideanDistance(Image1(i,:),Image2(i,:));
        distance13(i)=MNL_EuclideanDistance(Image1(i,:),Image3(i,:));
        distance23(i)=MNL_EuclideanDistance(Image2(i,:),Image3(i,:));
    end
end
% All together
AllDist=[distance12 distance13 distance23];
mAllDist=mean(AllDist);
stAllDist=std(AllDist);
seAllDist=stAllDist/sqrt(size(AllDist,2));
Distance.All.Values=AllDist;
Distance.All.Mean=mAllDist;
Distance.All.StdDev=stAllDist;
Distance.All.SEM=seAllDist;
%Image 1 to Image 2
mdistance12=mean(distance12);
stdistance12=std(distance12);
sedistance12=stdistance12/sqrt(size(distance12,2));
Distance.OneToTwo.Values=distance12;
Distance.OneToTwo.Mean=mdistance12;
Distance.OneToTwo.StdDev=stdistance12;
Distance.OneToTwo.SEM=sedistance12;
%Image 1 to Image 3
mdistance13=mean(distance13);
stdistance13=std(distance13);
sedistance13=stdistance13/sqrt(size(distance13,2));
Distance.OneToThree.Values=distance13;
Distance.OneToThree.Mean=mdistance13;
Distance.OneToThree.StdDev=stdistance13;
Distance.OneToThree.SEM=sedistance13;
%Image 2 to Image 3
mdistance23=mean(distance23);
stdistance23=std(distance23);
sedistance23=stdistance23/sqrt(size(distance23,2));
Distance.TwoToThree.Values=distance23;
Distance.TwoToThree.Mean=mdistance23;
Distance.TwoToThree.StdDev=stdistance23;
Distance.TwoToThree.SEM=sedistance23;
% Box Plot
labels={'All','1 to 2', '1 to 3','2 to 3'};
x=size(AllDist,2);
Distances=NaN(x,4);
Distances(1:size(AllDist,2),1)=AllDist;
Distances(1:size(distance12,2),2)=distance12;
Distances(1:size(distance13,2),3)=distance13;
Distances(1:size(distance23,2),4)=distance23;
h=mnl_boxplot(Distances,labels,'Euclidean Distance');
%% Eastablish Colour Code
sz1=size(Image1);
sz2=size(Image2);
sz3=size(Image3);
if sz1>=sz2
    NumCells=sz1;
elseif sz2>sz1
    NumCells=sz2;
elseif sz3>sz1
    NumCells=sz3;
end
c=colormap(jet(NumCells(1)));
cmap=linspace(1,NumCells(1),NumCells(1));

%% Now Plot Seperate Ternary Figs
[Group1]=Convert2Ratios(Image1);
[Group2]=Convert2Ratios(Image2);
[Group3]=Convert2Ratios(Image3);

figure('Name','Group/Image 1')
[h,hg,htick]=terplot;
hter=ternaryc(Group1(:,1),Group1(:,2),Group1(:,3),cmap,'o');
set(hter,'markersize',10)

figure('Name','Group/Image 2')
[h,hg,htick]=terplot;
hter=ternaryc(Group2(:,1),Group2(:,2),Group2(:,3),cmap,'o');
set(hter,'markersize',10)
terlabel(ChNames(1),ChNames(2),ChNames(3));

figure('Name','Group/Image 3')
[h,hg,htick]=terplot;
hter=ternaryc(Group3(:,1),Group3(:,2),Group3(:,3),cmap,'o');
set(hter,'markersize',10)
terlabel(ChNames(1),ChNames(2),ChNames(3));
%% Plot Combined figure
figure('Name','Combined Image')
[h,hg,htick]=terplot;
mnl_TernaryPairs(Group1,Group2,Group3,c)
set(hter,'markersize',5)
terlabel(ChNames(1),ChNames(2),ChNames(3));
end

%% Nested Functions
function [nGroup]=Convert2Ratios(Group)
sz=size(Group);
nGroup=zeros(sz);
for i=1:sz(1)
    base=sum(Group(i,:));
    nGroup(i,:)=Group(i,:)/base;
end
end
function [EuD]=MNL_EuclideanDistance(X,Y)
EuD=sqrt(sum((X-Y).^2));
end