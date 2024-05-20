function rank=Scores_ranking(n)
% I don't think the parameter n is necessary.
rank = load('score.txt');
len = size(rank,1);
count = 0;
room = 0;

% find out the room for each student
for i = 1 : len
    if rem(count,5) == 0
        room = room + 1;
    end
    rank(i,3) = room;

    if rem(count+1,5) == 0
        local_rank = 5;
    else
        local_rank = rem(count+1,5);
    end

    rank(i,4) = local_rank;
    count = count + 1;
end

% bubble sort
for i = 1:len-1
    for j = 1:len-i
        if rank(j,2) < rank(j+1,2)
            temp = rank(j,:);
            rank(j,:) = rank(j+1,:);
            rank(j+1,:) = temp;
        end
    end
end

% final rank
for i = 1:len-1
    if rank(i,2)==rank(i+1,2)
        if rank(i,1) > rank(i+1,1)
            temp = rank(i,:);
            rank(i,:) = rank(i+1,:);
            rank(i+1,:) = temp;
        end
        rank(i,5) = i;
        rank(i+1,5) = i;
    else
        rank(i+1,5) = i+1;
    end
end
end