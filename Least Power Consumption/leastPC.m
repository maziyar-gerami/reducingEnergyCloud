clc;
clear;
close all;
rng(22);
%% Parameters
NumberOfDevices = 200;              % Number Of all Devices

%base device power and battery
basePower = 8000;                   %Mips
baseBattery = 50;                   %Battery Percentage

NumberOfJobs = 1;
NumberOfTasks = 50;


emptyData.nInstructions=[];
emptyData.Vin=[];
emptyData.Vout=[];

data = repmat(emptyData, 1, NumberOfTasks);

MaxIt = 40; %number of iteration for finding best coefficient

%% Problem Defination

for i=1:NumberOfTasks

    data(i).nInstructions = randi(100000);         %number of instructions
    data(i).Vin = randi(10, NumberOfJobs);         % V in megabit
    data(i).Vout = randi(10, NumberOfJobs);         % V out megabit


end

%% Main

devices = createDevices(NumberOfDevices);
NumberOfAccesibleDevices = length (devices);


%convert struct to matrix
for i=1:NumberOfAccesibleDevices
    
    dev(i,1) = devices(i).processingPower;
    dev(i,2) = devices(i).battreyLevel;
    dev(i,3) = devices(i).power;
    dev(i,4) = devices(i).Technology;
    dev(i,5) = devices(i).BW;
    dev(i,6) = devices(i).X;
    dev(i,7) = devices(i).Y;
    dev(i,8) = devices(i).Distance;
    dev(i,9) = devices(i).EnergyConsumptionPerBit;
    
end

    % sort devices according to their quality
    [~,index] = sort(dev(:,9), 'descend' );
    sortedDev = dev(index, :);


    sortedSelectedDev = sortedDev (1:NumberOfTasks,:);
    

for i=1:1
    
    b= zeros(NumberOfTasks, NumberOfAccesibleDevices+1);
    index = randperm(NumberOfTasks*NumberOfAccesibleDevices, NumberOfTasks);
    b(index) =1;
    a = Objective (NumberOfTasks, NumberOfTasks , data,sortedSelectedDev, b)
   
end






