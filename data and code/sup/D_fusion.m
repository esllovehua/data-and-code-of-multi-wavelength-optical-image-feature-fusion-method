function [y] = D_fusion(x1,x2)
[m,n] = size(x1);
E = ones(m,n);
% windows = [1,1,1;1,1,1;1,1,1]/9;
windows = [1,2,1;2,4,2;1,2,1]/16;
% windows = [-1,-1,-1;-1,9,-1;-1,-1,-1]; 
S1 = 2*conv2((x1.*x2),windows,'same');
S2 = conv2((x1.*x1),windows,'same')+conv2((x2.*x2),windows,'same');
S = S1./S2;
A = S;
y = A.*x1+(E-A).*x2;
end