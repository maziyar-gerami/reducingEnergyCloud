function [ selectedPop ] = createDevices( NumberOfDevices, rngDevices )
%CREATEDEVICES Creates mobile devices with ther features

rng(rngDevices);

%% Parameters
Technologies(1).Type = 1;           % 1=edge 
Technologies(1).min = 0.6;
Technologies(1).max = 1.7;

Technologies(2).Type = 2;           % 2=3g
Technologies(2).min = 0.85;
Technologies(2).max = 0.9;

Technologies(3).Type = 3;           % 4=WiFi
Technologies(3).min = 0.95;
Technologies(3).max = 0.97;


nTechnologies = length(Technologies);

processingPowerBase = 500;
maximumNumberForProcessing = 5;

minimumBattery = 15;
maximumBattery = 100;

minimumBw = 11 ; %Megabits
maximumBW = 30; %Megabites

minimumPower = 40;
maximumPower = 110;

maximumDistance = 50;
accessibleDistance = 32;

Device.processingPower = [];
Device.battreyLevel = [];
Device.power = [];
Device.Technology =[];
Device.BW = [];
Device.X =[];
Device.Y =[];
Device.Distance = [];

pop = repmat(Device, NumberOfDevices,1);

%% Create Devices

for i=1:NumberOfDevices
    
    pop(i).processingPower = processingPowerBase* randi(maximumNumberForProcessing);
    pop(i).battreyLevel = randi([minimumBattery, maximumBattery]);
    pop(i).BW = randi([minimumBw, maximumBW]);
    pop(i).power = randi([minimumPower, maximumPower]);
    pop(i).Technology = randi(nTechnologies);
    pop(i).EnergyConsumptionPerBit = Technologies(pop(i).Technology).min + (Technologies(pop(i).Technology).max- Technologies(pop(i).Technology).min)*rand;
    pop(i).X = randi([-maximumDistance,maximumDistance]);
    pop(i).Y = randi([-maximumDistance,maximumDistance]);
    pop(i).Distance = sqrt(pop(i).X^2 + pop(i).Y^2);
    X(i) = pop(i).X;
    Y(i) = pop(i).Y;
    
end

%% Plot

idx = sqrt(X.^2 + Y.^2) <accessibleDistance;

scatter(X(~idx),Y(~idx), 'r');
hold on
scatter(X(idx),Y(idx), 'g');

hold on

circle(0,0, accessibleDistance);

counter = 1;
for i=1:length(pop)
   
    if pop(i).Distance <accessibleDistance
        selectedPop(counter) = pop(i);
        counter = counter +1;
    end
    
end



