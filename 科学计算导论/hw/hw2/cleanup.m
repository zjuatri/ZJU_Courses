function y = cleanup(x)
y=[];
for i = 1:length(x)
    if x(i)<0 || x(i)>10
        y(end + 1)=NaN;
    else
        y(end + 1)=x(i);
    end
end