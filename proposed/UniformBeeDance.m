function y=UniformBeeDance(x,r)

    nVar=numel(x);
    
    dif = unifrnd(-r,r);
    
    flag=false;
    while(~flag)
        
        k=randperm(nVar,2);
        if dif< x(k(2))
            
           flag = true; 
        end
    end
    
    y=x;
    y(k(1))=x(k(1))+dif;
    y(k(2))=x(k(2))-dif;
end