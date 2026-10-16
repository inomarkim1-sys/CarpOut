import 'package:flutter/material.dart';

class FeedingLogScreen extends StatefulWidget {
  const FeedingLogScreen({Key? super.key}) : super(key: super);

  @override
  _FeedingLogScreenState createState() => _FeedingLogScreenState();
}

class _FeedingLogScreenState extends State<FeedingLogScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedTimeOfDay = 'Утро';
  String _selectedDeliveryMethod = 'Спомб';
  
  final Map<String, bool> _feedIngredients = {
    'Пеллетс 10-15мм': false,
    'Бойлы резаные': false,
    'Бойлы крушеные': false,
    'Целые бойлы': false,
    'Зерновые (Кукуруза/Конопля)': false,
    'Тигровый орех': false,
  };

  final List<String> _times = ['Утро', 'Обед', 'Вечер', 'Ночь', 'Докорм'];
  final List<String> _methods = ['Спомб', 'Кобра', 'Лодка / Кораблик', 'Рогатка'];
  
  final List<String> _feedingHistory = [
    "Утро: 2кг на точку (Спомб) — Пеллетс 10-15мм, Бойлы резаные",
    "Обед: 2кг (Кобра) — Целые бойлы 20мм",
  ];

  void _saveFeeding() {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) return;

    List<String> selectedItems = [];
    _feedIngredients.forEach((key, value) {
      if (value) selectedItems.add(key);
    });

    if (selectedItems.isEmpty) return;

    setState(() {
      String record = "$_selectedTimeOfDay: ${amount}кг ($_selectedDeliveryMethod) — ${selectedItems.join(', ')}";
      _feedingHistory.insert(0, record);
      _amountController.clear();
      _feedIngredients.updateAll((key, value) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CarpOut — Журнал Закорма'), backgroundColor: Colors.green.shade800),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedTimeOfDay,
                    decoration: const InputDecoration(labelText: 'Время', border: OutlineInputBorder()),
                    items: _times.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) => setState(() => _selectedTimeOfDay = val!),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedDeliveryMethod,
                    decoration: const InputDecoration(labelText: 'Способ', border: OutlineInputBorder()),
                    items: _methods.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (val) => setState(() => _selectedDeliveryMethod = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Количество корма (кг)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.scale)),
            ),
            const SizedBox(height: 12),
            const Text('Состав прикормочного микса:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: _feedIngredients.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: _feedIngredients[key],
                    activeColor: Colors.green.shade800,
                    onChanged: (bool? value) => setState(() => _feedIngredients[key] = value!),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: _saveFeeding,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade800),
                child: const Text('ЗАФИКСИРОВАТЬ ЗАКОРМ', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('История кормления:', style: TextStyle(fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _feedingHistory.length,
              itemBuilder: (context, index) {
                return Card(child: ListTile(leading: const Icon(Icons.restaurant, color: Colors.green), title: Text(_feedingHistory[index])));
              },
            ),
          ],
        ),
      ),
    );
  }
}
