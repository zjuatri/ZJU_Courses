% Lecture 26 Script
    
%% Bubble Sort
r = rand(1,20)
y = bubble(r)

tic;
r = rand(1,20000);
y = bubble(r);
toc;

%% Matlab Sort - quicksort
tic;
r = rand(1,20000);
[y,I] = sort(r);
toc;

%% 2D

A = [ 3 7 5; 0 4 2 ];

sort(A,1)

sort(A,2)

[B,IX] = sort(A,2)

%%

A = [ 3  7  5; 6  8  3; 0  4  2 ];

sort(A,1,'descend')

sort(A,'ascend')

