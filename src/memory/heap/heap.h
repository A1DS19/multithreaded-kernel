#ifndef HEAP_H
#define HEAP_H

#include "config.h"
#include "stdint.h"
#include "stddef.h"

#define HEAP_BLOCK_TABLE_ENTRY_TAKEN 0x01 // Means that the block is taken
#define HEAP_BLOCK_TABLE_ENTRY_FREE 0x00 // Means that the block is free

#define HEAP_BLOCK_HAS_NEXT 0b10000000 // Means that the block has a next block
#define HEAP_BLOCK_IS_FIRST  0b01000000 // Means that the block is free

typedef unsigned char HEAP_BLOCK_TABLE_ENTRY; // Represents a block in the block table

struct heap_table // Represents the block table
{
  HEAP_BLOCK_TABLE_ENTRY* entries;
  size_t total;
};

struct heap // Represents the heap
{
  struct heap_table* table;
  void* saddr;
};

int heap_create(struct heap *heap, void *ptr, void *end, struct heap_table *table);
void *heap_malloc(struct heap *heap, size_t size);
void heap_free(struct heap *heap, void *ptr);

#endif