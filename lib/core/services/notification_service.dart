import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int _badgeCount = 0;
  bool _isInitialized = false;
  bool _badgeSupported = false;
  static const String _badgeCountKey = 'badge_count';
  static const int _badgeSummaryNotificationId = 999999;

  // Getters
  int get badgeCount => _badgeCount;
  bool get isInitialized => _isInitialized;
  bool get isBadgeSupported => _badgeSupported;

  /// Initialize notification service
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Load saved badge count
      await _loadBadgeCount();

      // Check badge support
      await _checkBadgeSupport();

      // Android initialization
      const androidInit = AndroidInitializationSettings('ic_notification');

      // iOS/macOS initialization
      const darwinInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        requestCriticalPermission: false,
        requestProvisionalPermission: false,
      );

      final initSettings = InitializationSettings(
        android: androidInit,
        iOS: darwinInit,
        macOS: darwinInit,
      );

      // Initialize with callback
      await _flutterLocalNotificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      // Create notification channels for Android
      await _createNotificationChannels();

      // Setup FCM
      await _setupFCM();

      // Restore badge if count exists
      if (_badgeCount > 0) {
        await _updateAppBadge();
      }

      _isInitialized = true;
      debugPrint('✅ NotificationService initialized');
      debugPrint('   Badge count: $_badgeCount');
      debugPrint('   Badge supported: $_badgeSupported');
      debugPrint('   ${getBadgeSupportInfo()}');
    } catch (e) {
      debugPrint('❌ Error initializing NotificationService: $e');
      rethrow;
    }
  }

  /// Setup Firebase Cloud Messaging
  Future<void> _setupFCM() async {
    try {
      final messaging = FirebaseMessaging.instance;

      // Request permissions (especially for iOS)
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint(
        'User granted FCM permission: ${settings.authorizationStatus}',
      );

      // Get token
      String? token = await messaging.getToken();
      debugPrint('FCM Token: $token');

      // Listen for token refresh
      messaging.onTokenRefresh.listen((newToken) {
        debugPrint('FCM Token Refreshed: $newToken');
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        debugPrint('Message data: ${message.data}');

        if (message.notification != null) {
          debugPrint(
            'Message also contained a notification: ${message.notification?.title}',
          );
          showNotification(
            id: message.hashCode,
            title: message.notification?.title ?? 'Notification',
            body: message.notification?.body ?? '',
            payload: message.data.toString(),
          );
        }
      });

      // Handle message tap when app is in background but not terminated
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('Notification tapped while in background: ${message.data}');
        // You can navigate to a specific screen here if needed
      });

      // Check if app was opened from a terminated state via notification
      RemoteMessage? initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        debugPrint(
          'App opened from terminated state via notification: ${initialMessage.data}',
        );
      }

      // Background message handler registration
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
    } catch (e) {
      debugPrint('Error setting up FCM: $e');
    }
  }

  /// Check if badge is supported on this device
  Future<void> _checkBadgeSupport() async {
    try {
      if (Platform.isIOS || Platform.isMacOS) {
        _badgeSupported = true;
      } else if (Platform.isAndroid) {
        _badgeSupported = await AppBadgePlus.isSupported();
        debugPrint('Android badge support check: $_badgeSupported');
      } else {
        _badgeSupported = false;
      }
    } catch (e) {
      debugPrint('Error checking badge support: $e');
      _badgeSupported = false;
    }
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    if (!Platform.isAndroid) return;

    final androidImplementation =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      // High priority channel
      const highImportanceChannel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'Channel for high priority notifications',
        importance: Importance.high,
        enableVibration: true,
        enableLights: true,
        showBadge: true,
      );

      // Default channel
      const defaultChannel = AndroidNotificationChannel(
        'default_channel',
        'Default Notifications',
        description: 'Channel for general notifications',
        importance: Importance.defaultImportance,
        showBadge: true,
      );

      // Badge counter channel (minimal visibility)
      const badgeChannel = AndroidNotificationChannel(
        'badge_channel',
        'Badge Counter',
        description: 'Manages notification badge count',
        importance: Importance.min,
        showBadge: true,
      );

      await androidImplementation.createNotificationChannel(
        highImportanceChannel,
      );
      await androidImplementation.createNotificationChannel(defaultChannel);
      await androidImplementation.createNotificationChannel(badgeChannel);

      debugPrint('Notification channels created');
    }
  }

  /// Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');

    // Don't decrement for badge summary notification
    if (response.id != _badgeSummaryNotificationId) {
      decrementBadge();
    }
  }

  /// Load badge count from persistent storage
  Future<void> _loadBadgeCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _badgeCount = prefs.getInt(_badgeCountKey) ?? 0;
      debugPrint('Loaded badge count: $_badgeCount');
    } catch (e) {
      debugPrint('Error loading badge count: $e');
      _badgeCount = 0;
    }
  }

  /// Save badge count to persistent storage
  Future<void> _saveBadgeCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_badgeCountKey, _badgeCount);
    } catch (e) {
      debugPrint('Error saving badge count: $e');
    }
  }

  /// Update app icon badge
  Future<void> _updateAppBadge() async {
    try {
      if (Platform.isAndroid) {
        await _updateAndroidBadge();
      } else if (Platform.isIOS || Platform.isMacOS) {
        await _updateIOSBadge();
      }
    } catch (e) {
      debugPrint('Error updating app badge: $e');
    }
  }

  /// Update badge on Android
  Future<void> _updateAndroidBadge() async {
    if (!_badgeSupported) {
      debugPrint('⚠️  Badge not supported on this Android launcher');
      return;
    }

    try {
      if (_badgeCount > 0) {
        // Update badge number
        await AppBadgePlus.updateBadge(_badgeCount);

        // Create a minimal persistent notification to support the badge
        // This helps with launchers that need an active notification
        const androidDetails = AndroidNotificationDetails(
          color: Color(0xFFFFFFFF),
          'badge_channel',
          'Badge Counter',
          channelDescription: 'Manages notification badge count',
          importance: Importance.min,
          priority: Priority.min,
          ongoing: false,
          autoCancel: false,
          showWhen: false,
          onlyAlertOnce: true,
          visibility: NotificationVisibility.secret,
          largeIcon: DrawableResourceAndroidBitmap('android12splash'),
        );

        const details = NotificationDetails(android: androidDetails);

        await _flutterLocalNotificationsPlugin.show(
          id: _badgeSummaryNotificationId,
          title: 'Notifications',
          body:
              'You have $_badgeCount unread notification${_badgeCount == 1 ? '' : 's'}',
          notificationDetails: details,
        );

        debugPrint('✅ Android badge updated to: $_badgeCount');
      } else {
        // Remove badge
        await AppBadgePlus.updateBadge(0);
        await _flutterLocalNotificationsPlugin.cancel(
          id: _badgeSummaryNotificationId,
        );
        debugPrint('✅ Android badge cleared');
      }
    } catch (e) {
      debugPrint('❌ Error updating Android badge: $e');
    }
  }

  /// Update badge on iOS/macOS
  Future<void> _updateIOSBadge() async {
    try {
      await AppBadgePlus.updateBadge(_badgeCount);
      debugPrint('✅ iOS/macOS badge updated to: $_badgeCount');
    } catch (e) {
      debugPrint('❌ Error updating iOS/macOS badge: $e');
    }
  }

  /// Check notification permissions
  Future<bool> areNotificationsEnabled() async {
    try {
      if (Platform.isAndroid) {
        final androidImplementation = _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        return await androidImplementation?.areNotificationsEnabled() ?? false;
      }
      return true; // iOS handles permissions differently
    } catch (e) {
      debugPrint('Error checking notification permissions: $e');
      return false;
    }
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    try {
      if (Platform.isIOS || Platform.isMacOS) {
        final iosImplementation = _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();

        final result = await iosImplementation?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

        debugPrint('iOS permissions granted: $result');
        return result ?? false;
      } else if (Platform.isAndroid) {
        final androidImplementation = _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

        final result =
            await androidImplementation?.requestNotificationsPermission();
        debugPrint('Android permissions granted: $result');
        return result ?? false;
      }
      return false;
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return false;
    }
  }

  /// Show notification with badge update
  Future<bool> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool updateBadge = true,
    NotificationPriority priority = NotificationPriority.high,
  }) async {
    if (!_isInitialized) {
      debugPrint('❌ NotificationService not initialized. Call init() first.');
      return false;
    }

    try {
      // Increment badge count if requested
      if (updateBadge) {
        _badgeCount++;
        await _saveBadgeCount();
      }

      // Determine channel and importance based on priority
      String channelId = 'default_channel';
      Importance importance = Importance.defaultImportance;
      Priority androidPriority = Priority.defaultPriority;
      InterruptionLevel iosInterruptionLevel = InterruptionLevel.active;

      if (priority == NotificationPriority.high) {
        channelId = 'high_importance_channel';
        importance = Importance.high;
        androidPriority = Priority.high;
        iosInterruptionLevel = InterruptionLevel.timeSensitive;
      }

      // Android notification details
      final androidDetails = AndroidNotificationDetails(
        channelId,
        priority == NotificationPriority.high
            ? 'High Importance Notifications'
            : 'Default Notifications',
        channelDescription: priority == NotificationPriority.high
            ? 'Channel for high priority notifications'
            : 'Channel for general notifications',
        importance: importance,
        priority: androidPriority,
        icon: 'ic_notification',
        showWhen: true,
        enableVibration: priority == NotificationPriority.high,
        playSound: true,
      );

      // iOS/macOS notification details
      final darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: _badgeCount,
        threadIdentifier: channelId,
        interruptionLevel: iosInterruptionLevel,
      );

      final platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      // Show the notification
      await _flutterLocalNotificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: platformDetails,
        payload: payload,
      );

      // Update app icon badge
      if (updateBadge) {
        await _updateAppBadge();
      }

      debugPrint('✅ Notification shown: "$title"');
      debugPrint('   Badge count: $_badgeCount');
      return true;
    } catch (e) {
      debugPrint('❌ Error showing notification: $e');

      // Revert badge count if notification failed
      if (updateBadge && _badgeCount > 0) {
        _badgeCount--;
        await _saveBadgeCount();
      }
      return false;
    }
  }

  /// Reset badge count to zero
  Future<void> resetBadge() async {
    try {
      _badgeCount = 0;
      await _saveBadgeCount();
      await _updateAppBadge();
      debugPrint('✅ Badge count reset to 0');
    } catch (e) {
      debugPrint('❌ Error resetting badge: $e');
    }
  }

  /// Decrement badge count by one
  Future<void> decrementBadge() async {
    if (_badgeCount > 0) {
      try {
        _badgeCount--;
        await _saveBadgeCount();
        await _updateAppBadge();
        debugPrint('✅ Badge count decremented to: $_badgeCount');
      } catch (e) {
        debugPrint('❌ Error decrementing badge: $e');
      }
    } else {
      debugPrint('⚠️  Badge count already at 0');
    }
  }

  /// Increment badge count by one
  Future<void> incrementBadge() async {
    try {
      _badgeCount++;
      await _saveBadgeCount();
      await _updateAppBadge();
      debugPrint('✅ Badge count incremented to: $_badgeCount');
    } catch (e) {
      debugPrint('❌ Error incrementing badge: $e');
    }
  }

  /// Set badge count to specific value
  Future<void> setBadgeCount(int count) async {
    if (count < 0) {
      debugPrint('⚠️  Badge count cannot be negative, setting to 0');
      count = 0;
    }

    try {
      _badgeCount = count;
      await _saveBadgeCount();
      await _updateAppBadge();
      debugPrint('✅ Badge count set to: $count');
    } catch (e) {
      debugPrint('❌ Error setting badge count: $e');
    }
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      debugPrint('✅ All notifications cleared');
    } catch (e) {
      debugPrint('❌ Error clearing all notifications: $e');
    }
  }

  /// Cancel specific notification
  Future<void> cancelNotification(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id: id);
      debugPrint('✅ Notification $id cancelled');
    } catch (e) {
      debugPrint('❌ Error cancelling notification: $e');
    }
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _flutterLocalNotificationsPlugin
          .pendingNotificationRequests();
    } catch (e) {
      debugPrint('❌ Error getting pending notifications: $e');
      return [];
    }
  }

  /// Get active notifications (Android only)
  Future<List<ActiveNotification>> getActiveNotifications() async {
    if (!Platform.isAndroid) return [];

    try {
      final androidImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      return await androidImplementation?.getActiveNotifications() ?? [];
    } catch (e) {
      debugPrint('❌ Error getting active notifications: $e');
      return [];
    }
  }

  /// Get platform-specific badge support information
  String getBadgeSupportInfo() {
    if (Platform.isIOS || Platform.isMacOS) {
      return 'Badge fully supported on iOS/macOS';
    } else if (Platform.isAndroid) {
      return _badgeSupported
          ? 'Badge supported on this Android launcher'
          : 'Badge not supported (Pixel, Nova, and many stock launchers don\'t support badges)';
    } else {
      return 'Badge not supported on this platform';
    }
  }

  /// Test badge functionality
  Future<void> testBadge() async {
    debugPrint('🧪 Testing badge functionality...');
    debugPrint('   Platform: ${Platform.operatingSystem}');
    debugPrint('   Badge supported: $_badgeSupported');
    debugPrint('   Current badge count: $_badgeCount');

    try {
      // Test setting badge to 5
      await setBadgeCount(5);
      await Future.delayed(const Duration(seconds: 2));

      // Test clearing badge
      await resetBadge();

      debugPrint('✅ Badge test completed');
    } catch (e) {
      debugPrint('❌ Badge test failed: $e');
    }
  }

  /// Dispose service
  void dispose() {
    _isInitialized = false;
    debugPrint('NotificationService disposed');
  }
}

/// Notification priority enum
enum NotificationPriority { high, normal }
