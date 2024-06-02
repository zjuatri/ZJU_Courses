%%
t = 0.000001:0.01:5
y=1-erf(1./sqrt(t))

n=length(t);
y1 = zeros(1,n);
y2 = zeros(1,n);
for i=1:n
    if (t(i)<=1)
        y1(i) = 0;
    else
        y1(i)=-1.5*(1-erf(1./sqrt(t(i)-1)));
    end
    if (t(i)<=3)
        y2(i) = 0;
    else
        y2(i)=0.5*(1-erf(1./sqrt(t(i)-3)));
    end
end
x=y+y1+y2
plot(t,x);


integrate
