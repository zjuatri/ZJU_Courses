# Introduction to Scientific Computing
## Statements
```matlab
foo = x^2 + sin(5*y) / exp(67*z);
```
The semicolon at the end is optional. 
## Built-in MATLAB functions
`sin(x)`,`cos(x)`,`exp(x)`,`log(x)`,`atan(x)`,`cosh(x)`,`sinh(x)`,`mean(x)`,`median(x)`,etc.
## Array
```matlab
x = [1,3,9,11,-10.2];
foo = x(3); % extracts third element in the array
x(2) = 27; % reassign element in the array

x = 1:15 % creates an array with the number 1 through 15
x = 4:2:28; % creates an array starting at 4 and going up by 2 until it gets to 28
x = -1.3:0.1:1.3; %creates an array starting at -1.3 and going up by 0.1 until it gets to 1.3

x = 1:2:6; % x = [1,3,5]
```

## Operations on arrays
```matlab
x = 0:0.1:10;
y = exp(5*x).*sin(x); % evaluate an expression on every element in the array x producing a new array called y
plot(x,y);

x = [1,2,3,4,5];
y = [7,8,9,10,11];
z = x + y; % element-wise addition adds corresponding elements
z = x.*y; % element-wise multiplication
z = x./y; % element-wise division
```
## Overflow
```matlab
X = uint8(78); Y = uint8(190);
Z = X + Y;
% overflow - value will be clipped to 255
```

## Scientific notation
Note that numbers in scientific notation have the following components
- A sign - positive or negative
- A mantissa(尾数) - ex. 2.13
- An exponent - ex. 17
e.g. +2.13e17

## Arrays and numerical types
When an array variable is created all of the numeric values in that array share the same numeric type. For example we can talk about an array of `uint16`s or an array of doubles.   
`x = single(0:0.1:100);`make an array of single precision（单精度） numbers

## A few useful MATLAB commands
- `whos`
Lists all of the variables currently in your workspace and shows you their types
- `clear`
Clears all of the variables in your workspace – you can also use this to clear specific variables
- `clc`
Just clears the command window – has no effect on the workspace

## Function
```matlab
function f = fact(n)
    f = prod(1:n);
end

function [output1,output2,output3] = myFunction(input1,input2,input3)
```
### Naming a Function
Must start with a letter from the alphabet
### Special Functions
```matlab
function out1 = testFunction(in1)
% A test function
% this would report, in the help function, all of functionality of the function
% in1 = function input (units: not specified)
% out2 = function output (units : not specified)
```
(in the command window)
```matlab
lookfor 'a test function'

% testFunction            - A test function

help testFunction

% A test 
% this would report, in the help function, all of functionality of the function
% in1 = function input (units: not specified)
% out2 = function output (units : not specified)
```
## Search paths
- The working folder at startup can be changed using the userpath function
```matlab
userpath('C:\ATRI')
```
- Paths can also be “permanently” added to the search path using the `addpath()` function
- Paths can be removed using the `rmpath()` function
## Commenting
- Highlight a selection or place your cursor on a line and press “ctrl+r” to comment a section or line of code, respectively
- “ctrl+t” uncomments the code
## Anonymous Function
```matlab
function_name = @ (arguments) expression

FtoC = @ (F) 5*(F-32)./9

% examples
FA = @ (x) exp(x^2)/sqrt(x^2+5)
FA(2)
FA = @ (x) exp(x.^2)./sqrt(x.^2+5)
FA([1 0.5 2])
```