function x = my_sqrt(a)
% my_sqrt: Approximate the square root of a given number, a, using
% Newton's method to find the root of (x^2 - a)
%

% Check whether a is positive before trying to compute the square root
if (a >= 0)
    % First guess
    x = (a/2);

    % This loop looks at the difference between x^2 and a in deciding when to
    % stop

    while (abs(x^2 - a) > 1.0e-6)
        y = (x^2 - a);
        gradient = 2*x;
        step = -y/gradient;
        x = x + step;
    end

else
    error ('input a is less than zero.');
end