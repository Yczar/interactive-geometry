import 'package:flutter/material.dart';

class PointControls extends StatelessWidget {
  final VoidCallback onClearPoints;

  const PointControls({
    required this.onClearPoints,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Click anywhere on the grid to create points.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.clear_all),
          label: const Text('Clear Points'),
          onPressed: onClearPoints,
        ),
      ],
    );
  }
}

// Similar refactoring applies to LineControls and PlaneControls, using respective onClear callbacks.
