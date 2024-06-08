#include "kernel.h"
#include "idt/idt.h"
#include "io/io.h"
#include <stdint.h>
#include <stddef.h>
#include "memory/heap/kheap.h"

uint16_t *video_memory = (uint16_t *)0;
uint16_t terminal_row = 0;
uint16_t terminal_column = 0;

// Create a VGA character
// The character is a 16-bit value
uint16_t terminal_make_char(char character, char color)
{
  return (color << 8) | character;
}

// Put a character on the screen
void terminal_put_char(int x, int y, char character, char color)
{
  video_memory[(y * VGA_WIDTH) + x] = terminal_make_char(character, color);
}

// Write a string to the terminal
// This function will write a string to the terminal
void terminal_write_char(char character, char color)
{

  if (character == '\n')
  {
    terminal_column = 0;
    terminal_row += 1;
    return;
  }

  terminal_put_char(terminal_column, terminal_row, character, color);
  terminal_column += 1;

  if (terminal_column >= VGA_WIDTH)
  {
    terminal_column = 0;
    terminal_row += 1;
  }
}

// Initialize the terminal
// Clear the screen
void terminal_initialize()
{
  video_memory = (uint16_t *)0xB8000;
  terminal_row = 0;
  terminal_column = 0;

  for (int i = 0; i < VGA_HEIGHT; i++)
  {
    for (int y = 0; y < VGA_WIDTH; y++)
    {
      terminal_put_char(y, i, ' ', 0);
    }
  }
}

// Calculate the length of a string
size_t strlen(const char *str)
{
  size_t len = 0;
  while (str[len])
  {
    len++;
  }
  return len;
}

// Print a string to the terminal
void print(const char* str)
{
  size_t len = strlen(str);
  for (size_t i = 0; i < len; i++)
  {
    terminal_write_char(str[i], 15);
  }
}

void kernel_main()
{
  terminal_initialize();
  print("Hello, World!");

  // Initialize the kernel heap
  kheap_init();

  // Initialize the IDT
  idt_init();
}