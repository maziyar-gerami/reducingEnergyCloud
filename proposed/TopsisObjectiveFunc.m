function [ ConsumedEnergy ] = TopsisObjectiveFunc(Weight, preDev,dev,NumberOfTasks,NumberOfAccesibleDevices,data )

    [value, index] = Topsis(Weight,preDev);
    
    % sort devices according to their quality
    sortedDev = dev(index, :);
    sortedDev(:,10) = value;
    
    % Select nTask one of the best devices and sort them according to
    % proccessing Power
    selectedDev = sortedDev(1:NumberOfTasks,:);
    [~,index] = sort(selectedDev(:,1), 'descend' );
    sortedSelectedDev = selectedDev (index,:);
     
    b= zeros(NumberOfTasks, NumberOfAccesibleDevices+1);
    index = randperm(NumberOfTasks*NumberOfAccesibleDevices, NumberOfTasks);
    b(index) =1;
    ConsumedEnergy = Objective (NumberOfTasks, NumberOfTasks , data,sortedSelectedDev, b);

end

