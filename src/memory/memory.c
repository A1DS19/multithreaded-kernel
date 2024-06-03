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