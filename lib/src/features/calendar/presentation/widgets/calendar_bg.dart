import 'package:flutter/material.dart';

class CalendarBackground extends StatelessWidget {
  const CalendarBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF6FFFD), Color(0xFFE0F4F2), Color(0xFFD4EEF5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
