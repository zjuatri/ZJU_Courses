syms x y
f = cos(x)*sin(y) + y^2*log(x);
df_dx = diff(f, x);
disp(df_dx);

syms x y z
F = [2*cos(x)^2, sin(y)^3, 2*x^2 + y^2 + 4*z^2];
divF = diff(F(1),x)+diff(F(2),y)+diff(F(3),z);
disp(divF);

syms x y z
f = x^2 + 2*y^2 + 4*z^2;
grad_f = [diff(f, x), diff(f, y), diff(f, z)];
disp(grad_f);

syms x
f = x^2 - 5*x;
integral_f = int(f, x);
disp(integral_f);

syms x n
f = x^(2-n) - 5*x;
integral_f = int(f, x);
disp(integral_f);

syms x y z
f = sin(x)*cos(y)*tan(z) + y*cos(x) + x*sin(y);
triple_integral_f = int(int(int(f, x), y), z);
disp(triple_integral_f);