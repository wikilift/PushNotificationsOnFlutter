//CA:AD:5C:D7:32:B1:14:86:AF:C9:CD:F4:7F:95:A4:55:5E:77:DD:DA

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream = StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future<void> _onbackgroundHandler(RemoteMessage msg) async {
    //  print("onbackground handler ${msg.messageId}");
    _messageStream.add(msg.notification?.title ?? '');
  }

  static Future<void> _onMessageHandler(RemoteMessage msg) async {
    //print("onMessage handler ${msg.messageId}");
    _messageStream.add(msg.data['id'] ?? 'no id');
    print(msg.data);
  }

  static Future<void> __onMessageOpenApp(RemoteMessage msg) async {
    //print("onMessageOpenApp handler ${msg.messageId}");
    _messageStream.add(msg.notification?.title ?? '');
  }

  static Future initializeApp() async {
    //push notifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print("Token: $token");
    //local notifications

    //handlers
    FirebaseMessaging.onBackgroundMessage(_onbackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(__onMessageOpenApp);
  }

  static closeStreams() {
    _messageStream.close();
  }
}
