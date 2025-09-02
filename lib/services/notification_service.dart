// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:depth_tracker_app/DataBase/firebase/firebase_low_level_classes.dart';
// import 'package:depth_tracker_app/services/user_services.dart';
// import 'dart:async';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();
//   static bool _initialized = false;

//   static Future<void> initialize() async {
//     if (_initialized) return;

//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const settings = InitializationSettings(android: android);

//     await _notifications.initialize(settings);
//     await _initializeFCM();
//     _initialized = true;
//   }

//   static Future<void> _initializeFCM() async {
//     final messaging = FirebaseMessaging.instance;
    
//     // Request permission
//     await messaging.requestPermission();
    
//     // Get FCM token and save to user profile
//     final token = await messaging.getToken();
//     if (token != null) {
//       await _saveFCMToken(token);
//     }
    
//     // Listen for foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         showNotification(
//           title: message.notification!.title ?? '',
//           body: message.notification!.body ?? '',
//         );
//       }
//     });
//   }

//   static Future<void> _saveFCMToken(String token) async {
//     final authService = FirebaseAuthService();
//     final currentUserId = authService.getCurrentUserId();
    
//     if (currentUserId != null) {
//       await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(currentUserId)
//           .update({'fcmToken': token});
//     }
//   }

//   static Future<void> showNotification({
//     required String title,
//     required String body,
//   }) async {
//     await initialize();

//     const android = AndroidNotificationDetails(
//       'debt_tracker',
//       'Debt Tracker',
//       channelDescription: 'Debt Tracker notifications',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//     const details = NotificationDetails(android: android);

//     await _notifications.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       title,
//       body,
//       details,
//     );
//   }

//   static Future<void> showReceivableNotification(
//     String userName,
//     double amount,
//   ) async {
//     await showNotification(
//       title: 'New Receivable',
//       body: 'You have a new receivable from $userName - Rs $amount',
//     );
//   }

//   static Future<void> showPaymentNotification(
//     String userName,
//     double amount,
//   ) async {
//     await showNotification(
//       title: 'Payment Received',
//       body: '$userName has paid Rs $amount',
//     );
//   }

//   static Future<void> showLoanNotification(
//     String lenderName,
//     double amount,
//   ) async {
//     await showNotification(
//       title: 'Payment Made',
//       body: 'You paid Rs $amount to $lenderName',
//     );
//   }

//   static StreamSubscription? _receivableListener;

//   static Future<void> startListening() async {
//     final authService = FirebaseAuthService();
//     final currentUserId = authService.getCurrentUserId();

//     if (currentUserId == null) return;

//     _receivableListener = FirebaseFirestore.instance
//         .collection('Receivables')
//         .snapshots()
//         .listen((snapshot) async {
//           for (var change in snapshot.docChanges) {
//             if (change.type == DocumentChangeType.added) {
//               final data = change.doc.data() as Map<String, dynamic>;
//               final participants = List<String>.from(
//                 data['participants'] ?? [],
//               );

//               // Check if current user is in participants (but not creator)
//               if (participants.contains(currentUserId) &&
//                   participants.first != currentUserId) {
//                 final userService = UserService();
//                 final creatorUser = await userService.fetchUserById(
//                   participants.first,
//                 );
//                 final creatorName = creatorUser?.userName ?? 'Unknown';

//                 final userIndex = participants.indexOf(currentUserId);
//                 final amount = userIndex < (data['rate'] as List).length
//                     ? (data['rate'][userIndex] as num).toDouble()
//                     : 0.0;

//                 if (amount > 0) {
//                   await showReceivableNotification(creatorName, amount);
//                 }
//               }
//             }
//           }
//         });
//   }

//   static void stopListening() {
//     _receivableListener?.cancel();
//     _receivableListener = null;
//   }
// }
