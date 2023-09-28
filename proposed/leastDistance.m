clc;
clear;
close all;
tic
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

rngTasks = 10;
rngDevices = 20;

%% Problem Defination

% create tasks
data = createTasks (NumberOfJobs,NumberOfTasks, rngTasks);

%% Main

devices = createDevices(NumberOfDevices, rngDevices);
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
    [~,index] = sort(dev(:,8), 'descend' );
    sortedDev = dev(index, :);


    sortedSelectedDev = sortedDev (1:NumberOfTasks,:);
    

for i=1:1
    
    b= zeros(NumberOfTasks, NumberOfAccesibleDevices+1);
    index = randperm(NumberOfTasks*NumberOfAccesibleDevices, NumberOfTasks);
    b(index) =1;
    a = Objective (NumberOfTasks, NumberOfTasks , data,sortedSelectedDev, b)
   
end
toc






