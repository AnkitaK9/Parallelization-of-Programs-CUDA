
#include <stdio.h>
#include <sys/time.h>
#define m 1024

int main()
{ 
    struct timeval begin, end;
    int M[m][m];
    int N[m][m];
 
    int matrix1;
    int matrix2;
    
    int k=0;
    int l=0;
    for (k=0; k<m;k++)
    {
        for (l=0; l<m; l++)
        {
            M[k][l]=k+l;
        }
    }
    
     gettimeofday(&begin, 0);
    for (int i=0; i<m; i++)
    {
        for (int j=0; j<m; j++)
        {   
            if ((i-1)<0)
            {
                matrix1=M[i+1][j];
            } 
            else if ((i+1)>=m)
            {
                matrix1=M[i-1][j];
            }
            else
            {
                matrix1=M[i-1][j]+M[i+1][j];
            }
            if ((j-1)<0)
            {
                matrix2=M[i][j+1];
            } 
            else if ((j+1)>=m)
            {
                matrix2=M[i][j-1];
            }
            else
            {
                matrix2=M[i][j-1]+M[i][j+1];
            }
            N[i][j]=matrix1+matrix2;
    
            printf("%d ", N[i][j]);
        }
      printf("\n\n");
       
    }
    gettimeofday(&end, 0);
    long seconds = end.tv_sec - begin.tv_sec;
    long microseconds = end.tv_usec - begin.tv_usec;
     double elapsed = seconds + microseconds*1e-6;
     printf("Time measured: %.6f seconds.\n", elapsed);
}
