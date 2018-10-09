function mnl_TernaryPairs(Points1,Points2,Points3,c)
c1=Points1(:,1);c2=Points1(:,2);c3=Points1(:,3);
if max(c1+c2+c3)>1
    c1=c1./(c1+c2+c3);
    c2=c2./(c1+c2+c3);
    c3=c3./(c1+c2+c3);
end
    
c21=Points2(:,1);c22=Points2(:,2);c23=Points2(:,3);
if max(c21+c22+c23)>1
    c21=c21./(c21+c22+c23);
    c22=c22./(c21+c22+c23);
    c23=c23./(c21+c22+c23);
end

c31=Points3(:,1);c32=Points3(:,2);c33=Points3(:,3);
if max(c31+c32+c33)>1
    c31=c31./(c31+c32+c33);
    c32=c32./(c31+c32+c33);
    c33=c33./(c31+c32+c33);
end

hold on
for i=1:length(c1)
    %XY co-ordinates for Point 1
    x1=0.5-c1(i)*cos(pi/3)+c2(i)/2;
    y1=0.866-c1(i)*sin(pi/3)-c2(i)*cot(pi/6)/2;
    %XY co-ordinates for Point 2
    x2=0.5-c21(i)*cos(pi/3)+c22(i)/2;
    y2=0.866-c21(i)*sin(pi/3)-c22(i)*cot(pi/6)/2;
    %XY co-ordinates for Point 3
    x3=0.5-c31(i)*cos(pi/3)+c32(i)/2;
    y3=0.866-c31(i)*sin(pi/3)-c32(i)*cot(pi/6)/2;
    
    x=[x1,x2,x3];
    y=[y1,y2,y3];
    
    hd(i)=plot(x,y,'o-','markerfacecolor',c(i,:));
end
