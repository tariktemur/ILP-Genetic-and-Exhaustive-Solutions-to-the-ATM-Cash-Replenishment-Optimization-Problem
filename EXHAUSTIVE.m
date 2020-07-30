function [S, C] = EXHAUSTIVE(n, d, Eyes)

%This is a piece of art.
%Exhaustively solve the problem for n ATM's and d days,
%The return values are [Solution, Cost]
    
    global N;
    global D;
    
    global cnt;
    cnt = 0; 
    
    global number_of_iterations; 
    number_of_iterations = 2^((n * (d - 1)));
    %number_of_iterations = number_of_iterations - mod(number_of_iterations, 1000);
    
    global wbar;
    wbar = waitbar(0, "Beginning Computation...");
    
    D = d; 
    N = n; 
    [S,C] = terribleSolution();

    %placeholder

    
    function [Sol_Matrix, Cost] = terribleSolution()
        %The first row will be kept constant

        solMat = zeros([D,N]); 
        solMat(1,:) = ones([1,N]);

        solMat = solMat.';
        solMat = reshape(solMat, [1, N*D]);

        [Sol_Matrix, Cost] = recFindBest(N + 1, solMat);  

        Sol_Matrix = reshape(Sol_Matrix, [N,D]); 
        Sol_Matrix = Sol_Matrix.';

    end 


    function cost = value(solInstance)
        loadCost = get_load_costs(n);
        
        solMat = reshape(solInstance, [N, D]);
        solMat = solMat.';

        cost = 0;
        daystart = 0; 
        dayend = 0; 

        for j = 1:N
            for i = 1:D
                if(solMat(i,j) == 1)
                    daystart = i;
                    while((i ~= D) && (solMat(i+1, j) ~= 1))
                        i = i + 1; 
                    end 
                    dayend = i; 
                end 
                cost = cost + Eyes(daystart, dayend, j); 
            end     
        end 

        for i = 1:D
            number_of_atms_loaded = sum(solMat(i, :)); 
            if(number_of_atms_loaded > 0)
                cost = cost + loadCost(sum(solMat(i,:)));
            end 
        end 

    end


    function [solutionMatrix, c] = recFindBest(i, solInstance)
                
        if (i > N * D)
            c = value(solInstance); 
            solutionMatrix = solInstance;
            return;
        end
        
        solInstance(i) = 0; 
        [solInst1, c1] = recFindBest(i + 1, solInstance); 

        solInstance(i) = 1;
        [solInst2, c2] = recFindBest(i + 1, solInstance); 

        c = min(c1, c2); 

        %disp([c1, c2])

        if(c1 == c)
            solutionMatrix = solInst1; 
            return; 
        end 
        solutionMatrix = solInst2; 
        
        cnt = cnt + 1;
        if(mod(cnt, 8192) == 0)
            percentage = cnt / number_of_iterations;
            waitbar(percentage, wbar, sprintf("Computing the solution exhaustively: %d%% completed...", uint32(percentage * 100)));
        end
    end
    close(wbar);
end