% Lecture 10 notes

%% Ex10-1 Loan function
[mpay, tpay] = loan(200000, 5, 15)

%%
[mpay, tpay] = loan(200000, 5, 30)

%%
[mpay, tpay] = loan(200000, 4, 15)
 
%% Ex10-2
y = Ex10_2(6)


%%
x = [1, 3, 5, 7, 9, 11];
y = Ex10_2(x);
disp([x', y'])

%% Example 10-3: Converting Temperatures
a1 = 4.5; b1 = 2.25; T1 = 40; T2 = 92; alpha = 23e-6;
% Calculate temp difference in degrees C
deltaT = FtoC(T2) - FtoC(T1);
% Find new dimensions
a2 = a1+alpha*a1*deltaT;
b2 = b1+alpha*b1*deltaT;
% Calculate the new area
AreaChange = a2*b2 - a1*b1;
fprintf('The change in the area is %6.5f square meters.\n', AreaChange)


%% Anonymous Function 
FA = @ (x) exp(x^2)/sqrt(x^2+5) 
FA(2)


%%
FA = @ (x) exp(x.^2)./sqrt(x.^2+5) 
FA([1 0.5 2])


%%
HA = @ (x,y) 2*x^2-4*x*y+y^2 
HA(2,3)


%% Example 10-4: Mean and Standard Deviation
% subfunctions
Grades = [80 75 91 60 79 89 65 80 95 50 81]
[AveGrade StanDevGrade] = stat(Grades)


%% Ex 11-1 Exponential Growth

A0=7; A1=0.5*A0; t1=5.8;
At = expGD(A0, A1, t1, 30)


%% Ex11-2 travectory of a projectile
[hmax, dmax] = trajectory(230, 39)

%%
[hmax, dmax] = trajectory(230, 45)


%% function function example
a=1; b=10;
xyout = funplot(@Fdemo, a, b)

%%
FdemoAnon = @ (x) exp(-0.17*x).*x.^3 - 2*x.^2 + 0.8*x -3;
xyout = funplot(FdemoAnon, a, b)


%%
xyout = funplot(@ (x) exp(-0.17*x).*x.^3 - 2*x.^2 + 0.8*x -3, a, b)

%%
xyout = funplotS('Fdemo', a, b)


%% Ex11-3 Taylor sine(x,n)
x=30; n=100;
y = TaylorSine(x, n)


%% Ex11-4 Taylor Exponential
x=1
y = TaylorExp(x)

%%
x=10
y = TaylorExp(x)
