A = 0.5;
k = 2 * pi;
D = 0.05;
U = 1;
l = 2;
n = 21;
h = l / (n - 1);
dt = 0.05;

N = 1:1:21;
X = h * (N-1);
Fe = []; % exact solutions
Fn = []; % numerical solutions

Fn(1,:) = A * sin(k*X);

for i = 2:10
    t = (i-1)*dt;
    for j = 1:length(N)
        Fn(i,j) = fVal(Fn,i-1,j) - U*dt/(2*h)*(fVal(Fn,i-1,j+1)-fVal(Fn,i-1,j-1)) + D*dt/(h^2)*(fVal(Fn,i-1,j+1)-2*fVal(Fn,i-1,j)+fVal(Fn,i-1,j-1));
    end
end

for i = 1:10
    t = (i-1)*dt;
    Fe(i,:) = exp(-D*(k^2)*t)*A * sin(k*(X - U*t));
end

for i = 1:10
plot(N,Fe(i,:),'r-',LineWidth=2);
hold on;
plot(N,Fn(i,:),'b-',LineWidth=2);
xlim([1 21])
ylim([-2 2])
legend('exact','numerical')
txt = ['nstep=' num2str(i) ' time=' num2str((i-1)*dt)];
text(12,-1,txt)
pause(5)
hold off
end

% Periodic boundary conditions
function val = fVal(f,i,j)
n = 21;
if j == 0
    val = f(i,n-1);
elseif j == n + 1
    val = f(i,2);
else
    val = f(i,j);
end
end

