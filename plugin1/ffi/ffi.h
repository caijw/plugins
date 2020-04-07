#ifndef FFI_H
#define FFI_H

#include <stddef.h>
#include <stdlib.h>
#include <sys/types.h>

#include <cmath>
#include <iostream>
#include <limits>

#define EXPORT __attribute__((visibility("default")))

typedef intptr_t (*IntptrBinOp)(intptr_t a, intptr_t b);

#if defined(__cplusplus)
extern "C" {
#endif

EXPORT char *echoBigString(char *str);

EXPORT intptr_t ApplyTo42And74(IntptrBinOp binop);

#if defined(__cplusplus)
}  // extern "C"
#endif


#endif