clc;
clear all;
tic;

    Minimumvalue=inf;   
    dimension=1;
    population=30;
    bit=40;
    column=bit*dimension;
    
    up=100;
    low=-100;
   
    x=randi([0 1],population,bit*dimension);
    
    upperbound=binary2decimal(ones(1,bit));
    lowerbound=binary2decimal(zeros(1,bit));
    
    func='test1'; %Here goes the test function

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
    gbester=[];
    
    for iter=1:maxiteration
        gbester=[gbester gbest];
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
        
        c1random=c1*rand;
        c2random=c2*rand;
        
        for i=1:population
            for j=1:column
            		%%conditions to choose which bit to reverse, finding the velocity vector
                if x(i,j)==1
                    if(xpbest(i,j)==1)
                        if(xgbest(j)==1)
                            %1,1,1
                            vel(i,j)=w*vel(i,j)-c1random-c2random;
                        else
                            %1,1,0
                            vel(i,j)=w*vel(i,j)-c1random+c2random;
                        end
                    else
                        if(xgbest(j)==1)
                            %1,0,1
                            vel(i,j)=w*vel(i,j)+c1random-c2random;
                        else
                            %1,0,0
                            vel(i,j)=w*vel(i,j)+c1random+c2random;
                        end
                    end
                
                else
                    if(xpbest(i,j)==1)
                        if(xgbest(j)==1)
                            %0,1,1
                            vel(i,j)=w*vel(i,j)+c1random+c2random;
                        else
                            %0,1,0
                            vel(i,j)=w*vel(i,j)+c1random-c2random;
                        end
                    else
                        if(xgbest(j)==1)
                            %0,0,1
                            vel(i,j)=w*vel(i,j)-c1random+c2random;
                        else
                            %0,0,0
                            vel(i,j)=w*vel(i,j)-c1random-c2random;
                        end
                    end
                end
            end
        end
        
        %%prevention from reaching vmax
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
        
        %%%%% signoid function which decides if the bit should be changed or not 
        signoid = 1./(1 + exp(-vel));

        randommatrix=rand(population,bit*dimension);
        
        for i=1:population
            for j=1:column
                if (signoid(i,j)>randommatrix(i,j))
                    x(i,j)=not(x(i,j));
                else
                    x(i,j)=(x(i,j));
                end
            end
        end
    end
   
    if Minimumvalue>gbest
        Minimumvalue=gbest;
    end

display(Minimumvalue);
toc;

