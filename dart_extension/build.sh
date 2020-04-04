#!/bin/bash

g++ -fPIC -m64 -I/usr/lib/dart -DDART_SHARED_LIB -c sample_extension.cc

g++ -shared -m64 -Wl,-soname,libsample_extension.so -o libsample_extension.so sample_extension.o