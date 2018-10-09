function mnl_TernaryPlotsSingle(Group1,ChNames)
% Inputs
% Groups are n*3 data points
% ChNames = cell array of Channel Names

%% Step One Express each Line as a percentage
[Group1]=Convert2Ratios(Group1);
%% Plot Ternary Plots
[h,hg,htick]=terplot;
%Group 1
hter=ternaryc(Group1(:,1),Group1(:,2),Group1(:,3));
set(hter,'marker','o','markeredgecolor','none','markerfacecolor','red','markersize',4)
%% Now create labels
terlabel(ChNames(1),ChNames(2),ChNames(3));

end
function [nGroup]=Convert2Ratios(Group)
sz=size(Group);
nGroup=zeros(sz);
for i=1:sz(1)
    base=sum(Group(i,:));
    nGroup(i,:)=Group(i,:)/base;
end
end