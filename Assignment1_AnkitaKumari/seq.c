
#include<stdio.h>
#include <sys/time.h>
#define N 131072
#define R 32
int main()
{
  struct timeval begin, end;
  
  int A[N],i;
  int j;
  int r;
  int B[N];
  int s1,s2;
 
  s1=0;
  s2=0;
 
  for (i=0;i<N;i++)
  {
    A[i]=i;
  }
  
  gettimeofday(&begin, 0);
  for (j=0;j<N;j++)
  {
	  for (r=1;r<=R;r++)
	  {
	       if((j-r)>0 && (j-r)<N)
	      {
	      	  s1=s1+A[j-r];
	      }
	      	if((j+r)>0 && (j+r)<N)
	      {
	      	  s2=s2+A[j+r];
	      }
     B[j]=s1+s2;  
    s1=0;
    s2=0;     
       
  	  }
  }
 gettimeofday(&end, 0);
    long seconds = end.tv_sec - begin.tv_sec;
    long microseconds = end.tv_usec - begin.tv_usec;
    double elapsed = seconds + microseconds*1e-6;
    
     
  	 for (int j=0;j<N;j++)
  		{
    		printf("%d\n", B[j]);
    
  		} 
 
 printf("Time measured: %.6f seconds.\n", elapsed);	
   
   return 0;
}



     	       
  	 	
