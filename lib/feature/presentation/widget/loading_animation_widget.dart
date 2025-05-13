import 'package:flutter/material.dart';

class CombinedAnimatedDialog extends StatefulWidget {
  const CombinedAnimatedDialog({super.key});

  @override
  _CombinedAnimatedDialogState createState() => _CombinedAnimatedDialogState();
}

class _CombinedAnimatedDialogState extends State<CombinedAnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.green,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color?>(
                            _colorAnimation.value),
                        strokeWidth: 6,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                      );
                    },
                  ),
                ),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    'assets/images/Ayata_logo.png',
                    height: 55,
                    width: 55,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
