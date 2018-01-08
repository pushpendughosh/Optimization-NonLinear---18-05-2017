%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Simulated Annealing%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
func = 'test2';
tic;

dimension = 2;
hrange = 50;
lrange = -50;
length=(hrange-lrange)/10;
damp=0.8;
    
x = rand(1,dimension)*(hrange-lrange)+lrange;
fx = feval(func,x);

Temp = 1;iter=0;
accept=[]; fxval=[];

%%% big step mover to search maximum space
while (iter < 100)
    iter = iter+1;
    for i=1:30
        xnew = x + ((rand(1,dimension))-0.5)*log2(Temp);
        for j=1:dimension
            if(xnew(1,j)>hrange)
                xnew(1,j)=hrange;
            elseif(xnew(1,j)<lrange)
                xnew(1,j)=lrange;
            end
        end
        fxnew = feval(func,xnew);
      
        if(fxnew < fx)
            fx = fxnew;
            x = xnew;
        else
            delta=(fxnew-fx);
            acceptance = (1/(1+exp(delta/(Temp))))*((150-iter)/150)^2;
            
            accept =[accept,acceptance];
     
            if(rand <= acceptance)
                fx = fxnew;
                x = xnew;
            end
        end
        fxval = [fxval;fx];
    end
    Temp=Temp*damp;
    
end

Temp=0.01; 
iter=0;
fxval=min(fxval);

%%% small step mover to improvise the result
while (iter < 100)
    iter = iter+1;
    for i=1:30
        xnew = x + ((rand(1,dimension))-0.5)*Temp;
        for j=1:dimension
            if(xnew(1,j)>hrange)
                xnew(1,j)=hrange;
            elseif(xnew(1,j)<lrange)
                xnew(1,j)=lrange;
            end
        end
        fxnew = feval(func,xnew);
      
        if(fxnew < fx)
            fx = fxnew;
            x = xnew;
            fxval = [fxval;fx];
        end  
    end
    Temp=Temp*damp;
    
end

min(fxval)
toc;