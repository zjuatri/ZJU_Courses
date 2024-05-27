function seed(new_seed)

% iseed is stored in the global memory
global iseed

% set iseed and make sure the set 
% value of iseed is an integer value
new_seed = round(new_seed);
iseed = abs(new_seed);