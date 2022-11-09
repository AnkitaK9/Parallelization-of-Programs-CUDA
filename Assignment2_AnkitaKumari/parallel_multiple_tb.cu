%%cu
#include <stdio.h>  
#include <cuda.h>  
#include <sys/time.h>
#define tile_size 32
#define m 512


__global__ void addition(int *N_matrix,int *M_matrix)
{
    
    int i = (blockIdx.x*tile_size)+threadIdx.x;
    int j= (blockIdx.y*tile_size)+threadIdx.y;
    int matrix1;
    int matrix2;
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

int main() {
    
   
     dim3 block(tile_size,tile_size);
     dim3 grid_size(m/tile_size, m/tile_size);
     struct timeval start, stop;

  int M[m][m],N[m][m];
  int *gpu_M,*gpu_N;
  int k=0;
  int l=0;
  for (k=0;k<m;k++)
  {
      for (l=0;l<m;l++)
      {
        M[k][l]=k+l;
      }
  }
  int size=m*m*sizeof(int);
  cudaMalloc(&gpu_M, size);
  cudaMalloc(&gpu_N, size);
  
   cudaMemcpy(gpu_M,M,size, cudaMemcpyHostToDevice);

  gettimeofday(&start, 0);
  addition<<<grid_size, block>>>(gpu_N,gpu_M);

  gettimeofday(&stop, 0);
    long seconds = stop.tv_sec - start.tv_sec;
    long microseconds = stop.tv_usec - start.tv_usec;
    double elapsedTime = seconds + microseconds*1e-6;

  cudaMemcpy(N, gpu_N, m*m*sizeof(int), cudaMemcpyDeviceToHost);  
   int x=0;
   int y=0;
  for (x=0;x<m;x++){
      for (y=0;y<m;y++){
        printf("%d ", N[x][y]);
      }
      printf("\n\n");
  }

  printf("Time taken: %.6f seconds.\n", elapsedTime);

  return 0;
}
