#include <stdio.h>

#define DEBUG 1
#define LEN 8

void exchange(int *i, int *j)
{
  if (i == j) return;
  int temp;
  temp = *i;
  *i = *j;
  *j = temp;
}

int pattern(int *arr, int begin, int end)
{
  int base = *(arr + end);
  int i = begin;
  for (begin; begin < end; begin++) {
    if (*(arr + begin) <= base) {
#ifdef DEBUG
      printf("current number %d(%d), left largest number %d(%d)\n", *(arr+begin), begin, *(arr+i), i);
#endif
      exchange(arr + begin, arr + i);
      i++;
    }
  }
  exchange(arr + end, arr + i);
  return i;
}

void quick_sort(int arr[], int from, int end)
{
  if (from >= end) {
    return;
  }
#ifdef DEBUG
  printf("before:\t");
  int i;
  for (i = from; i <= end; i++) {
    printf("%2d ", *(arr + i));
  }
  printf("\n");
#endif
  int p = pattern(arr, from, end);
#ifdef DEBUG
  printf("after:\t");
  for (i = from; i <= end; i++) {
    printf("%2d ", *(arr + i));
  }
  printf("\n\n");
#endif
  quick_sort(arr, from, p - 1);
  quick_sort(arr, p + 1, end);
}

int main()
{
  int arr[LEN] = {2,8,7,1,3,5,4,4};
  quick_sort(arr, 0, LEN - 1);
  int i;
  for (i = 0; i < LEN; i++) {
      printf("%2d ", *(arr + i));
  }
  printf("\n");
  return 0;
}
