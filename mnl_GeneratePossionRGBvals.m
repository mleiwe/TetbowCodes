function [Cells]=mnl_GeneratePossionRGBvals(NumPoints,Spreads)
% Code for creating a three dimensional poisson distributions at
% user-specified spreads.
% Sakaguchi et al 2018, created by Marcus Leiwe at Kyushu
% University 2018. If used please cite our paper XXXXXX.
%
%Inputs
% NumPoints=number of cells
% Spread=[pdf variances] e.g. [0 0.1 0.2 0.5 1 2 4 8]
%
%Outputs
% Cells=Structure containing cells and the spread information
% Structure Details -   Copy Number = The specified poisson spread
%                   -   RGBvals = n*3 number of fluorescent proteins for
%                       "Red", "Green, "Blue"
%
%Example
% [Cells]=mnl_GeneratePoissionRGBvals(100,[0,0.1,0.2,0.5,1,2,4,6,8,10,20])
%% Generate Poisson Matrices
x=linspace(0,50,51); %Theoretical maximum number of "fluorescent proteins" in the distribution
sz=size(Spreads);
for i2=1:sz(2)
    for i=1:51
        MatlabPoisson(i,i2)=poisspdf(x(i),Spreads(i2));
    end
end
figure('Name','Poisson Distributions')
plot(x,MatlabPoisson)
legend(num2str(Spreads'))
%% Allocate Values for each cell
MaxCells=0;
for i=1:sz(2) % For each Vector Conc
    for j=1:3 %for each colour
        Counter=1;
        for k=1:41 %Number of Copies
            if round(MatlabPoisson(k,i)*NumPoints)>=1
                for m=1:round(MatlabPoisson(k,i)*NumPoints)
                    Temp(Counter,j)=k-1;
                    Counter=Counter+1;
                end
            end
        end
        Cells(i).CopyNumber=Spreads(i);
        Cells(i).RGB(:,j)=Temp(randperm(length(Temp)));
    end
    clear Temp
end
for i=1:sz(2)
    figname=sprintf('%s%d','Copy Number = ',Cells(i).CopyNumber);
    figure('Name',figname)
    mnl_TernaryPlotsSingle(Cells(i).RGB,{'Red','Green','Blue'})
    h=gcf;
    mnl_ExportEPSdense(h,figname)
end
end
