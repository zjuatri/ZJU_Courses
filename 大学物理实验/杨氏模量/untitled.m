x = [5	10	15	20	25	30	35	40	45	50];
X = linspace(5,50,100)
f = [734.4	731.5	729	727.1	725.3	725.2	725	724.9	725.8	726.3];
p = polyfit(x,f,2)
F = polyval(p,X);
plot(x,f,"bo",X,F,"r-")
xlabel("x [mm]")
ylabel("f [Hz]")
title("共振频率与悬丝点位置关系图",FontName='黑体')
f_fit = polyval(p,x);
s = sqrt(mean((f-f_fit).^2))
