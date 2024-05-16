function out=my_gcd(a,b)
pair = [a,b];
x = max(pair);
y = min(pair);
while(y>0)
    r = rem(x,y);
    x = y;
    y = r;
end
out = x;
end