years=15:5:25;
rates=0.1:0.01:0.2;
result = zeros(11,3);
for i = 1:length(years)
    for j = 1:length(rates)
        r = rates(j);
        k = years(i);
        n = 12;
        A = 1000;
        result(j,i)=r*A*(1+r/n)^(n*k)/(n*((1+r/n)^(n*k)-1));
    end
end
disp(result);