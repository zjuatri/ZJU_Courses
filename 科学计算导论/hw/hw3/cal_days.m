function days = cal_days(month,isLeap)
% calculate days of a full month
days = 0;
monthClass = month_class(month);

if monthClass == 1
    days = days + 31;
elseif monthClass ==2
    if isLeap
        days = days+29;
    else
        days = days+28;
    end
else
    days = days + 30;
end
end