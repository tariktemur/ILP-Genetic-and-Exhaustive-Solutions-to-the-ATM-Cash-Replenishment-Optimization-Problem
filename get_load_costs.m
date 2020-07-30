function loadcosts = get_load_costs(num)

    %loadcosts = [5,9,13,17,21,24,27,30,32,34,36,37,38,39,40]; 

    loadcosts = (1:num); 
    loadcosts = loadcosts.^(-1/2);

    loadcosts = loadcosts * 10;
    
    for i = 2:num
        loadcosts(i) = loadcosts(i) + loadcosts(i - 1); 
    end
       
end