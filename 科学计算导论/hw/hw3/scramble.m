function scramble(input,output)

in = fopen(input,'r');
out = fopen (output, 'w');
line = fgets(in);

while line ~= -1
    words = strread(line, '%s');
    line = fgets(in);
    for i = 1:length(words)
        word = scrambleWord(words{i});
        fprintf (out, '%s', word);
        fprintf (out, '%s', ' ');
    end
    fprintf (out, '\n');
end
