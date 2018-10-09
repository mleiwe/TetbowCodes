Bow(1).Concentration='tTA01';
sNum=max(tTA01.SampleNum);
for i=1:sNum
    index=tTA01.SampleNum==i;
    a=find(index);
    st=min(a);ed=max(a);
    Bow(1).SampleNum(i).ColourData_Raw=tTA01.RawColourData(st:ed,:);
    Bow(1).SampleNum(i).ColourData_Norm=tTA01.NormalisedColourData(st:ed,:);
end

Bow(2).Concentration='tTA025';
sNum=max(tTA025.SampleNum);
for i=1:sNum
    index=tTA025.SampleNum==i;
    a=find(index);
    st=min(a);ed=max(a);
    Bow(2).SampleNum(i).ColourData_Raw=tTA025.RawColourData(st:ed,:);
    Bow(2).SampleNum(i).ColourData_Norm=tTA025.NormalisedColourData(st:ed,:);
end

Bow(3).Concentration='tTA05';
sNum=max(tTA05.SampleNum);
for i=1:sNum
    index=tTA05.SampleNum==i;
    a=find(index);
    st=min(a);ed=max(a);
    Bow(3).SampleNum(i).ColourData_Raw=tTA05.RawColourData(st:ed,:);
    Bow(3).SampleNum(i).ColourData_Norm=tTA05.NormalisedColourData(st:ed,:);
end