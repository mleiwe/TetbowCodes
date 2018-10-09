function[Data]=mnl_ImportColourData(fn,sn)
%Imports Data from .xls spreadsheets, with the Columns being 1=Cell Number,
%2=Sample Number, 3:5=Raw colour data, 7:9=Values normalised to the median
%value
%Inputs
% fn - file name
% sn - sheet name
%
%Outputs
% Data - structure containing the necessary information
% 
%Created by Marcus Leiwe, Kyushu University 2018

[num,~,~]=xlsread(fn,sn);

%Data.SampleNum=num(:,sz);
Data.CellNum=num(:,1);
Data.SampleNum=num(:,2);
Data.RawColourData=num(:,3:5);
Data.NormalisedColourData=num(:,7:9);
end