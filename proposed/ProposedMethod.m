clc;
clear;
close all;
tic
%% Parameters
NumberOfDevices = 100;              % Number Of all Devices

%base device power and battery
basePower = 8000;                   %Mips
baseBattery = 50;                   %Battery Percentage

NumberOfJobs = 1;
NumberOfTasks = 20;

rngTasks = 50;
rngDevices = 100;

%% Problem Defination

% create tasks
data = createTasks (NumberOfJobs,NumberOfTasks, rngTasks);
% create task
devices = createDevices(NumberOfDevices, rngDevices);
NumberOfAccesibleDevices = length (devices);

%% Main
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

    % important data
    preDev = dev(:, [1,5,8,9]);
    % find the best weighs for Topsis
    
    Weight = ba(preDev,dev,NumberOfTasks,NumberOfAccesibleDevices,data);
    %1
    %Weight = [0.185084462350388,0.0300344353249500,0.00349963632651964,0.115571501665369,0.665809964332774];
    %2
    %Weight = [0.232433720604392,0.140919484901435,0.376268815573599,0.216001475569469,0.034376503351104];
    %3
    %Weight = [0.329330386234942,0.241035545023533,0.021540773750262,0.399597549771140,0.008495745220124];
    %4
    %Weight = [0.00973371250825778,0.161018580484338,0.0215075478932562,0.389643082687460,0.418097076426689];
    
    
    % Do Topsis
    [value, index] = Topsis(Weight,preDev);
    
    % sort devices according to their quality
    sortedDev = dev(index, :);
    sortedDev(:,10) = value;
    
    % Select nTask one of the best devices and sort them according to
    % proccessing Power
    selectedDev = sortedDev(1:NumberOfTasks,:);
    [~,index] = sort(selectedDev(:,1), 'descend' );
    sortedSelectedDev = selectedDev (index,:);

    histo = hist(sortedSelectedDev(:,4), unique(sortedSelectedDev(:,4)));
     
    b= zeros(NumberOfTasks, NumberOfAccesibleDevices+1);
    index = randperm(NumberOfTasks*NumberOfAccesibleDevices, NumberOfTasks);
    b(index) =1;
    a = Objective (NumberOfTasks, NumberOfTasks , data,sortedSelectedDev, b)
toc






