function weight = ba(preDev,dev,NumberOfTasks,NumberOfAccesibleDevices,data)
%% Problem Definition

CostFunction=@(x) TopsisObjectiveFunc(x, preDev,dev,NumberOfTasks,NumberOfAccesibleDevices,data);        % Cost Function

nVar=5;             % Number of Decision Variables

VarSize=[1 nVar];   % Decision Variables Matrix Size

VarMin=0;         % Decision Variables Lower Bound
VarMax= 0.5;         % Decision Variables Upper Bound

%% Bees Algorithm Parameters

MaxIt=15;          % Maximum Number of Iterations

nScoutBee=20;                           % Number of Scout Bees

nSelectedSite=round(0.5*nScoutBee);     % Number of Selected Sites

nEliteSite=round(0.4*nSelectedSite);    % Number of Selected Elite Sites

nSelectedSiteBee=round(0.5*nScoutBee);  % Number of Recruited Bees for Selected Sites

nEliteSiteBee=2*nSelectedSiteBee;       % Number of Recruited Bees for Elite Sites

r=0.1*(VarMax-VarMin);	% Neighborhood Radius

rdamp=0.6;             % Neighborhood Radius Damp Rate

%% Initialization

% Empty Bee Structure
empty_bee.Position=[];
empty_bee.Cost=[];

% Initialize Bees Array
bee=repmat(empty_bee,nScoutBee,1);

% Create New Solutions
for i=1:nScoutBee
    
    rp = randperm(nVar-1);
    Sum = 0;
    Max = VarMax;
    
    for j=1:nVar-1
        
        Rand = unifrnd(VarMin,Max,1);
        bee(i).Position(rp(j)) = Rand;
        Sum = Sum+ Rand;
        if Sum>0.5
            Max = 1-Sum;
        end
        
    end
    
    bee(i).Position(end+1) = 1-Sum;
    
    bee(i).Cost=CostFunction(bee(i).Position);
    
end

% Sort
[~, SortOrder]=sort([bee.Cost]);
bee=bee(SortOrder);

% Update Best Solution Ever Found
BestSol=bee(1);

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

%% Bees Algorithm Main Loop

for it=1:MaxIt
    
    % Elite Sites
    for i=1:nEliteSite
        
        bestnewbee.Cost=inf;
        
        for j=1:nEliteSiteBee
            newbee.Position=UniformBeeDance(bee(i).Position,r);
            newbee.Cost=CostFunction(newbee.Position);
            if newbee.Cost<bestnewbee.Cost
                bestnewbee=newbee;
            end
        end

        if bestnewbee.Cost<bee(i).Cost
            bee(i)=bestnewbee;
        end
        
    end
    
    % Selected Non-Elite Sites
    for i=nEliteSite+1:nSelectedSite
        
        bestnewbee.Cost=inf;
        
        for j=1:nSelectedSiteBee
            newbee.Position=UniformBeeDance(bee(i).Position,r);
            newbee.Cost=CostFunction(newbee.Position);
            if newbee.Cost<bestnewbee.Cost
                bestnewbee=newbee;
            end
        end

        if bestnewbee.Cost<bee(i).Cost
            bee(i)=bestnewbee;
        end
        
    end
    
    % Non-Selected Sites
    for i=nSelectedSite+1:nScoutBee
    
        rp = randperm(nVar-1);
        Sum = 0;
        Max = VarMax;

        for j=1:nVar-1

            Rand = unifrnd(VarMin,Max,1);
            bee(i).Position(rp(j)) = Rand;
            Sum = Sum+ Rand;
            if Sum>0.5
                Max = 1-Sum;
            end

        end
    
        bee(i).Position(end) = 1-Sum;

        bee(i).Cost=CostFunction(bee(i).Position);

    end
    
    % Sort
    [~, SortOrder]=sort([bee.Cost]);
    bee=bee(SortOrder);
    
    % Update Best Solution Ever Found
    BestSol=bee(1);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
    
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    % Damp Neighborhood Radius
    r=r*rdamp;
    
end

weight = BestSol.Position;

%% Results

figure;
%plot(BestCost,'LineWidth',2);
semilogy(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');

