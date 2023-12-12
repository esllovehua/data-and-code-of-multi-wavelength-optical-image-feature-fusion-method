function [y,LL2,LH2,HL2,HH2,LH,HL,HH] = haar_2(x)
[LL,LH,HL,HH] = dwt2(x,'haar');
[LL2,LH2,HL2,HH2] = dwt2(LL,'haar');
LL = [LL2 LH2;HL2 HH2];
y=[LL LH;HL HH];

