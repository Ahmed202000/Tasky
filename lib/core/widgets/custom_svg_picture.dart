import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvgPicture extends StatelessWidget {
  const CustomSvgPicture({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.withColorFilter = true,
  });

  const CustomSvgPicture.withoutColor({
    super.key,
    required this.path,
    this.width,
    this.height,
  }) : withColorFilter = false;

  final String path;
  final bool withColorFilter;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter:
          withColorFilter
              ? ColorFilter.mode(
                Theme.of(context).colorScheme.secondary,
                BlendMode.srcIn,
              )
              : null,
    );
  }
}
