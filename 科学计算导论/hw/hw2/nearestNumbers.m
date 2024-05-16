function [index1, index2] = nearestNumbers(A)
B = A';
P = repmat(A,length(A),1);
Q = repmat(B,1,length(A));
Diff = abs(P-Q);
min_diff = Diff(1,2);
pair = [1,2];
for i = 1:length(A)
    for j = 1:length(A)
        if i>j
            if Diff(i,j)<min_diff
                min_diff=Diff(i,j);
                pair = [i,j];
            end
        end
    end
end
index1=pair(2);
index2=pair(1);
end