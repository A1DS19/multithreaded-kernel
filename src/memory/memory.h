#ifndef MEMORY_H
#define MEMORY_H

#include <stddef.h>

void* memset(void* dest, int val, size_t count);
int memcmp(void *s1, void *s2, int count);

#endif