clc;
clear;
close all;
profile on
rng(2);
t=cputime;
%% Problem Parameters
NumberOfDevices = 100;              % Number Of all Devices

%base device power and battery
basePower = 8000;                   %Mips
baseBattery = 50;                   %Battery Percentage

NumberOfJobs = 1;
NumberOfTasks = 100;

emptyData.nInstructions=[];
emptyData.Vin=[];
emptyData.Vout=[];

data = repmat(emptyData, 1, NumberOfTasks);

bestQuality =-inf;

%% Problem Defination

for i=1:NumberOfTasks

    data(i).nInstructions = randi(100000);         %number of instructions
    data(i).Vin = randi(10, NumberOfJobs);         % V in megabit
    data(i).Vout = randi(10, NumberOfJobs);         % V out megabit


end

%% Memetic Parameters
nPop = 20;             %Number of population

pc=0.8;                 % Crossover Percentage
nc=2*round(pc*nPop/2);  % Number of Offsprings (Parnets)

pm=0.3;                 % Mutation Percentage
nm=round(pm*nPop);      % Number of Mutants

mu=0.02;         % Mutation Rate


lambda=0.5;       % percentage of selection

eta=2;          % a

localImprPopSize = 2*round(lambda*nPop/2);

emptyPop.Position = [];
emptyPop.Index =[];
emptyPop.CompleteTime = [];
emptyPop.Energy = [];
emptyPop.Quality = [];

MaxIt =20;

%% Initialization

devices = createDevices(NumberOfDevices);
NumberOfAccesibleDevices = length (devices);

pop = repmat (emptyPop, 1, nPop);

%%create initilization population
for i=1:nPop
    
    Position= zeros(NumberOfTasks, NumberOfAccesibleDevices+1);
    index = randperm(NumberOfTasks*NumberOfAccesibleDevices, NumberOfTasks);
    pop(i).Index = index;
    Position(index) =1;
    Position = sparse(Position);
    pop(i).Position = Position;
    [pop(i).CompleteTime, pop(i).Energy] = ...
        Objective (NumberOfTasks, NumberOfTasks , data,devices, Position);
   
end


[value, index] = Topsis(pop);


% sort pop
pop=pop(index);

%assign their costs
for i=1:nPop

	pop(i).Quality =  value(i);

end
             
% Best Solution Ever Found
BestSol=pop(1);

% Array to Hold Best Costs
BestCost=zeros(MaxIt,1);


%% Main loop

