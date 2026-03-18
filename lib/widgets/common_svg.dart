import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonSvg extends StatelessWidget {
  final String path;
  final double width;
  final double height;
  final double parentWidth;
  final double parentHeight;
  final Color color;

  const CommonSvg(
      {super.key,
      required this.path,
      required this.width,
      required this.height,
      required this.parentWidth,
      required this.parentHeight,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: parentWidth,
      height: parentHeight,
      alignment: Alignment.center,
      child: SvgPicture.asset(
        path,
        width: width,
        height: height,
        fit: BoxFit.fill,
        color: color,
      ),
    );
  }
}
