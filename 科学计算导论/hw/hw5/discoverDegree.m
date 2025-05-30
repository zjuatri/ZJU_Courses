function [R2out,pOrder,pCoeff] = discoverDegree(x,y,R2crit)
R2out=0;
pOrder = 0;
while(R2out<R2crit)
    pOrder=pOrder+1;
    pCoeff = polyfit(x,y,pOrder);
    average = mean(y);
    f = polyval(pCoeff,x);
    R2out = 1-sum((y-f).^2)/sum((y-average).^2);
end

scatter(x,y)
hold on
plot(x,polyval(pCoeff,x),LineWidth=1)
xlim([min(x) max(x)])
xlabel('x')
ylabel('y')
l=legend('Data','Polynomial Fit',Location='best');
end