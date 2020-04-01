#ifndef FFI_H
#define FFI_H

#define EXPORT __attribute__((visibility("default")))

#if defined(__cplusplus)
extern "C" {
#endif

EXPORT char *echoBigString(char *str);

#if defined(__cplusplus)
}  // extern "C"
#endif


#endif