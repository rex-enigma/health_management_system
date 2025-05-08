import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  //
  final int delayMilliseconds;
  Timer? _timer;

  Debouncer({required this.delayMilliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: delayMilliseconds), action);
  }
}
