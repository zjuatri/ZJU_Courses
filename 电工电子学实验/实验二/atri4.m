U = [1.809	0.878	0.5843	0.2908	0.0013];
I = [0	8.75/1000	11.59/1000	14.36/1000	17.17/1000];
x = linspace(0,1.809,10);
p = polyfit(U,I,1)
I_fit = polyval(p,x);
plot(U,I,'o',x,I_fit,'b-');
ylim([0 20]);
xlabel('U/V');
ylabel('I/mA');
title('电流源外特性测量');