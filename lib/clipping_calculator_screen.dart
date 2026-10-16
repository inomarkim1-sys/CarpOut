import 'package:flutter/material.dart';

class ClippingCalculatorScreen extends StatefulWidget {
  const ClippingCalculatorScreen({Key? super.key}) : super(key: super);

  @override
  _ClippingCalculatorScreenState createState() => _ClippingCalculatorScreenState();
}

class _ClippingCalculatorScreenState extends State<ClippingCalculatorScreen> {
  final TextEditingController _distanceController = TextEditingController();
  double _distanceBetweenSticks = 4.0;
  String _selectedBottomType = 'Песок / Ракушка';
  double _calculatedWraps = 0.0;
  String _leadRecommendation = '';

  final List<double> _stickOptions = [3.0, 4.0, 5.0];
  final List<String> _bottomOptions = ['Мягкий ил', 'Глубокий ил', 'Песок / Ракушка', 'Завоз на лодке'];

  void _calculateSwim() {
    double distance = double.tryParse(_distanceController.text) ?? 0.0;
    if (distance <= 0) {
      setState(() {
        _calculatedWraps = 0.0;
        _leadRecommendation = 'Пожалуйста, введите корректную дистанцию.';
      });
      return;
    }

    double wraps = distance / _distanceBetweenSticks;
    String recommendation = '';
    
    if (_selectedBottomType == 'Завоз на лодке') {
      recommendation = "Грузило 'Гриппа' (Grippa) — идеально удерживает оснастку на склонах бровок при завозе.";
    } else if (distance > 120) {
      recommendation = "Грузило 'Пуля' (Horizon) — максимальная обтекаемость для сверхдальних забросов.";
    } else if (_selectedBottomType == 'Глубокий ил') {
      recommendation = "Грузило 'Плоская груша' на монтаже Вертолет — предотвратит глубокое погружение в ил.";
    } else {
      recommendation = "Грузило 'Лонг Каст' (Конус) на безопасной клипсе — универсальный вариант для твердого дна.";
    }

    setState(() {
      _calculatedWraps = wraps;
      _leadRecommendation = recommendation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CarpOut — Калькулятор клипс'), backgroundColor: Colors.green.shade800),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _distanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Дистанция до точки (метры)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<double>(
              value: _distanceBetweenSticks,
              decoration: const InputDecoration(labelText: 'Расстояние между колышками (м)', border: OutlineInputBorder()),
              items: _stickOptions.map((v) => DropdownMenuItem(value: v, child: Text('$v метра'))).toList(),
              onChanged: (v) => setState(() => _distanceBetweenSticks = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedBottomType,
              decoration: const InputDecoration(labelText: 'Структура дна в точке', border: OutlineInputBorder()),
              items: _bottomOptions.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) => setState(() => _selectedBottomType = v!),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: _calculateSwim,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade800),
                child: const Text('РАССЧИТАТЬ СВИМ', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            if (_calculatedWraps > 0) ...[
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Обороты: ${_calculatedWraps.toStringAsFixed(2)} об.', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.darkGreen)),
                      const SizedBox(height: 8),
                      Text(_leadRecommendation, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
