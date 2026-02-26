// // ignore_for_file: unnecessary_null_comparison
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// // import '../../firebase_options.dart';
// import '../enums/enums.dart';
// import '../local/cache_helper.dart';
// import '../routing/app_routes.dart';
//
// //typedef BackgroundMessageHandler = Future<void> Function(RemoteMessage message);
// Future<void> firebaseMessagingBackgroundHandler(
//   RemoteMessage remoteMessage,
// ) async {
//   //BACKGROUND Notifications - iOS & Android
//
//   // TODO: Uncomment the following line after generating firebase_options.dart using 'flutterfire configure'
//   // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await Firebase.initializeApp();
// }
//
// late AndroidNotificationChannel channel;
// late FlutterLocalNotificationsPlugin localNotificationsPlugin;
//
// mixin FbNotifications {
//   /// CALLED IN main function between ensureInitialized <-> runApp(widget);
//   static Future<void> initNotifications() async {
//     try {
//       //Connect the previous created function with onBackgroundMessage to enable
//       //receiving notification when app in Background.
//       FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//
//       //Channel
//       if (!kIsWeb) {
//         channel = const AndroidNotificationChannel(
//           'app_notification_channel',
//           'Notifications Channel',
//           description: '',
//           importance: Importance.high,
//           enableLights: true,
//           enableVibration: true,
//           ledColor: Colors.blue,
//           showBadge: true,
//           playSound: true,
//         );
//       }
//
//       //Flutter Local Notifications Plugin (FOREGROUND) - ANDROID CHANNEL
//       localNotificationsPlugin = FlutterLocalNotificationsPlugin();
//       await localNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin
//           >()
//           ?.createNotificationChannel(channel);
//
//       //iOS Notification Setup (FOREGROUND)
//       await FirebaseMessaging.instance
//           .setForegroundNotificationPresentationOptions(
//             alert: true,
//             badge: true,
//             sound: true,
//           );
//
//       const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//       const iosInit = DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//       );
//       const initSettings = InitializationSettings(
//         android: androidInit,
//         iOS: iosInit,
//       );
//
//       await localNotificationsPlugin.initialize(
//         initSettings,
//         onDidReceiveNotificationResponse: (details) {
//           // لو حابب تعمل شيء عند الضغط على النوتيفيكيشن
//           // ممكن تنادي هنا _controlNotificationNavigation({ ... });
//         },
//       );
//     } catch (e) {
//       if (kDebugMode) {
//         print('❌ Error initializing Firebase notifications: $e');
//       }
//       rethrow;
//     }
//   }
//
//   //
//   //iOS Notification Permission
//   Future<void> requestNotificationPermissions() async {
//     NotificationSettings notificationSettings = await FirebaseMessaging.instance
//         .requestPermission(alert: true, badge: true, sound: true);
//     if (notificationSettings.authorizationStatus ==
//         AuthorizationStatus.authorized) {
//     } else if (notificationSettings.authorizationStatus ==
//         AuthorizationStatus.denied) {}
//   }
//
//   //ANDROID
//   void initializeForegroundNotificationForAndroid() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? androidNotification = notification?.android;
//       if (notification != null && androidNotification != null) {
//         localNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channelDescription: channel.description,
//               icon: '@mipmap/ic_launcher',
//             ),
//           ),
//         );
//       }
//     });
//   }
//
//   /// Handle notification taps while app is in background
//   void manageNotificationAction() {
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _controlNotificationNavigation(message.data);
//     });
//   }
//
//   /// Handle notification tap when app is killed and opened via tap
//   Future<void> handleInitialNotification() async {
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       _controlNotificationNavigation(initialMessage.data);
//     }
//   }
//
//   Future<void> callNotifications() async {
//     await requestNotificationPermissions();
//     initializeForegroundNotificationForAndroid();
//     manageNotificationAction();
//     handleInitialNotification();
//   }
//
//   /// Change this logic to match your app's routing
//   void _controlNotificationNavigation(Map<String, dynamic> data) async {
//     var userToken = await CacheHelper.safeRead(key: CacheKeys.userToken.name);
//     if (userToken != null && userToken.toString().isNotEmpty) {
//       // Get.to(() => NotificationsPage());
//     } else {
//       Get.toNamed(Routes.loginRoute);
//     }
//   }
// }
