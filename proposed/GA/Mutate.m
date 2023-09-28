function x=Mutate(x,mu,NumberOfTasks,NumberOfAccesibleDevices)

    nVar=numel(x);
    
    nmu=ceil(mu*nVar);
    
    j=randsample(nVar,nmu);
    
    x(j)=randperm(NumberOfTasks*NumberOfAccesibleDevices, nmu);

end