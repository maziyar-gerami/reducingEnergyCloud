clc;
clear;
close all;
rng(1);
t=cputime;
%% Parameters
NumberOfDevices = 500;              % Number Of all Devices

%base device power and battery
basePower = 8000;                   %Mips
baseBattery = 50;                   %Battery Percentage

NumberOfJobs = 1;
NumberOfTasks = 100;


emptyData.nInstructions=[];
emptyData.Vin=[];
emptyData.Vout=[];

data = repmat(emptyData, 1, NumberOfTasks);

%% Problem Defination

for i=1:NumberOfTasks

    data(i).nInstructions = randi(100000);         %number of instructions
    data(i).Vin = randi(10, NumberOfJobs);         % V in megabit
    data(i).Vout = randi(10, NumberOfJobs);         % V out megabit


end

%% Main

devices = createDevices(NumberOfDevices);
NumberOfAccesibleDevices = length (devices);

selectedDevicesIdx = randperm(NumberOfAccesibleDevices,NumberOfTasks);

SelectedDev = devices (selectedDevicesIdx);
    
b = zeros(NumberOfTasks, NumberOfAccesibleDevices+1);
index = randperm(NumberOfTasks*NumberOfAccesibleDevices, NumberOfTasks);
b(index) =1;
[CompleteTime, Energy] = Objective (NumberOfTasks, NumberOfTasks , data,SelectedDev, b)

cpuTime = cputime-t





