import 'package:flutter/material.dart';

class NotificationService with ChangeNotifier {
  final List<NotificationItem> _notifications = [];

  List<NotificationItem> get notifications => _notifications;

  void addNotification(NotificationItem notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  void removeNotification(int index) {
    _notifications.removeAt(index);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}

class NotificationItem {
  final String text;
  final String date;
  final Color color;

  NotificationItem({
    required this.text,
    required this.date,
    required this.color,
  });
}
