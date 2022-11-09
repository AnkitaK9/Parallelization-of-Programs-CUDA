%%cu
#include <stdio.h>  
#include <cuda.h>  
#include <sys/time.h>
#define m 4

__global__ void addition(int *N_matrix,int *M_matrix){
    int id = blockIdx.x*blockDim.x +threadIdx.x;
    int matrix1 ;
    int matrix2;
    int i = id/m;
    int j= id%m;
            if ((i-1)<0)
            {
                matrix1=M_matrix[(i+1)*m + j];
            } 
            else if ((i+1)>=m)
            {
                matrix1=M_matrix[(i-1)*m + j];
            }
            else
            {
                matrix1=M_matrix[(i+1)*m + j]+M_matrix[(i-1)*m + j];
            }

            if ((j-1)<0)
            {
                matrix2=M_matrix[i*m + (j+1)];
            } 
            else if ((j+1)>=m)
            {
                matrix2=M_matrix[i*m + (j-1)];
            }
            else
            {
                matrix2=M_matrix[i*m + (j+1)]+M_matrix[i*m + (j-1)];
            }
            N_matrix[i*m +j]=matrix1+matrix2;
      
}

int main() 
{
  struct timeval begin, end;
  int M[m][m], N[m][m],*d_M,*d_N;
  int k=0;
  int l=0;
  for (k=0;k<m;k++)
  { 
      for (l=0;l<m;l++)
      {
          M[k][l]=k+l;
      }
        
  }
  int matrixsize=m*m;
  int size=m*m*sizeof(int);
  cudaMalloc(&d_M, size);
  cudaMalloc(&d_N, size);
  cudaMemcpy(d_M,M,size, cudaMemcpyHostToDevice);
  gettimeofday(&begin, 0);
  addition<<<32, matrixsize>>>(d_N,d_M);
    gettimeofday(&end, 0);
    long seconds = end.tv_sec - begin.tv_sec;
    long microseconds = end.tv_usec - begin.tv_usec;
     double elapsed = seconds + microseconds*1e-6;
  cudaMemcpy(N,d_N,size,cudaMemcpyDeviceToHost);  
  int x=0;
  int y=0;
  for (x=0;x<m;x++)
  {
      for (y=0;y<m;y++)
      {
        printf("%d ", N[x][y]);
      }
      printf("\n\n");
  }
  printf("Time measured: %.6f seconds.\n", elapsed);
 
  return 0;
}
