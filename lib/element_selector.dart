import 'package:flutter/material.dart';

class ElementSelector extends StatelessWidget {
  final String selectedElement;
  final ValueChanged<String?> onElementSelected;
  final bool hasPoints;
  final bool hasLines;
  final bool hasShapes;

  const ElementSelector({
    required this.selectedElement,
    required this.onElementSelected,
    this.hasPoints = false,
    this.hasLines = false,
    this.hasShapes = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Element to Transform:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text('All'),
              selected: selectedElement == 'all',
              onSelected: (selected) =>
                  onElementSelected(selected ? 'all' : null),
            ),
            if (hasPoints)
              ChoiceChip(
                label: const Text('Points'),
                selected: selectedElement == 'points',
                onSelected: (selected) =>
                    onElementSelected(selected ? 'points' : null),
              ),
            if (hasLines)
              ChoiceChip(
                label: const Text('Lines'),
                selected: selectedElement == 'lines',
                onSelected: (selected) =>
                    onElementSelected(selected ? 'lines' : null),
              ),
            if (hasShapes)
              ChoiceChip(
                label: const Text('Shapes'),
                selected: selectedElement == 'shapes',
                onSelected: (selected) =>
                    onElementSelected(selected ? 'shapes' : null),
              ),
          ],
        ),
      ],
    );
  }
}
