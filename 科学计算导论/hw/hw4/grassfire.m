function distance = grassfire(occupancy, dest_row, dest_col)

[num_rows, num_cols] = size(occupancy);

distance_old = occupancy * Inf;
distance = occupancy * Inf;

distance(dest_row, dest_col) = 0;

directions = [-1 0; 1 0; 0 -1; 0 1];

queue = [];
queue(1, :) = [dest_row, dest_col];

while ~isempty(queue)
    current_row = queue(1, 1);
    current_col = queue(1, 2);
    queue(1, :) = [];

    for i = 1:size(directions, 1)
        neighbor_row = current_row + directions(i, 1);
        neighbor_col = current_col + directions(i, 2);

        if (neighbor_row > 0 && neighbor_row <= num_rows) && (neighbor_col > 0 && neighbor_col <= num_cols) && occupancy(neighbor_row, neighbor_col)
            if distance(neighbor_row, neighbor_col) > distance(current_row, current_col) + 1
                distance(neighbor_row, neighbor_col) = distance(current_row, current_col) + 1;
                queue(end+1, :) = [neighbor_row, neighbor_col];
            end
        end
    end


    if all(distance == distance_old)
        break;
    end

    distance_old = distance;
end
end