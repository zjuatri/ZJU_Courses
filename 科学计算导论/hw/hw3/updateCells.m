function out = updateCells (in)
out = in;
% make out and in the same scale
neighbors = countNeighbors(in);
for i = 1:size(in,1)
    for j = 1:size(in,2)
        if getCell(in,i,j) == 0
            if neighbors(i,j) == 3
                out(i,j) = 1;
            else
                out(i,j) = 0;
            end
        else
            if neighbors(i,j) == 2 || neighbors(i,j) == 3
                out(i,j) = 1;
            else
                out(i,j) = 0;
            end
        end
    end
end