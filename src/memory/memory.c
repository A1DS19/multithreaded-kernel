#include "memory.h"

void* memset(void* dest, int val, size_t count)
{
  unsigned char* d = (unsigned char*)dest;
  for (int i = 0; i < count; i++)
  {
    d[i] = (char) val;
  }
  return dest;
}

int memcmp(void *s1, void *s2, int count)
{
  char* c1 = (char*)s1;
  char* c2 = (char*)s2;
  while (count-- > 0)
  {
    if (*c1++ != *c2++)
    {
      return c1[-1] < c2[-1] ? -1 : 1;
    }
  }

  return 0;
}