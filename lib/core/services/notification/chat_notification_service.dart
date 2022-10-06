import 'package:flutter/cupertino.dart';

import '../../models/chat_notification.dart';

class ChatNotificationService with ChangeNotifier {
  final List<ChatNotification> _items = [];

  List<ChatNotification> get items => [..._items];

  int get itemsCount => _items.length;

  String get resumedItemsCount =>
      _items.length > 9 ? '+9' : _items.length.toString();

  void add(ChatNotification notification) {
    _items.add(notification);
    notifyListeners();
  }

  void remove(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}
