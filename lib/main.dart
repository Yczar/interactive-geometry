import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const GeometricLearningApp());
}

class GeometricLearningApp extends StatelessWidget {
  const GeometricLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geometric Learning Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const GeometricLearningDemo(),
    );
  }
}

class GeometricLearningDemo extends StatefulWidget {
  const GeometricLearningDemo({super.key});

  @override
  State<GeometricLearningDemo> createState() => _GeometricLearningDemoState();
}

class _GeometricLearningDemoState extends State<GeometricLearningDemo>
    with TickerProviderStateMixin {
  // Basic transformations
  double _translateX = 0.0;
  double _translateY = 0.0;
  double _rotation = 0.0;
  double _scale = 1.0;

  // Teaching mode controls
  String _currentMode = 'transform';
  bool _showGuides = true;
  final List<Offset> _points = [];
  final List<List<Offset>> _lines = [];
  final List<List<Offset>> _shapes = [];

  // Selected element for transformation
  String? _selectedElement;
  int _selectedIndex = -1;

  void _resetAll() {
    setState(() {
      _points.clear();
      _lines.clear();
      _shapes.clear();
      _resetTransformation();
    });
  }

  void _resetTransformation() {
    setState(() {
      _translateX = 0.0;
      _translateY = 0.0;
      _rotation = 0.0;
      _scale = 1.0;
      _selectedElement = null;
      _selectedIndex = -1;
    });
  }

  Matrix4 _getTransformationMatrix() {
    if (_currentMode != 'transform' || _selectedElement == null) {
      return Matrix4.identity();
    }

    final matrix = Matrix4.identity()
      ..translate(_translateX, _translateY)
      ..rotateZ(_rotation * math.pi / 180)
      ..scale(_scale);

    return matrix;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.purple.shade50],
          ),
        ),
        child: Row(
          children: [
            // Control Panel
            SizedBox(
              width: 300,
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildModeSelector(),
                      const SizedBox(height: 16),
                      if (_currentMode == 'transform') _buildElementSelector(),
                      _buildCurrentModeControls(),
                      const Spacer(),
                      _buildUtilityControls(),
                    ],
                  ),
                ),
              ),
            ),

            // Visualization Area
            Expanded(
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.all(16),
                child: ClipRect(
                  child: Stack(
                    children: [
                      if (_showGuides)
                        CustomPaint(
                          size: Size.infinite,
                          painter: EnhancedGridPainter(),
                        ),

                      // Transform container for all geometric elements
                      Transform(
                        transform: _getTransformationMatrix(),
                        alignment: Alignment.center,
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: GeometricElementsPainter(
                            points: _points,
                            lines: _lines,
                            shapes: _shapes,
                            selectedElement: _selectedElement,
                            selectedIndex: _selectedIndex,
                          ),
                        ),
                      ),

                      // Gesture detector
                      Positioned.fill(
                        child: GestureDetector(
                          onTapUp: _handleTap,
                          onPanStart: _handlePanStart,
                          onPanUpdate: _handlePanUpdate,
                          onPanEnd: _handlePanEnd,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
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
            _buildModeChip('Transform', 'transform', Icons.transform),
            _buildModeChip('Point', 'point', Icons.location_on),
            _buildModeChip('Line', 'line', Icons.show_chart),
            _buildModeChip('Plane', 'plane', Icons.category),
          ],
        ),
      ],
    );
  }

  Widget _buildModeChip(String label, String mode, IconData icon) {
    return FilterChip(
      selected: _currentMode == mode,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (bool selected) {
        if (selected) {
          setState(() => _currentMode = mode);
        }
      },
    );
  }

  Widget _buildElementSelector() {
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
              selected: _selectedElement == 'all',
              onSelected: (selected) {
                setState(() {
                  _selectedElement = selected ? 'all' : null;
                  _selectedIndex = -1;
                });
              },
            ),
            if (_points.isNotEmpty)
              ChoiceChip(
                label: const Text('Points'),
                selected: _selectedElement == 'points',
                onSelected: (selected) {
                  setState(() {
                    _selectedElement = selected ? 'points' : null;
                    _selectedIndex = -1;
                  });
                },
              ),
            if (_lines.isNotEmpty)
              ChoiceChip(
                label: const Text('Lines'),
                selected: _selectedElement == 'lines',
                onSelected: (selected) {
                  setState(() {
                    _selectedElement = selected ? 'lines' : null;
                    _selectedIndex = -1;
                  });
                },
              ),
            if (_shapes.isNotEmpty)
              ChoiceChip(
                label: const Text('Shapes'),
                selected: _selectedElement == 'shapes',
                onSelected: (selected) {
                  setState(() {
                    _selectedElement = selected ? 'shapes' : null;
                    _selectedIndex = -1;
                  });
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentModeControls() {
    switch (_currentMode) {
      case 'transform':
        return _buildTransformControls();
      case 'point':
        return _buildPointControls();
      case 'line':
        return _buildLineControls();
      case 'plane':
        return _buildPlaneControls();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTransformControls() {
    if (_selectedElement == null) {
      return const Center(
        child: Text(
          'Select an element to transform',
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('Translation',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildLabeledSlider(
          label: 'X',
          value: _translateX,
          min: -200,
          max: 200,
          onChanged: (value) => setState(() => _translateX = value),
        ),
        _buildLabeledSlider(
          label: 'Y',
          value: _translateY,
          min: -200,
          max: 200,
          onChanged: (value) => setState(() => _translateY = value),
        ),
        const SizedBox(height: 16),
        const Text('Rotation', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildLabeledSlider(
          label: '°',
          value: _rotation,
          min: 0,
          max: 360,
          onChanged: (value) => setState(() => _rotation = value),
          valueFormatter: (value) => '${value.round()}°',
        ),
        const SizedBox(height: 16),
        const Text('Scale', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildLabeledSlider(
          label: '×',
          value: _scale,
          min: 0.5,
          max: 2.0,
          divisions: 30,
          onChanged: (value) => setState(() => _scale = value),
          valueFormatter: (value) => value.toStringAsFixed(2),
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.restart_alt),
            label: const Text('Reset Transformation'),
            onPressed: _resetTransformation,
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required ValueChanged<double> onChanged,
    String Function(double)? valueFormatter,
  }) {
    return Row(
      children: [
        SizedBox(width: 20, child: Text(label)),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 50,
          child: Text(
            valueFormatter?.call(value) ?? value.round().toString(),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildPointControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Click anywhere on the grid to create points.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        if (_points.isNotEmpty)
          ElevatedButton.icon(
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear Points'),
            onPressed: () => setState(() => _points.clear()),
          ),
      ],
    );
  }

  Widget _buildLineControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Drag on the grid to create lines.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        if (_lines.isNotEmpty)
          ElevatedButton.icon(
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear Lines'),
            onPressed: () => setState(() => _lines.clear()),
          ),
      ],
    );
  }

  Widget _buildPlaneControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Drag to create shapes. Release to close the shape.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        if (_shapes.isNotEmpty)
          ElevatedButton.icon(
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear Shapes'),
            onPressed: () => setState(() => _shapes.clear()),
          ),
      ],
    );
  }

  Widget _buildUtilityControls() {
    return Column(
      children: [
        const Divider(),
        SwitchListTile(
          title: const Text('Show Grid'),
          value: _showGuides,
          onChanged: (value) => setState(() => _showGuides = value),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          icon: const Icon(Icons.refresh),
          label: const Text('Reset All'),
          onPressed: _resetAll,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade400,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _handleTap(TapUpDetails details) {
    if (_currentMode == 'point') {
      setState(() {
        _points.add(details.localPosition);
      });
    }
  }

  void _handlePanStart(DragStartDetails details) {
    if (_currentMode == 'line') {
      setState(() {
        _lines.add([details.localPosition, details.localPosition]);
      });
    } else if (_currentMode == 'plane') {
      setState(() {
        _shapes.add([details.localPosition]);
      });
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_currentMode == 'line' && _lines.isNotEmpty) {
      setState(() {
        _lines.last[1] = details.localPosition;
      });
    } else if (_currentMode == 'plane' && _shapes.isNotEmpty) {
      setState(() {
        _shapes.last.add(details.localPosition);
      });
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_currentMode == 'plane' && _shapes.isNotEmpty) {
      setState(() {
        if (_shapes.last.length > 2) {
          _shapes.last.add(_shapes.last.first); // Close the shape
        } else {
          _shapes.removeLast(); // Remove if not enough points
        }
      });
    }
  }
}

class EnhancedGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..strokeWidth = 1;

    final paintAxes = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 2;

    // Draw grid
    const gridSize = 20.0;
    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paintGrid,
      );
    }
    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paintGrid,
      );
    }

    // Draw axes
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // X-axis
    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      paintAxes,
    );

    // Y-axis
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      paintAxes,
    );

    // Draw center point
    final centerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(centerX, centerY),
      4,
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class GeometricElementsPainter extends CustomPainter {
  final List<Offset> points;
  final List<List<Offset>> lines;
  final List<List<Offset>> shapes;
  final String? selectedElement;
  final int selectedIndex;

  GeometricElementsPainter({
    required this.points,
    required this.lines,
    required this.shapes,
    required this.selectedElement,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw points
    final pointPaint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    for (var i = 0; i < points.length; i++) {
      final isSelected = selectedElement == 'points' && selectedIndex == i ||
          selectedElement == 'all';

      // Draw point shadow
      pointPaint
        ..color = Colors.black.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(
        points[i] + const Offset(2, 2),
        isSelected ? 8 : 6,
        pointPaint,
      );

      // Draw point
      pointPaint
        ..color = isSelected ? Colors.red : Colors.blue
        ..maskFilter = null;
      canvas.drawCircle(
        points[i],
        isSelected ? 8 : 6,
        pointPaint,
      );

      // Draw point border
      pointPaint
        ..color = Colors.white
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(
        points[i],
        isSelected ? 8 : 6,
        pointPaint,
      );
    }

    // Draw lines
    final linePaint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].length == 2) {
        final isSelected = selectedElement == 'lines' && selectedIndex == i ||
            selectedElement == 'all';

        // Draw line shadow
        linePaint
          ..color = Colors.black.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawLine(
          lines[i][0] + const Offset(2, 2),
          lines[i][1] + const Offset(2, 2),
          linePaint,
        );

        // Draw line
        linePaint
          ..color = isSelected ? Colors.red : Colors.green
          ..maskFilter = null;
        canvas.drawLine(
          lines[i][0],
          lines[i][1],
          linePaint,
        );

        // Draw endpoints
        pointPaint
          ..color = isSelected ? Colors.red : Colors.green
          ..style = PaintingStyle.fill;
        canvas.drawCircle(lines[i][0], 4, pointPaint);
        canvas.drawCircle(lines[i][1], 4, pointPaint);
      }
    }

    // Draw shapes
    final shapePaint = Paint()..style = PaintingStyle.fill;

    final shapeOutlinePaint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < shapes.length; i++) {
      if (shapes[i].length > 2) {
        final isSelected = selectedElement == 'shapes' && selectedIndex == i ||
            selectedElement == 'all';

        final path = Path()..moveTo(shapes[i][0].dx, shapes[i][0].dy);
        for (var j = 1; j < shapes[i].length; j++) {
          path.lineTo(shapes[i][j].dx, shapes[i][j].dy);
        }
        path.close();

        // Draw shape shadow
        shapePaint
          ..color = Colors.black.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawPath(
          path.shift(const Offset(2, 2)),
          shapePaint,
        );

        // Draw shape fill
        shapePaint
          ..color = isSelected
              ? Colors.red.withOpacity(0.3)
              : Colors.purple.withOpacity(0.3)
          ..maskFilter = null;
        canvas.drawPath(path, shapePaint);

        // Draw shape outline
        shapeOutlinePaint.color = isSelected ? Colors.red : Colors.purple;
        canvas.drawPath(path, shapeOutlinePaint);

        // Draw vertices
        pointPaint
          ..color = isSelected ? Colors.red : Colors.purple
          ..style = PaintingStyle.fill;
        for (var vertex in shapes[i]) {
          canvas.drawCircle(vertex, 4, pointPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant GeometricElementsPainter oldDelegate) {
    return points != oldDelegate.points ||
        lines != oldDelegate.lines ||
        shapes != oldDelegate.shapes ||
        selectedElement != oldDelegate.selectedElement ||
        selectedIndex != oldDelegate.selectedIndex;
  }
}

// Extension methods for animations if needed
extension GeometricAnimations on _GeometricLearningDemoState {
  Future<void> animatePoint(Offset target, {Duration? duration}) async {
    final startPoint = Offset(
      target.dx - 100,
      target.dy - 100,
    );

    setState(() {
      _points.add(startPoint);
    });

    const steps = 30;
    for (var i = 1; i <= steps; i++) {
      await Future.delayed(const Duration(milliseconds: 16));
      setState(() {
        _points.last = Offset(
          startPoint.dx + (target.dx - startPoint.dx) * i / steps,
          startPoint.dy + (target.dy - startPoint.dy) * i / steps,
        );
      });
    }
  }

  Future<void> animateLine(Offset start, Offset end,
      {Duration? duration}) async {
    setState(() {
      _lines.add([start, start]);
    });

    const steps = 30;
    for (var i = 1; i <= steps; i++) {
      await Future.delayed(const Duration(milliseconds: 16));
      setState(() {
        _lines.last[1] = Offset(
          start.dx + (end.dx - start.dx) * i / steps,
          start.dy + (end.dy - start.dy) * i / steps,
        );
      });
    }
  }

  Future<void> animateShape(List<Offset> vertices, {Duration? duration}) async {
    if (vertices.length < 3) return;

    setState(() {
      _shapes.add([vertices.first]);
    });

    for (var i = 1; i < vertices.length; i++) {
      const steps = 15;
      final start = vertices[i - 1];
      final end = vertices[i];

      for (var step = 1; step <= steps; step++) {
        await Future.delayed(const Duration(milliseconds: 16));
        setState(() {
          _shapes.last.add(Offset(
            start.dx + (end.dx - start.dx) * step / steps,
            start.dy + (end.dy - start.dy) * step / steps,
          ));
        });
      }
    }

    // Close the shape
    await animateLine(_shapes.last.last, vertices.first);
    setState(() {
      _shapes.last.add(vertices.first);
    });
  }
}
