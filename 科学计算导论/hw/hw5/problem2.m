f = @(x) sin(x)+ (cos(x.^2-pi./7)).^2;
h = ezplot(f,[-5*pi 5*pi]);
set(h, 'LineWidth', 0.1,'Color','r');
xlabel('x');
ylabel('f(x)');


I = 5:500;
M=[];
for i=I
    X = linspace(-5*pi,5*pi,i);
    M(end+1) = trapz(X,f(X));
end

plot(I,M)
hold on

n = integral(f,-5*pi,5*pi);
N=n.*ones(1,length(I));
plot(I,N,'r-',LineWidth=2)