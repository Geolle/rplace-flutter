import 'dart:math';

import 'package:flutter/material.dart';

class CanvasWidget extends StatefulWidget {
  final Color selectedColor;

  CanvasWidget({required this.selectedColor});

  @override
  _CanvasWidgetState createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends State<CanvasWidget> {
  int gridWidth = 1000; // 默认画布的宽度（像素）
  int gridHeight = 1000; // 默认画布的高度（像素）
  double pixelSize = 10; // 默认每个像素大小
  late List<List<Color>> pixels;
  late ScrollController _hScrollController;
  late ScrollController _vScrollController;

  final Set<Point> updatedPixels = {};

  @override
  void initState() {
    super.initState();
    _resetPixels();

    for (int i = 0; i <= gridWidth; i++) {
      for (int j = 0; j <= gridHeight; j++) {
        updatePixel(i, j, getRandomColor());
      }
    }

    _hScrollController = ScrollController();
    _vScrollController = ScrollController();
  }

  @override
  void dispose() {
    _hScrollController.dispose();
    _vScrollController.dispose();
    super.dispose();
  }

  void updatePixel(int x, int y, Color color) {
    if (x < gridHeight && y < gridWidth) {
      setState(() {
        pixels[x][y] = color;
        updatedPixels.add(Point(x, y));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            thickness: 8.0,
            radius: Radius.circular(10),
            child: SingleChildScrollView(
              controller: _hScrollController,
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                controller: _vScrollController,
                scrollDirection: Axis.vertical,
                child: GestureDetector(
                  onTapDown: (details) {
                    RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    Offset localPosition =
                        renderBox.globalToLocal(details.globalPosition);

                    double offsetX = _hScrollController.offset;
                    double offsetY = _vScrollController.offset;

                    int x = ((localPosition.dy + offsetY) ~/ pixelSize)
                        .clamp(0, gridHeight - 1);
                    int y = ((localPosition.dx + offsetX) ~/ pixelSize)
                        .clamp(0, gridWidth - 1);

                    updatePixel(x, y, widget.selectedColor);
                  },
                  child: RepaintBoundary(
                    child: CustomPaint(
                      size: Size(gridWidth * pixelSize, gridHeight * pixelSize),
                      painter: CanvasPainter(pixels, pixelSize, updatedPixels),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _resetPixels() {
    pixels = List.generate(
      gridHeight,
      // (index) => List<Color>.filled(gridWidth,   Colors.white),
      (index) => List<Color>.filled(gridWidth, Colors.black),
    );
    updatedPixels.clear();
  }
}

Color getRandomColor() {
  Random random = Random();

  // 获取 Colors.primaries 中的颜色列表
  List<Color> colors = Colors.primaries;

  // 生成一个随机索引
  int randomIndex = random.nextInt(colors.length);

  // 返回随机选择的颜色
  return colors[randomIndex];
}

class CanvasPainter extends CustomPainter {
  final List<List<Color>> pixels;
  final double pixelSize;
  final Set<Point> updatedPixels;

  CanvasPainter(this.pixels, this.pixelSize, this.updatedPixels);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // 仅绘制已更新的像素
    for (var point in updatedPixels) {
      int x = point.x.toInt();
      int y = point.y.toInt();
      paint.color = pixels[x][y];
      canvas.drawRect(
        Rect.fromLTWH(y * pixelSize, x * pixelSize, pixelSize, pixelSize),
        paint,
      );
    }

    var normalColor = Colors.grey.withOpacity(0.5);
    var splitColor = Colors.black.withOpacity(0.5);
    paint.color = normalColor;

    // 仅绘制需要的网格线
    for (int i = 0; i <= pixels.length; i += 100) {
      paint.strokeWidth = i % 1000 == 0 ? 2 : 1;
      paint.color = i % 1000 == 0 ? splitColor : normalColor;
      canvas.drawLine(
        Offset(0, i * pixelSize),
        Offset(size.width, i * pixelSize),
        paint,
      );
    }
    for (int j = 0; j <= pixels[0].length; j += 100) {
      paint.strokeWidth = j % 1000 == 0 ? 2 : 1;
      paint.color = j % 1000 == 0 ? splitColor : normalColor;
      canvas.drawLine(
        Offset(j * pixelSize, 0),
        Offset(j * pixelSize, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) {
    return updatedPixels.isNotEmpty;
  }
}
