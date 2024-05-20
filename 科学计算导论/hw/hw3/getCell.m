function out = getCell (in, row, col)
if row < 1 || col < 1 || row > size(in,1) || col > size(in,2)
    out = 0;
else
    out = in(row,col);
end