for it=1:MaxIt
    
    P=value/sum(value);
    
    % Crossover
    popc=repmat(emptyPop,nc/2,2);
    for k=1:nc/2
        
        %  Select Parents Indices
        i1=RouletteWheelSelection(P);
        i2=RouletteWheelSelection(P);

        % Select Parents
        p1=pop(i1);
        p2=pop(i2);
        
        Position = zeros(NumberOfTasks,NumberOfAccesibleDevices+1);
        % Apply Crossover          
        [popc(k,1).Index, popc(k,2).Index]= ...
            Crossover(p1.Index,p2.Index);
        Position(popc(k,1).Index) =1;
        popc(k,1).Position = sparse(Position);
        Position = zeros(NumberOfTasks,NumberOfAccesibleDevices+1);
        Position(popc(k,2).Index) =1;
        popc(k,2).Position = sparse(Position);
            
        % Evaluate Offsprings
        [popc(k,1).CompleteTime, popc(k,1).Energy] = ...
            Objective (NumberOfTasks, NumberOfTasks , data,devices, popc(k,1).Position);

        [popc(k,2).CompleteTime, popc(k,2).Energy] = ...
            Objective (NumberOfTasks, NumberOfTasks , data,devices, popc(k,2).Position);
        
                 
    end
    
    popc = [popc(:,1); popc(:,2)];
    popc = popc';
    
    [value, index] = Topsis(popc);

    % sort pop
	popc=popc(index);

	%assign their costs
	for i=1:length(popc)

        popc(i).Quality =  value(i);

	end
           
    % Mutation
    popm=repmat(emptyPop,1,nm);
    
    for k=1:nm
        
        % Select Parent
        i=randi([1 nPop]);
        p=pop(i);
        
        Position = zeros(NumberOfTasks,NumberOfAccesibleDevices+1);
        % Apply Mutation           
        popm(k).Index =Mutate(p.Index,mu, NumberOfTasks,NumberOfAccesibleDevices);
        Position(popm(k).Index) =1;
        popm(k).Position = sparse(Position);
        
        [popm(k).CompleteTime, popm(k).Energy] = ...
            Objective (NumberOfTasks, NumberOfTasks , data,devices, popm(k).Position);
        
    end
    
    pop=[pop         popc         popm]; %#ok
     
	[value, index] = Topsis(pop);

	% sort pop
	pop=pop(index);

	%assign their costs
	for i=1:length(pop)

        pop(i).Quality =  value(i);

    end
    
	% Local Improver
	poplmt=repmat(emptyPop,1,localImprPopSize);
    poplm = [];
    
    
	if ~mod(it, eta)
            
        for itm=1:localImprPopSize

            %  Select Parents Indices
            i1=RouletteWheelSelection(P);
            i2=RouletteWheelSelection(P);

            % Select Parents
            p1=pop(i1);
            p2=pop(i2);
            
            Position = zeros(NumberOfTasks,NumberOfAccesibleDevices+1);
            % Apply Crossover          
            [poplmt(itm,1).Index, poplmt(itm,2).Index]= ...
                Crossover(p1.Index,p2.Index);
            Position(poplmt(itm,1).Index) =1;
            poplmt(itm,1).Position = sparse(Position);
            Position = zeros(NumberOfTasks,NumberOfAccesibleDevices+1);
            Position(poplmt(itm,2).Index) =1;
            poplmt(itm,2).Position = sparse(Position);
            
            % Evaluate Offsprings
            [poplmt(itm,1).CompleteTime, poplmt(itm,1).Energy] = ...
                Objective (NumberOfTasks, NumberOfTasks , data,devices, poplmt(itm,1).Position);

            [poplmt(itm,2).CompleteTime, poplmt(itm,2).Energy] = ...
                Objective (NumberOfTasks, NumberOfTasks , data,devices, poplmt(itm,2).Position);

            popLocalImpr = repmat(emptyPop,1,2); 
            % Apply Mutation
            for k=1:2
    
                % Select Parent
                p=poplmt(itm,k);
                
                Position = zeros(NumberOfTasks,NumberOfAccesibleDevices+1);
                % Apply Mutation           
                popLocalImpr(k).Index =Mutate(p.Index,mu, NumberOfTasks,NumberOfAccesibleDevices);
                Position(popLocalImpr(k).Index) =1;
                popLocalImpr(k).Position = sparse(Position);
                
                % Evaluate Mutant
                [popLocalImpr(k).CompleteTime, popLocalImpr(k).Energy] = ...
                    Objective (NumberOfTasks, NumberOfTasks , data,devices, popLocalImpr(k).Position);

            end
            
            
            poplm=[poplm popLocalImpr]; 
            
        end
            
        pop =[pop poplm];
            
    end
          
	[value, index] = Topsis(pop);

	% sort pop
	pop=pop(index);

	%assign their costs
	for i=1:length(pop)

        pop(i).Quality =  value(i);

	end
        
    % Update best quality
    bestQuality=max(bestQuality,pop(end).Quality);
    
    % Truncation
    pop=pop(1:nPop);
    value=value(1:nPop);
    
    % Store Best Solution Ever Found
    BestSol=pop(1);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Quality;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Complete Time = ' num2str(BestSol.CompleteTime) '	Best Energy = ' num2str(BestSol.Energy)]);
    
end

cpuTime = cputime-t
BestSol.CompleteTime
BestSol.Energy


