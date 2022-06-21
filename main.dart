import 'package:flutter/material.dart';
import 'package:flutter_push_notificationss/services/push_notifications_service.dart';

import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationsService.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //context
    PushNotificationsService.messagesStream.listen((message) {
      print('MyApp: $message');
      final snackBar = SnackBar(content: Text(message));
      scaffoldKey.currentState?.showSnackBar(snackBar);
      navigatorKey.currentState?.pushReplacementNamed('message', arguments: message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      navigatorKey: navigatorKey, //navegar
      scaffoldMessengerKey: scaffoldKey, //mostrar snacks
      routes: {
        'home': (context) => const HomeScreen(),
        'message': (context) => const MessageScreen(),
      },
    );
  }
}
