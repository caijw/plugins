#!/bin/bash

g++ -fPIC -m64 -I/usr/lib/dart -DDART_SHARED_LIB -c sample_extension.cc

g++ -shared -m64 -Wl,-soname,libsample_extension.so -o libsample_extension.so sample_extension.o




# g++ -fPIC -m64 -I/usr/lib/dart -DDART_SHARED_LIB -c ffi_test_dynamic_library.cc

# g++ -shared -m64 -Wl,-soname,libffi_test_dynamic_library.so -o libffi_test_dynamic_library.so ffi_test_dynamic_library.o




# g++ -fPIC -m64 -I/usr/lib/dart -DDART_SHARED_LIB -c ffi_test_functions.cc

# g++ -shared -m64 -Wl,-soname,libffi_test_functions.so -o libffi_test_functions.so ffi_test_functions.o
