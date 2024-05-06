
%% Example 3 Seive of Eratosthenes (v1)
% A script for finding all of the prime numbers between 2 and n
% See Wikipedia for a useful description of this algorithm
%

n = 1000;
% Initialize the list of numbers
numbers = 2:n;
% Initialize the list of primes
primes = [];
% If the last prime number we found is greater than the square root of n we are done - all
% remaining numbers in the list will be primes.
while 1
    % Get the first number in the list - this will be a prime number
    prime = numbers(1);
    % Add the number to the list of primes
    primes(end+1) = prime;
    % remove all multiples of the last prime number from the list of numbers
    numbers = numbers (rem(numbers,prime) ~= 0);
    if (prime*prime > n)
        % Note that this break statement breaks us out of the enclosing
        % while loop
        break;
    end
end
% All remaining numbers in the list must be primes so we add them to the
% list
primes = [primes numbers];
disp(primes)



%% Example 4 Seive of Eratosthenes (v2)
% A script for finding all of the prime numbers between 2 and n
% See Wikipedia for a useful description of this algorithm
%

n = 1000;

% Initialize the list of numbers
numbers = 2:n;

% Initialize the list of primes
primes = [];

% The first number in the list must be prime. If this number is greater
% than the square root of n we are done. Note that we first check whether
% the list is empty so that we don't index into an empty list by accident.
% Note the use of the short circuiting && in this case.

while (~isempty(numbers) && (numbers(1)^2 <= n))
    
    % The first number in the list will be a prime 
    prime = numbers(1);
    
    % Add this number to the list of primes
    primes(end+1) = prime;
    
    % Remove all multiples of the last prime number from the list of numbers
    numbers = numbers (rem(numbers,prime) ~= 0);
    
end

% All remaining numbers in the list must be primes so we add them to the
% list

primes = [primes numbers];
disp(primes);