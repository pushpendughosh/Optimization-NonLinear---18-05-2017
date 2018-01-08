#include <stdio.h>
#include <math.h>
#include <time.h>
#include <stdlib.h>

#define dim 5 //dim here is the dimension

double gbestcost=INFINITY;
float gbestposition[dim];

typedef struct Agent
{
     float position[dim];
     float velocity[dim];  
     float cost;
     float pbestcost;
     float pbestposition[dim];
}Agent;

float costfunc ( float x[dim] )
{
	float val = 0;
	for(int i=0;i<dim;i++)
	{	
		val += (pow((x[i]),2));
	}
	return val;
}

float randomno ( float min , float max )
{
        float r=((long double)rand()/RAND_MAX)*(max-min) + min ;
        return (r);
}

int main()
{
	//variables
	float varmin,varmax,w,wdamper,c1,c2;
	int iterations,nPoint,i,j;
	
	//feasible region	
	varmin = -50;
	varmax = 50;

	//Parmeters
	iterations = 100;
	nPoint = 30;
        w=1;
        wdamper=0.95;
        c1=2;
        c2=2;	
		
	//Initialize the states of agents 	
	Agent particle[nPoint];
	
	//Start timer for random numbers
	srand(time(NULL));
	
	//Give some values to the variables corresponding to agents
	for(i=0;i<nPoint;i++)
	{
	    for(j=0;j<dim;j++)
	    {    
	        particle[i].position[j] = randomno(varmin,varmax) ;
	        particle[i].pbestposition[j] = particle[i].position[j] ;
	        particle[i].velocity[j] = 0 ;
	    }
	        
	    particle[i].cost = costfunc(particle[i].position);
	    particle[i].pbestcost = particle[i].cost;
	    
	    if(particle[i].pbestcost < gbestcost)
	        {
	                gbestcost=particle[i].pbestcost;
	                for(j=0;j<dim;j++)
	                    {    
	                        gbestposition[j] = particle[i].pbestposition[j] ;
	                    }
	        }
	}
	
       //main loop
       for (int iter = 0; iter < iterations ; iter ++)
       {
                for(i=0;i<nPoint;i++)
                {       
                        for(j=0;j<dim;j++)
	                	{
                                particle[i].velocity[j] = w * particle[i].velocity[j] + c1 * randomno(0,1) * (particle[i].pbestposition[j] - particle[i].position[j]) + c2 * randomno(0,1) * (gbestposition[j] - particle[i].position[j]);
                              
                                particle[i].position[j] = particle[i].position[j] + particle[i].velocity[j];
                                particle[i].position[j] = (particle[i].position[j] > varmin)? (particle[i].position[j]):varmin;
                                particle[i].position[j] = (particle[i].position[j] > varmax)? varmax:(particle[i].position[j]);
                
                        }        
                        particle[i].cost = costfunc(particle[i].position);
                        
                        if(particle[i].cost < particle[i].pbestcost)
                        {
                                particle[i].pbestcost=particle[i].cost;
                                for(j=0;j<dim;j++)
	                            {    
	                               particle[i].pbestposition[j] = particle[i].position[j] ;
	                            }
	                            
	                        if(particle[i].pbestcost < gbestcost)
	                        {
	                                gbestcost=particle[i].pbestcost;
	                                for(j=0;j<dim;j++)
	                                    {    
	                                        gbestposition[j] = particle[i].pbestposition[j] ;
	                                    }
	                        }
                        }               
                }
                
               // for(j=0;j<dim;j++)
	           //{    
	           //     printf(" %.12f, ",gbestposition[j]);
	           //}
	           
	        	printf(" Iteration : %d ---> %g\n ",iter+1,gbestcost);
                w=w*wdamper;
       }
        for(j=0;j<dim;j++)
		{    
	    		printf(" %g, ",gbestposition[j]);
		}
                
	return 0;
}
























