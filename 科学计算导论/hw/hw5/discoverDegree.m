function [R2out,pOrder,pCoeff] = discoverDegree(x,y,R2crit)
R2out=0;
pOrder = 0;
if(R2out<R2crit)
    pOrder=pOrder+1;
    pCoeff = polyfit(x,y,pOrder);
    average = mean(y);
    f = polyval(pCoeff)
    R2out = 1-sum((y-f(y).^2))/sum((y-average).^2);
end

end