import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/push_notification.dart';
import '../services/api_service.dart';

class NotificationProvider extends ChangeNotifier {
  final List<PushNotification> _notifications = [];
  String? _token;

  List<PushNotification> get notifications => _notifications;
  String? get token => _token;

  static const _tokenKey = 'fcm_token';
  static const _notifKey = 'notif_list';

  NotificationProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();

    // Загрузка токена и уведомлений
    _token = prefs.getString(_tokenKey);
    final notifJson = prefs.getStringList(_notifKey) ?? [];
    _notifications.addAll(
      notifJson.map((str) => PushNotification.fromJson(jsonDecode(str))),
    );

    // Получаем и сохраняем актуальный токен
    final newToken = await FirebaseMessaging.instance.getToken();
    if (newToken != null && newToken != _token) {
      _token = newToken;
      await prefs.setString(_tokenKey, _token!);
      await ApiService.registerDevice(_token!);
    }

    _listenToMessages();
    notifyListeners();
  }

  void _listenToMessages() {
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.instance.getInitialMessage().then((msg) {
      if (msg != null) _handleMessage(msg);
    });
  }

  void _handleMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _addNotification(PushNotification(
        title: notification.title ?? 'Без заголовка',
        body: notification.body ?? 'Без текста',
      ));
    }
  }

  void clearNotifications() {
  _notifications.clear();
  notifyListeners();
}


  void simulateNotification() {
    _addNotification(PushNotification(
      title: 'Тестовое уведомление',
      body: 'Это симуляция уведомления',
    ));
  }

  Future<void> _addNotification(PushNotification notification) async {
    _notifications.insert(0, notification);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final notifJson = _notifications.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList(_notifKey, notifJson);
  }
}
