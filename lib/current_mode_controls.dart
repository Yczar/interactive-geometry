import 'package:flutter/material.dart';

class CurrentModeControls extends StatelessWidget {
  final String currentMode;
  final Widget Function() transformControls;
  final Widget Function() pointControls;
  final Widget Function() lineControls;
  final Widget Function() planeControls;

  const CurrentModeControls({
    super.key,
    required this.currentMode,
    required this.transformControls,
    required this.pointControls,
    required this.lineControls,
    required this.planeControls,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentMode) {
      case 'transform':
        return transformControls();
      case 'point':
        return pointControls();
      case 'line':
        return lineControls();
      case 'plane':
        return planeControls();
      default:
        return const SizedBox.shrink();
    }
  }
}
