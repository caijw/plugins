#!/bin/bash

mkdir build && cd build && cmake .. && make && mkdir -p ~/lib && cp libhello.so ~/lib