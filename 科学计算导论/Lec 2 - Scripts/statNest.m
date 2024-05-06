function [me SD] = statNest(v)
% Calculate mean and standard deviation of vector v
n = length(v);
me = AVG(v);

    % Nested function to calculate mean
    function av = AVG(x)
    av = sum(x)/n;
    end

    % Nested function to calculate standard deviation
    function Sdiv = StandDiv(x)
    xdif = x-me;
    xdif2 = xdif.^2;
    Sdiv = sqrt(sum(xdif2)/(n-1));
    end

SD = StandDiv(v);
end


