import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
class Debouncer {
  final int milliseconds;
  Timer? _timer;
  bool _isFirst = true;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    log("is firstiurcfhiuerhfurehfuihreufhuifcheruifhur");
    if (_isFirst) {
      _isFirst = false;
      action(); // Run immediately
    } else {
      _timer?.cancel();
      _timer = Timer(Duration(milliseconds: milliseconds), action);
    }
  }

  void dispose() {
    _timer?.cancel();
  }

  void reset() {
    _isFirst = true;
    _timer?.cancel();
  }
}
