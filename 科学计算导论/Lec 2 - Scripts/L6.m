%  Logical Expressions
%
%% Logical expressions are expressions which evaluate to true or false, 1 or
% 0. Matlab

x = 5

temp = (x > 4)

%%

whos temp

%%

temp = (x < 3)

%%
a = 5
b = 3
c = 12

t = (a > b)

%%
t = (a < b)

%%
t = (a >= b)


%% Logical AND &; OR |; NOT ~ 

(a > b) & (a < c)

%%

(a < b) | (a > c)

%%
x=5;
temp = (x == 12) | (x > 17)

%%
y = (6<10) + (7>8) + (5*3==60/4)

%%

x = 3
y = 2
temp = ((x > 3) & (x < 7)) | (y > 0)

%%
temp1 = (x > 3)
temp2 = (y <= 0) & ~temp1

%%
b = [15 6 9 4 11 7 14]
c = [8 20 9 2 19 7 10]
d = c>=b

%%
b == c

%%
b ~= c

%%
f = b-c>0


%% Logical expressions can be applied to arrays as well

x = [ 0 3 4 -1 2 ]
temp = (x > 1)

%%

y = [ 2 0 4 3 2 ]
temp = (x == y)

%%

temp = (x <= y)



%% Logical indexing
% We can index an array with another array of logical values this has the
% effect of selecting the elements corresponding to the logical 1 values

x = rand(1,5)

%% Note that we need the logical keyword here to convert the array of numbers 
% to an array of logical values if you don't include it you get an error

x(logical([0 1 0 1 0]))


%% You can also use this form of indexing to select elements for writing

x(logical([0 1 0 1 0])) = -90


%%
A = [2 9 4; -3 5 2; 6 7 -1]
B = A<=2


%% Addressing with logical arrays
r = [8 12 9 4 23 19 10]
s = r<=10

%%

t = r(s)

%%
w = r(r<=10)


%% Some useful functions

% Exclusive or: xor()
% XOR(S,T)=1, when either S or T, but not both, is nonzero.  
% XOR(S,T)=0, when S and T are both zero or nonzero.

xor(7,0)

%%
xor(7,-5)


%% all() - 1 if all () are 1
A = [6 2 15 9 7 11]
all(A)

%%
B = [6 2 15 9 0 11]
all(B)


%% any() - 1 if any () are 1
A = [6 0 15 0 0 11]
any(A)

%%
B = [0 0 0 0 0 0]
any(B)


%% find() - returns indices of non-zero elements
A = [0 9 4 3 7 0 0 1 8]
find(A)

%%
find(A>4)

%%
B = [3 2 0; -5 0 7; 0 0 1]
find(B)

%%
find(B>2)

%%
a = rand(1,10)
any (a > 0.5)

%%
all (a > 0.5)

%%
nnz (a > 0.5)

%%
find (a > 0.5);


%% Some examples

y = sin(-4*pi:pi/20:4*pi);
plot (y, 'b')
nnz (y > 0.5)


%% Clipping the signal y
y (y > 0.5) = 0.5;
y (y < -0.5) = -0.5;
hold on;
plot(y, 'r');
