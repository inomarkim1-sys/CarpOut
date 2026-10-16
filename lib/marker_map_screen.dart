import 'package:flutter/material.dart';

class MarkerLogPoint {
  final double distance; 
  final double depth;    
  final String bottom;   

  MarkerLogPoint({required this.distance, required this.depth, required this.bottom});
}

class MarkerMapScreen extends StatefulWidget {
  const MarkerMapScreen({Key? super.key}) : super(key: super);

  @override
  _MarkerMapScreenState createState() => _MarkerMapScreenState();
}

class _MarkerMapScreenState extends State<MarkerMapScreen> {
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _depthController = TextEditingController();
  String _selectedBottom = 'Ракушка / Бровка';

  final List<MarkerLogPoint> _points = [
    MarkerLogPoint(distance: 20, depth: 1.5, bottom: 'Песок'),
    MarkerLogPoint(distance: 40, depth: 2.2, bottom: 'Ракушка / Бровка'),
    MarkerLogPoint(distance: 60, depth: 3.5, bottom: 'Мягкий ил'),
    MarkerLogPoint(distance: 80, depth: 3.8, bottom: 'Глубокий ил'),
  ];

  final List<String> _bottomTypes = ['Ракушка / Бровка', 'Песок', 'Мягкий ил', 'Глубокий ил', 'Трава / Коряги'];

  void _addMarkerPoint() {
    double dist = double.tryParse(_distanceController.text) ?? 0;
    double dep = double.tryParse(_depthController.text) ?? 0;

    if (dist <= 0 || dep <= 0) return;

    setState(() {
      _points.add(MarkerLogPoint(distance: dist, depth: dep, bottom: _selectedBottom));
      _points.sort((a, b) => a.distance.compareTo(b.distance));
      _distanceController.clear();
      _depthController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CarpOut — Маркерная карта'), backgroundColor: Colors.green.shade800),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Отрисовка рельефа дна (Луч №1)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomPaint(
                  painter: BottomReliefPainter(_points),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(child: Text('← Берег (0м)          Дистанция (метры)          Русло →', style: TextStyle(color: Colors.grey, fontSize: 11))),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _distanceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Дистанция (м)', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _depthController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Глубина (м)', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedBottom,
              decoration: const InputDecoration(labelText: 'Структура дна', border: OutlineInputBorder()),
              items: _bottomTypes.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
              onChanged: (val) => setState(() => _selectedBottom = val!),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: _addMarkerPoint,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade800),
                child: const Text('ДОБАВИТЬ ТОЧКУ ПРОМЕРА', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Таблица промеров сектора:', style: TextStyle(fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _points.length,
              itemBuilder: (context, index) {
                final p = _points[index];
                return ListTile(
                  leading: CircleAvatar(backgroundColor: Colors.green.shade800, child: Text('${p.distance.toInt()}м', style: const TextStyle(fontSize: 10, color: Colors.white))),
                  title: Text('Глубина: ${p.depth} м — ${p.bottom}'),
                  trailing: const Icon(Icons.waves, color: Colors.blue),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class BottomReliefPainter extends CustomPainter {
  final List<MarkerLogPoint> points;
  BottomReliefPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paintGround = Paint()..color = Colors.orange.shade800..style = PaintingStyle.stroke..strokeWidth = 3;
    final path = Path();
    path.moveTo(0, size.height * 0.3);

    double maxDist = points.last.distance > 0 ? points.last.distance + 20 : 100;
    double maxDepth = 6.0; 

    for (var p in points) {
      double x = (p.distance / maxDist) * size.width;
      double y = (p.depth / maxDepth) * size.height + (size.height * 0.1);
      path.lineTo(x, y);
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = Colors.green.shade900);
    }
    canvas.drawPath(path, paintGround);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
