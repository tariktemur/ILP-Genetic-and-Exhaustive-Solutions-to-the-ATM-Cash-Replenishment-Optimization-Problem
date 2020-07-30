function Eyes = experiment(N, D, r)
    
    %yeah
    alpha = 5;
    
    for index = 1:N
        %if(index == 1)
         %   M = [100 200 100 300 100];
        %else
         %   M = [100 200 300 400 100];
        %end
        M = randi(1000, D, 1);
        I = zeros(D);
        IntCost = zeros(D);


        for i = 0:D-1
            IntCost(:,i+1) = (M * (1+r)^(i)) - M;
        end
        
        
        for i = 1:D
            for j = i+1:D
                IntCost(i,j) = 0;
            end
        end

        
        for i = 1:D
            for j = (i+1):D
               for k = 1:j
                   if(k >= i)
                       I(i,j) = IntCost(k, k-i+1) + I(i,j);
                   end
               end
            end
        end 
        
        Eyes(:,:,index) = I;
    end
    
end     