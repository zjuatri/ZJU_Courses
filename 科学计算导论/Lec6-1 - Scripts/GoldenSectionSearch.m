function final_interval = GoldenSectionSearch (f, initial_interval, tol)
% Refine an interval bracketing a minima of a function

x1 = initial_interval(1);
x3 = initial_interval(2);

phi = (sqrt(5)-1) / 2;
phi1 = 1-phi;

x2 = x1 + (x3 - x1) * phi1;
x4 = x1 + (x3 - x1) * phi;

while ((x3 - x1) > tol)

    if (f(x2) > f(x4))
        x1 = x2;
        x2 = x4;
        x4 = x1 + (x3 - x1) * phi;
    else
        x3 = x4;
        x4 = x2;
        x2 = x1 + (x3 - x1) * phi1;
    end
        
    disp([x1,x2,x3]);

end

final_interval = [x1, x3];