function data = createTasks( NumberOfJobs, NumberOfTasks, rngTasks)

rng(rngTasks);

emptyData.nInstructions=[];
emptyData.Vin=[];
emptyData.Vout=[];

data = repmat(emptyData, 1, NumberOfTasks);

for i=1:NumberOfTasks

    data(i).nInstructions = randi(100000);         %number of instructions
    data(i).Vin = randi(10, NumberOfJobs);         % V in megabit
    data(i).Vout = randi(10, NumberOfJobs);         % V out megabit
    
end

[~,index] = sort([data(:).nInstructions], 'descend' );
data = data(index);

end

