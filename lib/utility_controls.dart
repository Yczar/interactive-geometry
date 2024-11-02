import 'package:flutter/material.dart';

class UtilityControls extends StatelessWidget {
  final bool showGuides;
  final ValueChanged<bool> onShowGuidesChanged;
  final VoidCallback onResetAll;

  const UtilityControls({
    required this.showGuides,
    required this.onShowGuidesChanged,
    required this.onResetAll,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        SwitchListTile(
          title: const Text('Show Grid'),
          value: showGuides,
          onChanged: onShowGuidesChanged,
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          icon: const Icon(Icons.refresh),
          label: const Text('Reset All'),
          onPressed: onResetAll,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade400,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
