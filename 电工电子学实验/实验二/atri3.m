U = [6.68	4.999	3.361	1.690	0.0013];
I = [32.6	49.5	65.9	82.8	99.4];
p = polyfit(I, U, 1)
x = linspace(0,100,10);
U_fit= polyval(p,x);
plot(I,U, 'o',x,U_fit,'b-');
ylabel('U/V');
xlabel('I/mA');
xlim([0 110]);
ylim([0 12]);
title('电压源外特性测量')