function out=my_lcm(a,b)
if a==0 || b==0
    out = 'undefined';
else
    g = my_gcd(a,b);
    x = a/g;
    y = b/g;
    out = x*y*g;
end
end