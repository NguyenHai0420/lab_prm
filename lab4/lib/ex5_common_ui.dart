import 'package:flutter/material.dart';

class Ex5CommonUi extends StatefulWidget {
  const Ex5CommonUi({super.key});

  @override
  State<Ex5CommonUi> createState() => CommonUi();
}

class CommonUi extends State<Ex5CommonUi> {
  // State
  int _counter = 0;

  DateTime? _selectedDate;

  // Danh sách để hiển thị bằng ListView
  final List<String> items = List.generate(20, (index) => 'Item ${index + 1}');

  // Date Picker
  Future<void> _showDatePicker() async {
    // Context ở đây thuộc State của widget và nằm trong widget tree
    final date = await showDatePicker(
      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime(2020),

      lastDate: DateTime(2035),
    );

    // Kiểm tra widget vẫn còn tồn tại
    if (date != null && mounted) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 5 - Debug & Fix')),

      body: Column(
        children: [
          // SingleChildScrollView
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Common UI fixes',

                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 8),

                const Text(
                  'This screen demonstrates '
                  'corrected versions of common '
                  'Flutter layout and state problems.',
                ),

                const SizedBox(height: 12),

                // setState()
                Row(
                  children: [
                    Expanded(child: Text('Counter: $_counter')),

                    FilledButton(
                      onPressed: () {
                        // Không chỉ tăng biến, phải gọi setState để UI rebuild
                        setState(() {
                          _counter++;
                        });
                      },

                      child: const Text('Increase'),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Date picker
                FilledButton.icon(
                  onPressed: _showDatePicker,

                  icon: const Icon(Icons.calendar_today),

                  label: const Text('Open DatePicker'),
                ),

                // Hiển thị ngày đã chọn.
                if (_selectedDate != null) ...[
                  const SizedBox(height: 8),

                  Text(
                    'Selected: '
                    '${_selectedDate!.day}/'
                    '${_selectedDate!.month}/'
                    '${_selectedDate!.year}',
                  ),
                ],
              ],
            ),
          ),

          const Divider(),

          // ListView inside Column
          // Nếu đặt ListView trực tiếp trong Column,
          // Flutter có thể báo lỗi unbounded height
          // Expanded cung cấp chiều cao còn lại cho ListView
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              itemCount: items.length,

              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(items[index]),

                    leading: const Icon(Icons.check_circle_outline),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
