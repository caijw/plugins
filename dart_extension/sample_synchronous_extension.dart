// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library sample_synchronous_extension;

// 加载当前目录的 so 文件
import 'dart-ext:sample_extension';

// 加载绝对路径的 so 文件
// import 'dart-ext:/home/jingweicai/Documents/code/dart_sdk/samples/sample_extension/sample_extension';

// The simplest way to call native code: top-level functions.
int systemRand() native "SystemRand";
int noScopeSystemRand() native "NoScopeSystemRand";
bool systemSrand(int seed) native "SystemSrand";
