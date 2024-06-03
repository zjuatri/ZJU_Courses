function y = bubble (x)
% sorting scheme with bubble sort

n=length(x);
sorted = 0;
k =0;

while ~sorted
    sorted = 1;
    k = k+1;
    for j=1:n-k
        if x(j) > x(j+1)
            temp = x(j);
            x(j) = x(j+1);
            x(j+1) = temp;
            sorted = 0;
        end
    end
end;

y = x;