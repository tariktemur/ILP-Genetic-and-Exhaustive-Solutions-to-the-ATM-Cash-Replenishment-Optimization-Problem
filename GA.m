function [iter, solution, cost, exhaustiveSoln, exhaustiveCost] = GA(n, d, harshness, m,r, max_iterations)

%P <-- Population size
%m <-- mutation likelihood
%r <-- interest rate
%harshness <-- What percentage of the population we want to cross-breed,
%i.e how harsh the environment is

global P; 
global D;
global N;
global Eyes; 
 
D = d; 
N = n;
Eyes = experiment(N,D,r);
P = D*D*N*N;

% cap the population size for computational efficiency
if (P > 10000)
    P = 10000;
end
    function child = crossOver(mom, dad)    
        % graphic depiction of passionate sex
        % go over the whole kid, flip a coin, if its heads take the gene
        % from daddy, if its tails take it from mommy
        
        child = zeros([D, N]);
        child(1,:) = ones([1,N]);
        
        for i = 2:D
            for j = 1:N
                if rand() < 0.5
                    child(i,j) = dad(i,j);
                else
                    child(i,j) = mom(i,j);
                end
            end
        end
        
    end

    function pop = generatePopulation()

        pop = zeros([D,N,P]);
        for i = 1:P
            pop(:,:,i) = randi([0 1], D, N);
            pop(1,:,i) = ones([1,N]);
        end 

    end

    function s = mutate(s)

        % graphic depiction of the effects of radioactive waste
        % pretty shitty way to mutate though, might change it
        i = randi(D);
        j = randi(N);
        
        if(i > 1)
            s(i,j) = ~s(i,j);
        end
    end

    function cost = fitness(specimen)
        cost = 0;
        daystart = 0; 
        dayend = 0;
        
        loadcosts = get_load_costs(n);
        %loadcosts = loadcosts * 100;

        for j = 1:N
            for i = 1:D
                if(specimen(i,j) == 1)
                    daystart = i;
                    while((i ~= D) && (specimen(i+1, j) ~= 1))
                        i = i + 1; 
                    end 
                    dayend = i; 
                end 
                cost = cost + Eyes(daystart, dayend, j); 
            end     
        end 

        for i = 1:D
            alpha = sum(specimen(i,:));
            if alpha == 0
                continue
            elseif alpha > 15
                disp("This shouldn't have happened.");
            else 
                cost = cost + loadcosts(alpha);
            end
        end 

    end



% The main evolution loop
population = generatePopulation();

history = zeros(1);
iter = 1;
score = zeros([1,P]);

number_of_iterations = 0; 

while (number_of_iterations < max_iterations)
    
    number_of_iterations = number_of_iterations + 1;
    prevfit = score;
    fit = zeros([1,P]);
       
    % get fitness scores
    for member = 1:P
        fit(member) = fitness(population(:,:,member));
    end
    

    [score, idx] = sort(fit);
    
    % termination
    if ((mean(score(:,1:fix(P*0.05))) - mean(prevfit(:,1:fix(P*0.05))) == 0))
        break;
    end
    
    history(iter) = score(1);
    iter = iter + 1; 
    
    newbreed = zeros([D,N,fix(P*harshness)]);
    
    % cross over loop
    for sex = 1:2:(fix(P*harshness*2))
        newbreed(:,:,fix(sex/2)+1) = crossOver(population(:,:,idx(sex)), population(:,:,idx(sex+1)));
    end
    
    % mutation loop
    for member = 1:P
        if rand() < m
            population(:,:,member) = mutate(population(:,:,member));
        end
    end
    
    population = cat(3,newbreed, population(:,:,1:end - fix(P*harshness)));
    
end

solution = population(:,:,idx(1));
cost = fitness(solution);

exhaustiveSoln = zeros([D,N]);
exhaustiveCost = -1;

fprintf("The Genetic Algorithm solution is: %d\n", cost)

if(N*D <= 0)
     [exhaustiveSoln, exhaustiveCost] = EXHAUSTIVE(N,D,Eyes);
     fprintf("The Exhaustive solution is: %d\n", exhaustiveCost);
else
     disp("Exhaustive solution is too expensive to calculate.");
end
    plot(history)
end
