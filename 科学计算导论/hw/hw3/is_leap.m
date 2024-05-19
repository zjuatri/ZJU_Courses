function result = is_leap(year)
if (rem(year,4) == 0 && rem(year,100) ~= 0) || rem(year,400)==0
    result = 1;
else
    result = 0;
end
end