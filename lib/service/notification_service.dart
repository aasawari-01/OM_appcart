import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'auth_manager.dart';

class NotificationService extends GetxService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';

  Future<NotificationService> init() async {
    await _initializeLocalNotifications();
    await _requestPermissions();
    _listenToMessages();
    return this;
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('Notification clicked: ${response.payload}');
        // Navigate to Alerts (NotificationScreen) using Get
        Get.toNamed('/notifications'); 
      },
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log('User declined or has not accepted permission');
    }
  }

  void _listenToMessages() {
    // Token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      log('FCM Token refreshed: $newToken');
      _syncTokenToBackend(newToken);
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
        _showLocalNotification(message);
      }
    });

    // Background message click (when app is in background but not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published!');
      // Handle navigation here
      Get.toNamed('/notifications');
    });

    // Check if the app was opened from a terminated state via a notification
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        log('App opened from terminated state via notification');
        // Handle initial message if needed
      }
    });
  }

  Future<void> _syncTokenToBackend(String token) async {
    try {
      final isLoggedIn = await Get.find<AuthManager>().isLoggedIn();
      if (isLoggedIn) {
        final userIdStr = await Get.find<AuthManager>().getUserId();
        if (userIdStr != null && userIdStr.isNotEmpty) {
          final userId = int.tryParse(userIdStr);
          if (userId != null) {
            log('Syncing new FCM token to backend for user $userId');
            // Using a simple map since we don't want to change other user data
            final Map<String, dynamic> updateData = {
              'device_token': token,
              'fcm_token': token,
            };
            // Note: We might need a specific API for this, but reusing updateUserProfile 
            // if the backend allows partial updates in the userData map.
            // await Get.find<UserProfileService>().updateUserProfile(userId: userId, userData: updateData);
          }
        }
      }
    } catch (e) {
      log('Error syncing token to backend: $e');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            icon: android.smallIcon,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  Future<String?> getFcmToken() async {
    try {
      String? token = await _messaging.getToken();
      log('FCM Token: $token');
      return token;
    } catch (e) {
      log('Error getting FCM token: $e');
      return null;
    }
  }
}
