import 'package:flutter/material.dart';

class HeadlineWidget extends StatelessWidget {
  final String title;
  const HeadlineWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 20),
      Text(title,
          style: const TextStyle(
              fontFamily: 'Londrina',
              color: Colors.white70,
              fontSize: 21,
              letterSpacing: 2))
    ]);
  }
}
