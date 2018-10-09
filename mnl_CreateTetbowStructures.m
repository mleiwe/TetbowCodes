function [Bow]=mnl_CreateTetbowStructures
%function to place all group data into a singular structure for further
%analysis
prompt='Enter the number of groups in your analysis';
nGroups=input(prompt,'d');

for i=1:nGroups
    disp('Select Group')
    %Specify the concentration
    prompt='Enter Group Name/Concentration';
    Bow(i).Concentration=input(prompt,'s');
    % Load in the data
    disp('Load in your chosen group')
    [Wkspaces]=uipickfiles;
    load(Wkspaces{1,1});
    % Reconfigure into Bow
    sNum=max(Data.SampleNum);%Find the total number of samples
    for j=1:sNum
        index=Data.SampleNum==i;%List of where the sample data is
        a=find(index);%Positions of where in Index the sample is
        st=min(a);ed=max(a);%Begining and end of sample
        Bow(i).SampleNum(j).ColourData_Raw=Data.RawColourData(st:ed,:);
        Bow(i).SampleNum(j).ColourData_Norm=Data.NormalisedColourData(st:ed,:);
    end
end