import 'package:flutter/material.dart';

class Ex2InputControlsDemo extends StatefulWidget {
  const Ex2InputControlsDemo({super.key});

  @override
  State<Ex2InputControlsDemo> createState() => InputControlsDemo();
}

class InputControlsDemo() extends State<Ex2InputControlsDemo> {
  double sliderValue = 50;

  bool isNotificationsOn = true;

  String selectedLevel = 'Beginner';

  DateTime? selectedDate;

  Future<void> pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Controls Demo')),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          const Text(
            'Adjust your learning preferences',

            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          // Slider
          Text('Progress: ${sliderValue.round()}%'),

          Slider(
            value: sliderValue,
            min: 0,
            max: 100,
            divisions: 10,
            label: '${sliderValue.round()}%',

            onChanged: (value) {
              setState(() {
                sliderValue = value;
              });
            },
          ),

          const Divider(),

          // Switch
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: Text(isNotificationsOn ? 'Enabled' : 'Disable'),

            value: isNotificationsOn,
            onChanged: (value) {
              setState(() {
                isNotificationsOn = value;
              });
            },
          ),

          const Divider(),

          // Radio list title
          const Text(
            'Learning Level',

            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          RadioListTile<String>(
            title: const Text('Beginner'),

            value: 'Beginner',
            groupValue: selectedLevel,
            onChanged: (value) {
              setState(() {
                selectedLevel = value!;
              });
            },
          ),

          RadioListTile<String>(
            title: const Text('Intermediate'),
            value: 'Intermediate',
            groupValue: selectedLevel,
            onChanged: (value) {
              setState(() {
                selectedLevel = value!;
              });
            },
          ),

          RadioListTile<String>(
            title: const Text('Advance'),
            value: 'Advance',
            groupValue: selectedLevel,
            onChanged: (value) {
              setState(() {
                selectedLevel = value!;
              });
            },
          ),
          const SizedBox(height: 12),

          // Date Picker
          FilledButton.icon(
            onPressed: pickDate,
            icon: const Icon(Icons.calendar_month),

            label: const Text('Choose study date'),
          ),

          const SizedBox(height: 12),

          // Display values
          Card(
            child: Padding(
              padding: const EdgeInsetsGeometry.all(16),
              child: Text(
                'Current values:\n'
                'Progress: ${sliderValue.round()}%\n'
                'Notifications: '
                '${isNotificationsOn ? "On" : "Off"}\n'
                'Level: $selectedLevel\n'
                'Date: '
                '${selectedDate == null ? "Not selected" : formatDate(selectedDate!)}',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
