import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget svgProvider() {
  return SizedBox(
      height: 101,
      width: 180,
      child: SvgPicture.asset(
        'images/c1.svg',
        color: Colors.purple,
        theme: const SvgTheme(fontSize: 1),
      ));
}
