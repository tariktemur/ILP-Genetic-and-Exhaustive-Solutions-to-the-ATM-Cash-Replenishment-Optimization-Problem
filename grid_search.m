function [exhaustive_solutions, GA_solutions, GA_iterations] = grid_search(max_N, max_D, harshness, interest_rate, maximum_iterations)

    exhaustive_solutions = zeros([max_N, max_D]);
    GA_solutions = zeros([max_N, max_D]);
    GA_iterations = zeros([max_N, max_D]);
    
    for i = 2:max_N
        for j = 2:max_D
            fprintf("Currently calculating for %d days and %d ATMs.\n", uint8(i), uint8(j));
            if(true)
                [iterations, ~, cost, ~, exhaustiveCost] = GA(i, j, harshness, .5, interest_rate, maximum_iterations);
                exhaustive_solutions(i,j) = exhaustiveCost; 
                GA_solutions(i, j) = cost;
                GA_iterations(i, j) = iterations;
            else
                exhaustive_solutions(i,j) = -1; 
                GA_solutions(i, j) = -1;
                GA_iterations(i, j) = -1;
            end
        end
    
end