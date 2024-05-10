function nums = fib(N)
function num = fibonacci(N)
    if N == 0
        num = 0;
    elseif N == 1
        num = 1;
    else
        num = fibonacci(N-2) + fibonacci(N-1);
    end
end

temp = [];
for i = 0:N
    temp(end+1) = fibonacci(i);
end
nums = temp;
end