% Lecture 27 Script for examining matrix vector operations

%% Creating column vectorsin 2D
a = [2; 1]
b = [3; 4]

% Computing the dot product
dot(a,b)

a'*b

%% Creating column vectorsin 3D

a = [2; 1; -3]
b = [3; 4;  5]

% Computing the dot product
dot(a,b)

a'*b

%% Matrix vector multiplication

A = [1 2; 3 4]
b = [5; 6]

A*b

%% Interpretation as a series of inner products
A(1,:)*b

%%
A(2,:)*b
pause

%% Interpretation as a sum of the columns of A

A(:,1)*b(1) + A(:,2)*b(2)

%% Matrix Matrix multiplication

B = [1 -1; 2 3]
A*B

%% Gaussian Ellimination with pivoting

A = [20 15 10; -3 -2.249 7; 5 1 3]
b = [45 1.751 9]'
x = A\b

%% Example 1 Truss bridge
s = sin(pi/3);
c = cos(pi/3);

F = 10;

A = [0  0  s  0   s  0  0; ...
     0 -1 -c  0   c  1  0; ...
    -s  0 -s  0   0  0  0; ...
    -c  0  c  1   0  0  0; ...
     0  0  0  0  -s  0 -s; ...
     0  0  0 -1  -c  0  c; ...
     0  0  0  0   0 -1 -c];
 
 b = [F; 0; 0; 0; 0; 0; 0];
 
 S = A \ b
 
 %% Example 2 Spring mass system
 k1=1; k3=1; k6=1;
 k2=2; k4=2; k5=2;
 k7=3;
 
 A = [k1+k2+k6+k7 -k2 -k6 -k7; ...
     -k2 k2+k3 -k3 0; ...
     -k6 -k3 k3+k4+k6 -k4;...
     -k7 0 -k4 k4+k7+k5]
 
 b = [1 1 1 1]'
 
 x = A\b
 
 % validate 1. k7>>1; 2. k6>>1;