m = [0 496 997 1509 2023 2540 3041 3572];
g = 9.7936;
G = 1e-6*m*g;
U = [33.4 37.2 41.8 44.6 48.6 52.4 56.1 60.1];
p = polyfit(U,G,1);
1000*p
xSpace = linspace(30,65);
yVal = polyval(p,xSpace);
y_fit = polyval(p,U);
residuals = G - y_fit;
SSE = sum(residuals.^2);
n = length(U);
sigma_b = sqrt(SSE / (n - 2)) / sqrt(sum((U - mean(U)).^2))
plot(U,G,'o',xSpace,yVal,'b-')
ylim([-0.01 0.04])
xlabel('V [mV]');
ylabel('mg [N]');
title('拉力与电压关系图');
