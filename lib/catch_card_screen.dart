import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class CatchCardScreen extends StatefulWidget {
  const CatchCardScreen({Key? super.key}) : super(key: super);

  @override
  _CatchCardScreenState createState() => _CatchCardScreenState();
}

class _CatchCardScreenState extends State<CatchCardScreen> {
  int _weightKg = 5;
  int _weightGr = 0;
  String _selectedCarpType = 'Чешуйчатый карп';
  String _selectedPoint = 'Точка 1 (Бровка 60м)';
  String _selectedBait = 'Soluble Boilie 20mm + Pop-up';

  final List<String> _carpTypes = ['Чешуйчатый карп', 'Зеркальный карп', 'Амур', 'Карась/Линь'];
  final List<String> _points = ['Точка 1 (Бровка 60м)', 'Точка 2 (Ил 85м)'];
  final List<String> _baits = ['Soluble Boilie 20mm + Pop-up', 'Wafters 14mm', 'Single Pop-up 10mm'];

  final List<Map<String, String>> _catchHistory = [
    {'weight': '12.400 кг', 'type': 'Зеркальный карп', 'point': 'Точка 1 (Бровка 60м)', 'bait': 'Soluble Boilie + Pop-up', 'time': '04:15'}
  ];

  void _saveCatch() {
    setState(() {
      String finalWeight = "$_weightKg.${_weightGr.toString().padLeft(3, '0').substring(0, 3)} кг";
      final now = DateTime.now();
      String timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

      _catchHistory.insert(0, {
        'weight': finalWeight,
        'type': _selectedCarpType,
        'point': _selectedPoint,
        'bait': _selectedBait,
        'time': timeStr,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CarpOut — Новая Поимка'), backgroundColor: Colors.green.shade800),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Вес трофея:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('КГ: $_weightKg', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() { if(_weightKg > 0) _weightKg--; })),
                  IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() => _weightKg++)),
                  const SizedBox(width: 20),
                  Text('ГР: $_weightGr', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() { if(_weightGr > 0) _weightGr -= 50; })),
                  IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() { if(_weightGr < 950) _weightGr += 50; })),
                ],
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCarpType,
              decoration: const InputDecoration(labelText: 'Вид рыбы', border: OutlineInputBorder()),
              items: _carpTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (val) => setState(() => _selectedCarpType = val!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedPoint,
              decoration: const InputDecoration(labelText: 'Из какой точки (Свим)', border: OutlineInputBorder()),
              items: _points.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (val) => setState(() => _selectedPoint = val!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedBait,
              decoration: const InputDecoration(labelText: 'Насадка', border: OutlineInputBorder()),
              items: _baits.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
              onChanged: (val) => setState(() => _selectedBait = val!),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: _saveCatch,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade800),
                child: const Text('ЗАРЕГИСТРИРОВАТЬ ПОИМКУ', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _catchHistory.length,
              itemBuilder: (context, index) {
                final c = _catchHistory[index];
                return Card(
                  child: ListTile(
                    title: Text('${c['weight']} — ${c['type']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.darkGreen)),
                    subtitle: Text('Точка: ${c['point']}\nНасадка: ${c['bait']} | Время: ${c['time']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.share, color: Colors.green),
                      onPressed: () {
                        Share.share('🎣 Трофей в приложении CarpOut!\nВес: ${c['weight']}\nНасадка: ${c['bait']}\nВзят из: ${c['point']}');
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
