function difference=The_date_difference(time1,time2)

% time1 = str2double(time1);
% time2 = str2double(time2);
% If input is in string format, use the statements above.

if time1 > time2
    temp = time2;
    time2 = time1;
    time1 = temp;
end

year1 = (time1 - rem(time1,10000))/10000;
year2 = (time2 - rem(time2,10000))/10000;
month1 = (time1 - year1*10000 - rem(time1,100))/100;
month2 = (time2 - year2*10000 - rem(time2,100))/100;
day1 = rem(time1,100);
day2 = rem(time2,100);
difference = 0;
first_diff = 0;
last_diff = 0;


% situation where year1 equals to year2
if year1 == year2
    % judge if the year is a leap year
    isLeap = is_leap(year1);

    for month = month1:month2-1
        % the cal_day function calculates days of a full month
        difference = difference + cal_days(month,isLeap);
    end
    difference = difference - day1 + day2 + 1;

else

    % consider the years except the first and the last
    for year = year1+1:year2-1

        % judge if the year is a leap year
        isLeap = is_leap(year);

        if isLeap
            difference = difference + 366;
        else
            difference = difference + 365;
        end
    end


    % consider the first year
    isLeap = is_leap(year1);
    for month = month1:12
        first_diff = first_diff + cal_days(month,isLeap);
    end
    first_diff = first_diff - day1 + 1;


    % consider the last year
    isLeap = is_leap(year2);
    for month = 1:month2-1
        last_diff = last_diff + cal_days(month,isLeap);
    end
    last_diff = last_diff + day2;
    difference = difference + first_diff + last_diff;
end
end