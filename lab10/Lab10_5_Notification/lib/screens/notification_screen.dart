import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _notificationService = NotificationService();
  final List<Map<String, String>> _history = [];
  bool _permissionGranted = false;
  int _counter = 1;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final granted = await _notificationService.requestPermission();
    if (mounted) {
      setState(() => _permissionGranted = granted);
    }
  }

  Future<void> _triggerInstantNotification() async {
    final id = _counter++;
    final title = 'System Alert #$id';
    final body = 'PRM393 Lab 10: Local notification triggered successfully (LO7)!';

    await _notificationService.showNotification(
      id: id,
      title: title,
      body: body,
      payload: 'action_payload_$id',
    );

    setState(() {
      _history.insert(0, {
        'id': '$id',
        'title': title,
        'body': body,
        'time': '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}',
      });
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification sent to system tray: "$title"'),
          backgroundColor: Colors.teal.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _triggerCustomDialog() async {
    final titleController = TextEditingController(text: 'Authentication Success');
    final bodyController = TextEditingController(text: 'User Emily Johnson logged in successfully.');

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Send Custom Notification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Notification Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: 'Notification Body'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              final id = _counter++;
              _notificationService.showNotification(
                id: id,
                title: titleController.text.trim(),
                body: bodyController.text.trim(),
              );
              setState(() {
                _history.insert(0, {
                  'id': '$id',
                  'title': titleController.text.trim(),
                  'body': bodyController.text.trim(),
                  'time': '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}',
                });
              });
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.5: Local Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Request Permission',
            onPressed: _checkPermission,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Permission & LO7 Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.notifications_active, color: Colors.indigo.shade700, size: 28),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Learning Outcome 7 (LO7)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _permissionGranted ? Colors.green.shade100 : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _permissionGranted ? 'Permission Granted' : 'Requesting...',
                          style: TextStyle(
                            color: _permissionGranted ? Colors.green.shade900 : Colors.orange.shade900,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Demonstrates integrating flutter_local_notifications for Android (with POST_NOTIFICATIONS permission) and iOS.',
                    style: TextStyle(fontSize: 12.5, color: Colors.grey.shade800),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            ElevatedButton.icon(
              onPressed: _triggerInstantNotification,
              icon: const Icon(Icons.send_rounded),
              label: const Text('Trigger Instant Notification (LO7)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: _triggerCustomDialog,
              icon: const Icon(Icons.edit_notifications),
              label: const Text('Send Custom Notification'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 28),

            // History Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sent Notifications History (${_history.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                if (_history.isNotEmpty)
                  TextButton(
                    onPressed: () => setState(() => _history.clear()),
                    child: const Text('Clear History'),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            if (_history.isEmpty)
              Container(
                padding: const EdgeInsets.all(28),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Icon(Icons.notifications_none, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    Text(
                      'No notifications triggered yet.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap "Trigger Instant Notification" above to test.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final item = _history[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text('#${item['id']}'),
                      ),
                      title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(item['body']!),
                      trailing: Text(item['time']!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
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
