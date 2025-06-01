import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
 
    await _firebaseMessaging.requestPermission();


    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');

    initMessageHandlers();
  }

  void initMessageHandlers() {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('== Уведомление в foreground ==');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('== Уведомление открыто из фона ==');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('== Приложение открыто по уведомлению ==');
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
      }
    });
  }
}
