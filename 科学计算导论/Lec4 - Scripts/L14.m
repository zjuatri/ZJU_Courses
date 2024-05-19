% Lecture 14 Files script
%

%% 14-1: input and disp commands
%

age_ = input('Please enter your age: ');
name_ = input('Please enter your name: ', 's');

disp(age_) %%display
disp(name_)
%%
disp(['Your name is ' name_ ' and your age is ' num2str(age_)]);

%%
abc = [5 9 1; 7 2 4];
disp(abc)
%%
a=5; b=8;
disp([a,b])

%%
disp('The problem has no solution!')


%% 14-2: Script with values entered when run
%
% Calculates average points scored in three games
%
game1 = input('Enter the points scored in the first game: ');
game2 = input('Enter the points scored in the second game: ');
game3 = input('Enter the points scored in the third game: ');

%%
ave_points = (game1+game2+game3)/3;
disp(' ') % display empty line
disp('Average of points scored in a game is:')
disp(' ')
disp(ave_points)


%% 14-3: table of data
%
yr = [1984 1986 1988 1990 1992 1994 1996];
pop = [127 130 136 145 158 178 211];
tableYP(:,1) = yr;
tableYP(:,2) = pop;
disp('        YEAR      POPULATION')
disp('                  (MILLIONS)')
disp(' ')
disp(tableYP)


%% 14-4: fprintf
%
fprintf('The problem, as entered, has no solution. Please check the input data.')

%% add \n
fprintf('The problem, as entered, has no solution. \nPlease check the input data.\n')


%% fprintf('text with number format', variable)
fprintf('MATLAB thinks pi is %5.2f\n', pi)

%%
fprintf('MATLAB thinks pi is %15.10f\n', pi)

%%
fprintf('MATLAB thinks pi is %9.4e\n', pi)

%%
fprintf('MATLAB thinks pi is %9.4f and e is %9.4f\n', pi, exp(1))


%%
x = 1:5;
y = sqrt(x);
T = [x; y]
fprintf('If the number is: %i, its square root is: %f\n', T)
% See Help for all the options


%% Example 1 temp_conversion
%  To convert an input temperature from degrees
%   Fahrenheit to an output temperature in kelvin.

% Prompt the user for the input temperature
temp_f = input('Enter the temperature in degrees Fahrenheit:');
% Convert to kelvin
temp_k = (5/9) * (temp_f - 32) + 273.15;
% Write out result
fprintf('%6.2f degrees Fahrenheit = %6.2f kelvin\n',temp_f, temp_k);


%% 14-5 save and load .mat files

clear;
a = 10;
b = [1 3 5 78 90];
c = [];

%% Save the environment in a file
save 'first';
clear;

%% reload the environment
load 'first';

%% Save specific variables
save 'second' a c;
clear

%% loading only specified variables
load 'second' c;


%% 14-6: Save to .txt files
clear
V = [3 16 -4]
A = [6 -2.1 15.5; -6.1 8 11]
save -ascii DataFile.txt
clear 


%% Load variables
var = load('DataFile.txt')
load('DataFile.txt')


%% 14-7: Working with Excel
data = xlsread('TestData')


%% 14-8 Reading and Writing comma separated values (CSV) filefiles

A = rand (20, 5)

%% Writing the data out to an ASCII comma seperated file
csvwrite ('csv1.csv', A);
clear;

%% Reading data back in
A = csvread ('csv1.csv');


%% 14-9 See also dlmwrite and dlmread to use delimiters other than commas
% Writing a tab delimited text file of numbers
dlmwrite ('data1.txt', A, 'delimiter', '\t', 'precision', '%.6f');
clear;

%%
A = dlmread ('data1.txt');


%% 14-10 Writing and reading raw files

% Open a file for writing
fid = fopen ('raw1', 'w');

% Create some data
A = rand(1,100);

%% Write the data to the file
fwrite (fid, A, 'double');

fclose (fid);

clear

%% open the file for reading
fid = fopen ('raw1');

A = fread (fid, Inf, 'double');

fclose (fid);


%% 14-11 A brief digression on cells (see text 11.5)
% Cells in a cell array can store practically anything which distinguishes
% them from arrays where the elements all store the same type of thing.

A = cell (2,2);

A{1,1} = [];

A{1,2} = 'foobar';

A{2,1} = 123.45;

A{2,2} = [1 2; 3 4];

celldisp (A)

%% Getting stuff out of a cell array
b = A{2,2}

%% Note the difference from the following call which returns a cell array
b = A(2,2)


%% 14-12 Reading a text file using textread
% This call reads the text file one string at a time and puts the results
% into a cell array

words = textread ('Football.txt', '%s');

% Count how many times the string 'Phillies', 'Rollins' appears.

count = 0;
for i = 1:length(words)
    if (strcmpi('Eagles', words{i}))
        count = count + 1;
    end
end

disp (count);