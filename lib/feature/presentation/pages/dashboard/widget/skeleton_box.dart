import 'package:flutter/material.dart';

class SkeletonBox extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final Color? color;

  const SkeletonBox({
    Key? key,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = 8.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class SkeletonContainer extends StatelessWidget {
  final Widget child;

  const SkeletonContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: child,
    );
  }
}

class DashboardSkeletonLoading extends StatelessWidget {
  const DashboardSkeletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header greeting skeleton
        SkeletonBox(
          height: 90.0,
          borderRadius: 10.0,
        ),
        SizedBox(height: 15.0),

        // Clock time skeleton
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SkeletonBox(
              height: 90.0,
              width: 120.0,
              borderRadius: 10.0,
            ),
          ],
        ),
        SizedBox(height: 20.0),

        // Weekly/Monthly time skeletons
        Row(
          children: [
            Expanded(
              child: SkeletonBox(
                height: 110.0,
                borderRadius: 10.0,
              ),
            ),
            SizedBox(width: 15.0),
            Expanded(
              child: SkeletonBox(
                height: 110.0,
                borderRadius: 10.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),

        // Timesheet/Timeoff tab skeleton
        SkeletonBox(
          height: 50.0,
          borderRadius: 10.0,
        ),
        SizedBox(height: 10.0),
        SkeletonBox(
          height: 200.0,
          borderRadius: 10.0,
        ),
        SizedBox(height: 25.0),

        // Holidays & Events skeleton
        SkeletonBox(
          height: 25.0,
          width: 160.0,
          borderRadius: 5.0,
        ),
        SizedBox(height: 15.0),
        SkeletonBox(
          height: 150.0,
          borderRadius: 10.0,
        ),
      ],
    );
  }
}
