#ifndef CONFIG_H
#define CONFIG_H

#define OS_TOTAL_INTERRUPTS 512
#define KERNEL_CODE_SELECTOR 0x08
#define KERNEL_DATA_SELECTOR 0x10
#define OS_HEAP_SIZE_BYTES 104857600 // 100 MB heap size
#define OS_HEAP_BLOCK_SIZE 4096 // 4 KB block size
#define OS_HEAP_ADDRESS 0x01000000 // 16 MB heap address
#define OS_HEAP_TABLE_ADDRESS 0x00007E00 // 31.5 KB heap table address
#endif