%%cu
#include <stdio.h>  
#include <cuda.h>  
#include <sys/time.h>
#define tile_size 32
#define m 128

__global__ void addition(int *N_matrix,int *M_matrix){
    __shared__ int var[tile_size][tile_size];
    int matrix1, matrix2;
    int i =blockIdx.x*tile_size+threadIdx.x;
    int j= blockIdx.y*tile_size+threadIdx.y;
    int a=threadIdx.x;
    int b=threadIdx.y;

    for (int n= 0; n < m/tile_size; n++) 
    {
        var[a][b] = M_matrix[i*m + j];
   
    }
            while (a==0)
            {
                if ((i-1)<0)
                {
                  matrix1=var[(a+1)][b];
                } 
                else if ((i+1)>=m)
                {
                  matrix1=M_matrix[(i-1)*m + j];
                }
                else
                {
                  matrix1=var[(a+1)][b]+M_matrix[(i-1)*m + j];
                }
             } 

           while (b==0){
                if ((j-1)<0)
                {
                  matrix2=var[a][(b+1)];
                } 
                else if ((j+1)>=m)
                {
                  matrix2=M_matrix[i*m + (j-1)];
                }
                else
                {
                  matrix2=var[a][(b+1)]+M_matrix[i*m + (j-1)];;
                }  
      
}

int main() 
{
    
dim3 grid_size(m/tile_size, m/tile_size);
dim3 tile(tile_size,tile_size);
struct timeval start, stop;
int M[m][m], N[m][m];
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
  cudaMemcpy(gpu_M,M,size,cudaMemcpyHostToDevice);

  gettimeofday(&start, 0);
  addition<<<grid_size, tile>>>(gpu_N,gpu_M);

  gettimeofday(&stop, 0);
    long seconds = stop.tv_sec - start.tv_sec;
    long microseconds = stop.tv_usec - start.tv_usec;
    double elapsedTime = seconds + microseconds*1e-6;

  cudaMemcpy(N, gpu_N, size, cudaMemcpyDeviceToHost);  
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

  printf("Time taken: %.6f seconds.\n", elapsedTime);

 
  return 0;
}
