function [ value , index ] = Topsis(Weight,pop)


%% Parameters
A= pop;
W=[Weight(1), Weight(2), Weight(3),-Weight(4),-Weight(5)];
DM = A;

[na,nc]=size(DM);

SumDM=sum(DM.^2);
SqrtSumDM=sqrt(SumDM);


%% step 1

for c=1:nc
    
    DM(:,c)=DM(:,c)./SqrtSumDM(c);       
    
end


%% step 2

for c=1:nc 
   DM(:,c)=DM(:,c).*abs(W(c)); 
end

%% step 3

AP=zeros(1,nc);
AN=zeros(1,nc);

for c=1:nc
    
    if W(c)>0
    AP(c)=max(DM(:,c));
    AN(c)=min(DM(:,c));    
    else
    AP(c)=min(DM(:,c));
    AN(c)=max(DM(:,c));
    end
    
end



%% step 4

DP=zeros(na,1);
DN=zeros(na,1);
C=zeros(na,1);

for a=1:na
    
    DP(a)=norm(DM(a,:)-AP);
    DN(a)=norm(DM(a,:)-AN);
    
    C(a)=DN(a)/(DP(a)+DN(a));
    
end

%% step 4

S=C./sum(C);

[value,index]=sort(S,'descend');


end