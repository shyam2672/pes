import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pes/router.dart';
import 'package:flutter/services.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await FirebaseMessaging.instance.subscribeToTopic('all');

  runApp(PehchaanApp(
    router: AppRouter(),
  ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class PehchaanApp extends StatefulWidget {
  final AppRouter? router;
  const PehchaanApp({Key? key, this.router}) : super(key: key);

  @override
  State<PehchaanApp> createState() => _PehchaanAppState();
}

class _PehchaanAppState extends State<PehchaanApp> {
  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.bottom]);
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                icon: "@mipmap/ic_launcher",
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text(notification.title!),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(notification.body!)],
                    ),
                  ),
                );
              });
        }
      },
    );

    // getToken();
  }

  // String? token;
  // getToken() async {
  //   token =
  //       "fReXwdZoTxa32tGkaIvpai:APA91bENqs5dgvQnRXW2ZMgRjjme6eFzadDm215hJW1xQVCX0eCjmntHBMhEe_arnaKsIzWwuDond0oo09pGhkLKMEDk2OVp-VCfh0ptrZtl9-22lUtTBFaquiNMxAJGc8atGQwd6Uic";
  //   // token = await FirebaseMessaging.instance.getToken();
  //   print(token);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pehchaan',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
          // brightness: Brightness.dark,
          /* dark theme settings */
          ),
      themeMode: ThemeMode.dark,
      onGenerateRoute: widget.router!.generateRoute,
    );
  }
}
