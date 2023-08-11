import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:ai_poem_app/common.dart';

class AppBackdrop extends StatelessWidget {
  AppBackdrop({
    Key? key,
    this.strength = 1,
    this.child,
  }) : super(key: key);

  final double strength;
  final Widget? child;

  final bool useBlurs = defaultTargetPlatform != TargetPlatform.android;

  @override
  Widget build(BuildContext context) {
    final double normalStrength = clampDouble(strength, 0, 1);
    if (useBlurs) {
      return BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: normalStrength * 5.0, sigmaY: normalStrength * 5.0),
        child: child ?? const SizedBox.expand(),
      );
    }
    final fill = Container(color: Colors.black.withOpacity(.8 * strength));
    return child == null
        ? fill
        : Stack(
            children: [
              child!,
              Positioned.fill(child: fill),
            ],
          );
  }
}
