years=15:5:25;
rates=0.1:0.01:0.2;
result = zeros(11,3);
r = repmat(rates',1,3);
k = repmat(years,11,1);
A = 1000;
n = 12;
result=r*A.*(1+r/n).^(n*k)./(n*((1+r/n).^(n*k)-1));
disp(result);