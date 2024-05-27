function ran = rand0(m,n)
% RAND0 Generate uniform random numbers in [0,1)

% iseed is a variable located in global memory
% iseed stores the current seed 
% (to be used for computing the next random integer)
global iseed

% Check if number of input arguments are not 1 or 2
msg = nargchk(1,2,nargin);
error(msg);

% If number of arguments is 1, set n equal to m
if nargin < 2
    n = m;
end

% Initialization of output argument
ran = zeros(m,n);

% Compute randomly looking numbers by iteratively
% calling the mod function on the current seed
for ii = 1:m
    for jj = 1:n
        iseed = mod (8121*iseed + 28441,134456);
        ran(ii,jj) = iseed/134456;
    end
end