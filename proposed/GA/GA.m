clc;
clear;
close all;
%% Parameters
NumberOfDevices = 100;              % Number Of all Devices

%base device power and battery
basePower = 8000;                   %Mips
baseBattery = 50;                   %Battery Percentage

NumberOfJobs = 1;
NumberOfTasks = 20;

rngTasks = 10;
rngDevices = 20;

emptyData.nInstructions=[];
emptyData.Vin=[];
emptyData.Vout=[];

data = repmat(emptyData, 1, NumberOfTasks);

bestQuality =-inf;

%% Problem Defination

% create tasks
data = createTasks (NumberOfJobs,NumberOfTasks, rngTasks);
% create task
devices = createDevices(NumberOfDevices, rngDevices);
NumberOfAccesibleDevices = length (devices);
%% Genetic Parameters
nPop = 20;             %Number of population

pc=0.8;                 % Crossover Percentage
nc=2*round(pc*nPop/2);  % Number of Offsprings (Parnets)

pm=0.3;                 % Mutation Percentage
nm=round(pm*nPop);      % Number of Mutants

mu=0.02;                % Mutation Rate

emptyPop.Position = [];
emptyPop.Index =[];
emptyPop.Energy = [];


MaxIt =20;

%% Initialization

pop = repmat (emptyPop, 1, nPop);

%%create initilization population
for i=1:nPop
    
    Position= zeros(NumberOfTasks, NumberOfAccesibleDevices+1);
    index = randperm(NumberOfTasks*NumberOfAccesibleDevices, NumberOfTasks);
    pop(i).Index = index;
    Position(index) =1;
    Position = sparse(Position);
    pop(i).Position = Position;
    pop(i).Energy = Objective (NumberOfTasks, NumberOfDevices , data,devices, Position);
   
end

index = sort(pop(:).Energy);

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
    
    pop=[pop         popc         popm];
    
    [value, index] = Topsis(pop);

    % sort pop
    pop=pop(index);

    %assign their costs
    for i=1:length(pop)

        pop(i).Quality =  value(i);

    end
             
    % Best Solution Ever Found
    BestSol=pop(1);

    % Array to Hold Best Costs
    BestCost=zeros(MaxIt,1);
    
    % Update best quality
    bestQuality=max(bestQuality,pop(end).Quality);
    
    % Truncation
    pop=pop(1:nPop);
    value = value(1:nPop);
    
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

