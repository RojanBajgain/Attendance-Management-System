import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShrimmerEffect extends StatelessWidget {
  final double height;
  final double width;
  final ShapeBorder shapeBorder;

  const ShrimmerEffect.rectangular({
    super.key,
    required this.height,
    this.width = double.infinity,
  }) : shapeBorder = const RoundedRectangleBorder();

  const ShrimmerEffect.circular({
    super.key,
    required this.height,
    required this.width,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[400]!,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey[400],
          shape: shapeBorder,
        ),
      ),
    );
  }
}
