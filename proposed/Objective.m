function [ energy ] = Objective( nTasks , nDevices, Data,devices , b )
%OBJECTIVE Summary of this function goes here
%   Detailed explanation goes here

m=nDevices;
n = nTasks;
consumedE=  zeros(nDevices,1);
%% Computing EnergyConsumtion

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





