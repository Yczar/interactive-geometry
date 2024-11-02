import 'package:flutter/material.dart';

class ModeSelector extends StatelessWidget {
  final String currentMode;
  final ValueChanged<String> onModeSelected;

  const ModeSelector({
    required this.currentMode,
    required this.onModeSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Geometric Concepts',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ModeChip(
                label: 'Transform',
                mode: 'transform',
                icon: Icons.transform,
                currentMode: currentMode,
                onModeSelected: onModeSelected),
            ModeChip(
                label: 'Point',
                mode: 'point',
                icon: Icons.location_on,
                currentMode: currentMode,
                onModeSelected: onModeSelected),
            ModeChip(
                label: 'Line',
                mode: 'line',
                icon: Icons.show_chart,
                currentMode: currentMode,
                onModeSelected: onModeSelected),
            ModeChip(
                label: 'Plane',
                mode: 'plane',
                icon: Icons.category,
                currentMode: currentMode,
                onModeSelected: onModeSelected),
          ],
        ),
      ],
    );
  }
}

class ModeChip extends StatelessWidget {
  final String label;
  final String mode;
  final IconData icon;
  final String currentMode;
  final ValueChanged<String> onModeSelected;

  const ModeChip({
    required this.label,
    required this.mode,
    required this.icon,
    required this.currentMode,
    required this.onModeSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: currentMode == mode,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (selected) => onModeSelected(mode),
    );
  }
}
