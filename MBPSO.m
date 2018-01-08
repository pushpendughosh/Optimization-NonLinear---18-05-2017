clc;
clear all;
tic;

    Minimumvalue=inf;   
    dimension=2;
    population=100;
    bit=40;
    column=bit*dimension;
    
    up=50;
    low=-50;
   
    x=randi([0 1],population,bit*dimension);
    xgenome=x;
    
    upperbound=binary2decimal(ones(1,bit));
    lowerbound=binary2decimal(zeros(1,bit));
    
    func='test2'; %Here goes the test function

    for i=1:population
        xn=[];
        for j=1:dimension
            x1=x(i,(j*bit+1-bit):bit*j);
            x1=(up-low)*binary2decimal(x1)/(upperbound-lowerbound)+low; 
            xn=[xn x1];
        end
        fx(i)=feval(func,xn);
    end

    pbest=fx;
    xpbest=x;
    
    w=0.689343;
    [gbest l]=min(fx);
    xgbest=x(l,:);
    
    c1=1.42694;
    c2=1.42694;
    maxiteration=100;
    vel=rand(population,bit*dimension)-0.5;
    vmax=4;
    
    for iter=1:maxiteration
        for i=1:population
            xn=[];
            for j=1:dimension
                x1=x(i,1+(j-1)*bit:j*bit);
                x1=binary2decimal(x1)/(upperbound-lowerbound)*(up-low)+low;
                xn=[xn x1];
            end
            fx(i)=feval(func,xn);
            if fx(i)<pbest(i)
                pbest(i)=fx(i);
                xpbest(i,:)=x(i,:);
            end
        end
        [gg l]=min(fx);
        if gbest>gg
            gbest=gg;
            xgbest=x(l,:);
        end
       
        %%same as Discrete BPSO, except this part; calculation of velocity vector
        for i=1:population
            for j=1:column
                vel(i,j)=w*vel(i,j)+c1*rand*(xpbest(i,j)-x(i,j))+c2*rand*(xgbest(j)-x(i,j));
            end
        end
        
        for i=1:population
            for j=1:column
                if (abs(vel(i,j))>vmax)
                    if(vel(i,j)>vmax)
                        vel(i,j)=vmax;
                    else
                        vel(i,j)=-vmax;
                    end
                end
            end
        end
        
        xgenome=xgenome+vel;

        signoid = 1./(1 + exp(-xgenome));

        randommatrix=rand(population,bit*dimension);
        
        for i=1:population
            for j=1:column
                if (signoid(i,j)>randommatrix(i,j))
                    x(i,j)=1;
                else
                    x(i,j)=0;
                end
            end
        end
        
    end
   
    if Minimumvalue>gbest
        Minimumvalue=gbest;
    end

display(Minimumvalue);
toc;