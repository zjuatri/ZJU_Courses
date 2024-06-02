function solns = sudoku2(puzzle)
% Sudoku - this function solves a sudoku puzzle presented as a 9x9 array
% with 0s in the entries that are unknown. A cell array containing all of
% the legal solutions is returned

% Find the unknown entries
[I J] = find (puzzle == 0);

% If there are no unknown entries this must be a solution so return it
if (isempty(I))
    solns = {puzzle};
    return;
end


% order the unknown entries according to the level of difficulty
n=length(I);
for k=1:n
   i = I(k);
   j = J(k);
   row = puzzle(i,:);
   col = puzzle(:,j);
   square = puzzle(floor((i-1)/3)*3 + [1 2 3], floor((j-1)/3)*3 + [1 2 3]);
   used_values = union(square(:), union(row(:), col(:)));
   entry = setdiff([1:9], used_values);
   level(k) = size(entry,2);
end

% find the the easiest level & start there
[x,m] = min(level);
i = I(m);
j = J(m);
%fprintf('%i,%i,%i,%i\n',x,m,i,j)



% Pull out the row of the entry
row = puzzle(i,:);

% Pull out the column of the entry
col = puzzle(:,j);

% Pull out the subsquare
square = puzzle(floor((i-1)/3)*3 + [1 2 3], floor((j-1)/3)*3 + [1 2 3]);

used_values = union(square(:), union(row(:), col(:)));

solns = {};

% For every value that hasn't been used call the solver recursively
for entry = setdiff ([1:9], used_values)
    puzzle(i,j) = entry;
    solns = [solns sudoku2(puzzle)];
end