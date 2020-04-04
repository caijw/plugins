library ipc_extension;

// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart-ext:ipc_extension';

void setDesktopWindow(String title) native "setDesktopWindow";
void setDrawerWindow(String title) native "setDrawerWindow";
void setWindowSource(String title, int x, int y) native "setWindowSource";
int flush() native "flush";
