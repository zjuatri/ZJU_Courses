function [mpay, tpay] = loan(amount, rate, years)
% loan calculates monthly and total payment of a loan.
% Example 10-1
% Input arguments:
%   amount   loan amount in $
%   rate     annual interest rate in percent
%   years    number of years
% Output arguments:
%   mpay     monthly payment
%   tpay     total payment

format bank
ratem = rate*0.01/12;
a = 1+ratem;
b = (a^(years*12)-1)/ratem;
mpay = amount*a^(years*12)/b;
tpay = mpay*years*12;