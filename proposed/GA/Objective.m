function [ energy ] = Objective( nTasks , nDevices, Data,devices , b )
%OBJECTIVE Summary of this function goes here
%   Detailed explanation goes here

m=nDevices;
n = nTasks;
consumedE=  zeros(nDevices,1);



%% Computing EnergyConsumtion

% et: Energy consumption on Rj to transfer one unit of data
    % L = 20 log(d) + 20 log(f) + 36.6 : this is the radio theory
    % where L is power in db, d is distance in mile and f is frequency in MHZ
    % we can convert L to Power in watt using:
                % P(W) = 10^(dBm/ 10) / 1000
    %f is: 2.4Ghz or 2400 Mhz
    

    f = 2400;
for j=1:m
    
    L = 20*(devices(j,8)/1600) + 20*log(f) +36.6;
    et(j) = 10^(L/10)/1000;
    
end

% e: Actually this is e%et; I computed them in one place
for i=1:n

    for j=1:m
        
        e(i,j) = (Data(i).nInstructions / devices(j,1))/devices(j,3);
        
    end
end
  
for j=1:m
   
    if j==m
        
        for i=1:n
           
            consumedE(j) = consumedE(j)+ b(i,j)*e(i,j);
            
            for k=1:m-1
               
                for l=1:n
                   
                    consumedE(j) = consumedE(j) + b(i,j)*devices(j,9)*Data(i).Vin;
                    
                end
                
            end
            
            
        end
        
    else
        
        for i=1:n
           
            consumedE(j) = consumedE(j) + b(i,j)*devices(j,9)*Data(i).Vout;
            
            
        end
        
        
    end
    
end

energy = sum (consumedE);
    
    
end





