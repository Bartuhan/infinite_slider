import 'package:flutter/material.dart';
import 'package:infinite_slider/core/extensions/context_extension.dart';

import '../core.dart';

class ViceUIConsts {
  ViceUIConsts._();

  static const BoxDecoration gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.3, 1],
      colors: ViceColors.scaffoldColors,
    ),
  );

  // static double headerHeight = 0.65.sh;
  static double headerHeight(BuildContext context) {
    return context.height(65);
  }
}
