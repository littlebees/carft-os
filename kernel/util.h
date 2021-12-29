#ifndef KERNEL_UTIL_H
#define KERNEL_UTIL_H

#include <stdint.h>

void memory_copy(char *source, char *dest, int nbytes);
void memory_set(unsigned char *dest, unsigned char val, unsigned int len);
void int_to_ascii(int n, char str[]);
void reverse(char s[]);
int strlen(char s[]);
#define low_16(address) (uint16_t)((address) & 0xFFFF)
#define high_16(address) (uint16_t)(((address) >> 16) & 0xFFFF)

#endif