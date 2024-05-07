function lines(a,b,c,d,e,f)
    if a*e == b*d
        if a*f == c*d
            sprintf('The lines are coincident, the solutions is (x,y) satisfying %f x +%f y = %f',a,b,c)
        else
            disp('The lines are parallel')
        end
    else
        x = (c * e - b * f) / (a * e - b * d);
        y = (a * f - c * d) / (a * e - b * d);
        sprintf("x = %f , y = %f",x,y)
    end