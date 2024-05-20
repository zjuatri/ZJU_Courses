function out = scrambleWord(in)
temp = [];
% consider the punctuation
for i = 1:length(in)
    if isletter(in(i))
        temp(end+1) = in(i);
    end
end
in = temp;

randArr = randperm(length(in)-2);

if length(in) == 1
    out = in;
else
    out = [];
    out(1) = in(1);
    for i = randArr
        out(i+1) = in(randArr(i)+1);
    end
    out(length(randArr)+2) = in(length(randArr)+2);
    
    out = char(out);
end
end