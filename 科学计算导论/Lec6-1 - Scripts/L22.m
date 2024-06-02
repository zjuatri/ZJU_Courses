% Lecture 22 notes
%

%% Random number generation

% Each call to rand produces a different number
rand(1,10)

%%
rand(1,10)

%% Producing identical random sequences
rand('state',0)
rand
rand

%%
disp('Reset state to the original')
rand('state',0)
rand
rand

%% mean & median
d = randn(100,2);
mean(d)
median(d)
std(d)

%% hist
hist(d(:,1))
hist(d(:,1),20)
n = hist(d(:,1))

%% Example 22-1: Histogram with bar plot
     
test1_counts = [5 5 5 5 ];
test2_counts = [2 9 7 2];

% Specify bin centers
x = [64.5  74.5  84.5  94.5];
subplot(2,1,1)
bar(x, test1_counts)
axis([60 100 0 10])
title('Histogram of Scores for Test 1')
subplot(2,1,2)
bar(x, test2_counts)
axis([60 100 0 10])
title('Histogram of Scores for Test 2')


%% ...or we can just use the histogram command
t1 = [61 61 65 67 69 72 74 74 76 77 ...
      83 83 85 88 89 92 93 93 95 98];
t2 = [66 69 72 74 75 76 77 78 78 79 ...
      79 80 81 83 84 85 87 88 90 94];
% 10 bins (default value)
figure
hist(t1)
figure
hist(t2)


%% 4 bins
figure(2)
hist(t1,4)
figure(3)
hist(t2,4)


%% specify bin centers
figure(2)
hist(t1,x)
data1 = hist(t1,x)
figure(3)
hist(t2,x)
data2 = hist(t2,x)


%% Example 22-2: Breaking strength of thread

% Clear the previous figure
clf

% The data collected
y = [92	94	93	96	93	94	95	96	91	93 ...
     95	95	95	92	93	94	91	94	92	93];
 
% Outcomes: 91, 92, 93, 94, 95, 96
x = [91:96];

% Plot the histogram
hist(y, x)
axis([90 97 0 6]);
ylabel('Absolute frequency');
xlabel('Thread Strength (N)');
title('Absolute Frequency Histogram for 20 Test s');


%% hist() is not as good for relative frequency plots
% Plotting relative frequency (n = 100)
% Value   91  92  93  94  95  96N
% Counts  13  15  22  19  17  14

% Data vector
y = [13  15  22  19  17  14];
x = [91:96];
n = 100;

% Use bar to plot relative frequencies
bar(x, y/n)
ylabel('Relative Frequency');
xlabel('Thread Strength (N)');
title('Relative Frequency Histogram for 100 Tests');


%% Probabilities and relative frequencies

% Probability of rolling 1-6 on a die = 1/6 = 16.67%

% Plot the theoretical probability
y = [16.67*ones(1,6)];
x = 1:6;
bar(x, y/100, 'w')
ylabel('Relative Frequency')
xlabel('Outcome')
hold on


%% Plot the experimental results from 100 tosses
counts = [21 14 18 16 19 12];
n = 100;
plot(x, counts/100, 'o-');
hold off
legend('Theory', 'Experiment')  


%% Example 22-3: Height distribution

y_abs = [1	0	0	0	2	4	5	4	8 ...
    11  12	10	9	8	7	5	4	4	3 ...
    1  1	0	1];
binwidth = 0.5;

% Compute total area
area = binwidth*sum(y_abs);

% Scale the frequency data
y_scaled = y_abs/area;

% Define the bins
bins = [64:binwidth:75];

% Plot the scaled histogram
bar(bins, y_scaled)
ylabel('Scaled Frequency');
xlabel('Height (in.)');


%% The cumsum function returns a vector whose
% elements are the cumulative sums of the previous elements
x = [2 5 3 8];
cumsum(x)


%% Apply this to the scaled data
% 66.5 is 6th value, 69 is 11th value
prob = cumsum(y_scaled)*binwidth
prob67_69 = prob(11) - prob(6)

% 
%% Create y_raw with raw data
y_raw = [];
for i = 1:length(y_abs)
    if y_abs(i) > 0
        new = bins(i)*ones(1, y_abs(i));
    else
        new = [];
    end
    y_raw = [y_raw, new];
end

% Compute the mean and standard deviation
mu = mean(y_raw)
sigma = std(y_raw)


%% Example 22-4: Estimation of height distribution

% Uses mu and sigma from Ex21-3
% How many or no taller than 68 in.?
b1 = 68;
P1 = (1+erf((b1-mu)/(sigma*sqrt(2))))/2


%% How many are within 3 in. of the mean?
a2 = mu - 3;
b2 = mu + 3;
P2 = (erf((b2-mu)/(sigma*sqrt(2)))...
    -erf((a2-mu)/(sigma*sqrt(2))))/2


%% Using rand to simulate coin tossing
for i=1:50
    if rand<0.5
        fprintf('H')
    else
        fprintf('T')
    end
end
fprintf('\n')

 
%% Simulation of dice throwing

% Generate a vector of simulated throws
throws = floor(6*rand(1,10) + 1);
values = [1:6];

% Plot the histogram
hist(throws, values)


%% Example 22-5: Sailor's Night Out

% Initialize variables
n = input('Number of walks: ');
nsafe = 0; % number of times he makes it

% Repeat n simulated walks down the pier
for i = 1:n
    % Start at the land end
    steps = 0; x = 0; y = 0;

    % While still on the pier and still alive
    while (x <= 50) & ((abs(y) <= 10) & (steps < 10000))
        steps = steps + 1;
        % Get a random number r
        r = rand;
        % If r<0.6 then move forward
        if r<0.6
            x = x+1;
        % Else if r<0.8 move left
        elseif r<0.8
            y = y+1;
        % Otherwise move right
        else
            y = y-1;
        end
    end
    
    % If still alive count walk as a success
    if x>50
        nsafe = nsafe+1;
    end
end

% Print estimated probability of reaching the ship
prob = 100*nsafe/n;
fprintf('Estimated probabilty of reaching the ship %3.1f\n', prob);
