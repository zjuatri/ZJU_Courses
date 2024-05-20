function out = countNeighbors (in)
out = in;
% make out and in the same scale
row = size(in,1);
col = size(in,2);

for i = 1:row
    for j = 1:col
        out(i,j) = getCell(in,i-1,j) + getCell(in,i+1,j) + getCell(in,i,j-1) + getCell(in,i,j+1);
    end
end
end