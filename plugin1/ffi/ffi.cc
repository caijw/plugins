#include "ffi.h"

char *echoBigString(char *str){
  return str;
}

typedef intptr_t (*IntptrBinOp)(intptr_t a, intptr_t b);

// Applies an intptr binop function to 42 and 74.
// Used for testing passing a function pointer to C.
intptr_t ApplyTo42And74(IntptrBinOp binop) {
  std::cout << "ApplyTo42And74()\n";
  intptr_t retval = binop(42, 74);
  std::cout << "returning " << retval << "\n";
  return retval;
}