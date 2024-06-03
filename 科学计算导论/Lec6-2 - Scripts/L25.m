%
% Lecture 25 Script for Sudoku Solver
%

%% 1 Test Sudoku Solver
puzzle = [5 3 0 0 7 0 0 0 0;
          6 0 0 1 9 5 0 0 0;
          0 9 8 0 0 0 0 6 0;
          8 0 0 0 6 0 0 0 3;
          4 0 0 8 0 3 0 0 1;
          7 0 0 0 2 0 0 0 6;
          0 6 0 0 0 0 2 8 0;
          0 0 0 4 1 9 0 0 5;
          0 0 0 0 8 0 0 7 9];
 
answers = sudoku (puzzle)

%% 2 Sudoku puzzle (with 2 possible solutions)
puzzle = [0 0 8 0 0 0 0 3 0;
          2 6 0 3 0 0 9 7 0;
          5 0 0 7 0 9 0 8 0;
          0 0 0 0 0 3 8 2 6;
          6 8 0 5 0 7 0 1 9;
          9 3 2 8 0 0 0 0 0;
          0 2 0 1 0 6 0 0 7;
          0 5 6 0 0 4 0 9 3;
          0 1 0 0 0 0 2 0 0];

answers = sudoku (puzzle)

%% 3 A harder example
puzzle = [3 0 0 0 0 8 0 0 0;
          7 0 8 3 2 0 0 0 5;
          0 0 0 9 0 0 0 1 0;
          9 0 0 0 0 4 0 2 0;
          0 0 0 0 1 0 0 0 0;
          0 7 0 8 0 0 0 0 9;
          0 5 0 0 0 3 0 0 0;
          8 0 0 0 4 7 5 0 3;
          0 0 0 5 0 0 0 0 6];
      
tic;      
answers = sudoku (puzzle)
toc;

%% a new version to speedup the scheme
tic;      
answers1 = sudoku2 (puzzle)
toc;
      