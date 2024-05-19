function class = month_class(month)
% devide months into 3 classes
if month==1||month==3||month==5||month==7||month==8||month==10||month==12
    class = 1;
elseif month == 2
    class = 2;
else
    class = 3;
end