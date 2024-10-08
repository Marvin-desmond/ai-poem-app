// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(this.icon, {Key? key, this.size = 22, this.color})
      : super(key: key);
  final AppIcons icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    String i = describeEnum(icon).toLowerCase().replaceAll('_', '-');
    print("Now in path $i");
    String path = 'assets/images/icon-$i.png';
    //print(path);
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Image.asset(path,
            width: size,
            height: size,
            color: color ?? const Color(0xFFF8ECE5),
            filterQuality: FilterQuality.high),
      ),
    );
  }
}

enum AppIcons {
  close,
  close_large,
  collection,
  download,
  expand,
  fullscreen,
  fullscreen_exit,
  info,
  menu,
  next_large,
  north,
  prev,
  reset_location,
  search,
  share_android,
  share_ios,
  timeline,
  wallpaper,
  zoom_in,
  zoom_out
}
