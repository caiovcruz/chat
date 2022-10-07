import 'package:firebase_messaging/firebase_messaging.dart';
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

  // Push Notification
  Future<void> init() async {
    await _configureTerminated();
    await _configureForeground();
    await _configureBackground();
  }

  Future<bool> get _isAuthorized async {
    // final messaging = FirebaseMessaging.instance;
    // final settings = await messaging.requestPermission();
    // return settings.authorizationStatus == AuthorizationStatus.authorized;

    return true;
  }

  Future<void> _configureForeground() async {
    if (await _isAuthorized) {
      FirebaseMessaging.onMessage.listen(_messageHandler);
    }
  }

  Future<void> _configureBackground() async {
    if (await _isAuthorized) {
      FirebaseMessaging.onMessageOpenedApp.listen(_messageHandler);
    }
  }

  Future<void> _configureTerminated() async {
    if (await _isAuthorized) {
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      _messageHandler(initialMessage);
    }
  }

  void _messageHandler(RemoteMessage? message) {
    if (message != null && message.notification != null) {
      add(ChatNotification(
        title: message.notification!.title ?? 'No informed!',
        body: message.notification!.body ?? 'No informed!',
      ));
    }
  }
}
