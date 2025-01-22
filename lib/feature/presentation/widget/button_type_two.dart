import 'package:flutter/material.dart';

class ButtonTypeTwo extends StatelessWidget {
  const ButtonTypeTwo({
    super.key,
    required this.onTap,
    required this.color,
    required this.title,
  });
  final VoidCallback onTap;
  final Color color;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      //     () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => TestQuestionView()),
      //   );
      // },
      child: Container(
        width: 130,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [title],
          ),
        ),
      ),
    );
  }
}
