function y = nearZero(x)
if max(x) == 0 && min(x) == 0 % If all the elements are zeros, return zero.
    y = 0;
else
nonZeroIndices = find(x);
y = x(nonZeroIndices(1));
if nonZeroIndices(1) ~=1 % when the first element is zero, consider the second one.
    y = max(y,x(2));
end

for i = 1:length(nonZeroIndices)-1
    if nonZeroIndices(i+1) - nonZeroIndices(i) >1
        % when x(i+1) - x(i)>1, x(i+1) and x(i) are elements near zero.
        if nonZeroIndices(i+1) - nonZeroIndices(i) >2
            % it means there is zero near another zero
            y = max([y,x(nonZeroIndices(i)),x(nonZeroIndices(i+1)),0]);
            % maybe all the non-zero elements are less than zero.
        else
            y = max([y,x(nonZeroIndices(i)),x(nonZeroIndices(i+1))]);
        end
    end
end

if nonZeroIndices(end) ~= length(x) % when the last element is zero, consider the last second one.
    y = max([y,x(end-1)]);
end
end
end