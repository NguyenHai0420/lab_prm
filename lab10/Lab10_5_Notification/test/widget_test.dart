import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_5_notification/services/notification_service.dart';

void main() {
  group('Lab 10.5 Notification Service Tests', () {
    test('NotificationService singleton instance check', () {
      final s1 = NotificationService();
      final s2 = NotificationService();
      expect(identical(s1, s2), isTrue);
    });

    test('NotificationService constants check', () {
      expect(NotificationService.channelId, 'lab10_notification_channel');
      expect(NotificationService.channelName, 'Lab 10 Notifications');
    });
  });
}
