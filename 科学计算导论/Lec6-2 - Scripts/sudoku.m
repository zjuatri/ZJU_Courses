function solns = sudoku(puzzle)
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


i = I(1);
j = J(1);


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
    solns = [solns sudoku(puzzle)];
end