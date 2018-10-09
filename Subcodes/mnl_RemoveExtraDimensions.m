function [y]=mnl_RemoveExtraDimensions(x)
sz=size(x);
n=1;
for i1=1:sz(1)
    for i2=1:sz(2)
        for i3=1:sz(3)
            y(n)=x(i1,i2,i3);
            n=n+1;
        end
    end
end
end