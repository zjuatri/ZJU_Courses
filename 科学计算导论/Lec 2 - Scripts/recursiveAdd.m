function recursiveAdd(nToAdd)
% Adds a number to the input up to
% a value of 25
 
if nToAdd<25
    nToAdd = nToAdd+1;
    disp(nToAdd)
    recursiveAdd(nToAdd);
end
