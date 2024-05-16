function out = narcissistic(x)
out = 'False';
    function arr = find()
        arr=[];
        for i = 100:999
            a = rem(i,10);
            b = (rem(i,100)-rem(i,10))/10;
            c = (i-rem(i,100))/100;
            if a^3+b^3+c^3==i
                arr(end+1) = i;
            end
        end
    end
for nar = find()
if nar == x
    out = 'True';
end
end
end