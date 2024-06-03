function out = quicksort_v2(a)
% Sorts the components of an array (a) into ascending order



while(issorted(a)==0) %Continue loop if array is not in ascending order
    % if "a" has one element, already sorted

    if length(a) <= 1
        out= a;
    else
       % Define pivot by random number in "a"

        pivot= 1+floor(rand*(length(a)-1));
    
       % Find number of elements less than pivot & define S1 

        locationsless= logical(a<a(pivot)); 
        numberelementsless= sum(locationsless);       
        S1= zeros(1,numberelementsless);        
        S1= a(locationsless);   

        % Find number of elements equal to pivot & define S2 

        locationsequal= logical(a==a(pivot));
        numberelementsequal= sum(locationsequal);
        S2= zeros(1,numberelementsequal);
        S2= a(locationsequal);

        % Find number of elements greater than pivot & define S3 

        locationsgreater= logical(a>a(pivot));
        numberelementsgreater= sum(locationsgreater);
        S3= zeros(1,numberelementsgreater);
        S3= a(locationsgreater);

        %quicksort S1 and S3 for recursion

        a =[quicksort_v2(S1) S2 quicksort_v2(S3)]; 
        
    end
end

out = a;
end

