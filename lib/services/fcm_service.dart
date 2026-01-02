import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  //instance of FCM
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  //instance For Local Notification Service
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //FCM Initialization Function
  Future<void> initNotification() async {
    //Request Permissin
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User denied permission');
    }

    //Get FCM Tocken
    String? token = await _fcm.getToken();
    print('FCM Token: $token');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    handleForegroundMessages();
    //Call Local Notifications Functions
    initShowLocacalNotification();
  }

  //Handle For Foreground messages Fcm
  Future<void> handleForegroundMessages() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground Message: ${message.notification?.title}');
      print('Foreground Message: ${message.notification?.body}');

      ///Click For Foreground Hangle Hare
      if (message.notification != null) {
        _showLocalNotification(message); //Local Notification Show
      }
    });
  }

  //Handle For Web messages Fcm
  Future<void> handleWebMessages() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Foreground Message: ${message.notification?.title}');
      print('Foreground Message: ${message.notification?.body}');

      ///Click For Foreground Hangle Hare
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  //Local Notification Initialization Function
  Future<void> initShowLocacalNotification() async {
    //Settings for Local Notification
    //set Notification Icon
    AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    //Ios Settings
    DarwinInitializationSettings iosStizlizationSettings =
    DarwinInitializationSettings();
    //All Local Notifications Settings androidInitializationSettings,iosStizlizationSettings
    InitializationSettings initSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosStizlizationSettings,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        //Click For Local Notification Hangle Hare
        print("User tapped local notification: ${response.payload}");
        //Use Notifications Click Navigation
      },
    );


  }
  //Show Notifications Pop up Functions
  Future<void> _showLocalNotification(RemoteMessage message) async {
    //Local Notification Details android
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'high_importance_channel', //channel id Unique
      'High Importance Notifications', //channel name
      channelDescription:
      'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
    );

    //ios Details// Local Notification Details ios
    const DarwinNotificationDetails iosNotificationDetails =
    DarwinNotificationDetails(presentAlert: true, presentBadge: true);
    //All Notification Details
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    //Show popUP
    _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: message.data.toString(), //click and Work
    );
  }
}

//TOP Lavel Function For Background Messege Handler Fcm
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  ///Click For Foreground Hangle Hare
  print('Handling a background message: ${message.messageId}');
}
