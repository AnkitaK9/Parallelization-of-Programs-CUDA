%%cu 
#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <sys/time.h>
#define N_Threads 1024
#define N 1024


__global__ void vectoradd(int *arr1, int *arr2,int R)
{
  int id = blockIdx.x*blockDim.x + threadIdx.x;
    int s1=0;
    int s2=0;
 
   
	  for (int r=1;r<=R;r++)
	  {
	       if((id-r)>0 && (id-r)<N)
	      {
	      	  s1=s1+arr1[id-r];

	      }
	      	if((id+r)>0 && (id+r)<N)
	      {
	      	  s2=s2+arr1[id+r];
	      }
     arr2[id]=s1+s2;
    
   }
}

int main(void)
{
  struct timeval begin, end;
 
  int A[N], B[N], *d_A, *d_B;
   int R=32;
   for (int i=0;i<N;i++)
   {
       A[i]=i;
   }
 
 
   cudaMalloc(&d_A, N * sizeof(int));
   cudaMalloc(&d_B, N * sizeof(int));
   
   cudaMemcpy(d_A,A,N*(sizeof(int)),cudaMemcpyHostToDevice);

    int NoBlocks=N/N_Threads;
     gettimeofday(&begin, 0);
 
    vectoradd<<<NoBlocks, N_Threads>>>(d_A,d_B,R);
    gettimeofday(&end, 0);
 
    long seconds = end.tv_sec - begin.tv_sec;
    long microseconds = end.tv_usec - begin.tv_usec;
    double elapsed = seconds + microseconds*1e-6;
 
    
    cudaDeviceSynchronize();
    cudaMemcpy(B,d_B,N*(sizeof(int)),cudaMemcpyDeviceToHost);
    
    
    for (int i = 0; i < N; i++)  
    {
     
      printf("%d\n", B[i]); 
    }
 printf("Time measured: %.6f seconds.\n", elapsed);

    cudaFree(d_A);
    cudaFree(d_B);
  
  }
