#include "string.h"
#include <stdbool.h>

int strlen(const char* ptr)
{
  int i = 0;
  while(*ptr != 0)
  {
    i++;
    ptr += 1;
  }

  return i;
}

int to_numeric_digit(char c)
{
  // ASCII 48 is '0'
  // So, if c is 48, it is 0
  return c - 48;
}

bool is_digit(char c)
{
  // ASCII 48 is '0' and ASCII 57 is '9'
  // So, if c is between 48 and 57, it is a digit
  return c >= 48 && c <= 57;
}

int strnlen(const char *ptr, int max)
{
  int i = 0;
  for (int i = 0; i < max; i++)
  {
    if (ptr[i] == 0)
    {
      break;
    }
  }
  
  return i;
}