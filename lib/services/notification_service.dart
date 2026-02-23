import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_book/constants/api.dart';
import 'package:recipe_book/pages/recipe_detail_page.dart';
import 'package:recipe_book/services/recipe_service.dart';

/// Handles FCM setup: permission, token, and message handlers.
/// Call [initialize] from main() after Firebase.init.
class NotificationService {
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Global navigator key used to open screens from notification taps.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Android default channel ID (must match res/values/strings.xml and FCM payload).
  static const String androidChannelId = 'recipe_book_default';

  /// Call once after [Firebase.initializeApp].
  static Future<void> initialize() async {
    await instance._init();
  }

  Future<void> _init() async {
    await _requestPermission();
    await _initLocalNotifications();
    await _setAndroidChannel();
    _listenTokenRefresh();
    _setMessageHandlers();
    await _sendTokenToServerIfNeeded();
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    log('Notification permission: ${settings.authorizationStatus}');
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final recipeId = data['recipe_id'];
      final id = recipeId is int
          ? recipeId
          : int.tryParse(recipeId?.toString() ?? '');
      if (id != null) _openRecipeById(id);
    } catch (_) {}
  }

  Future<void> _setAndroidChannel() async {
    if (!Platform.isAndroid) return;
    final channel = AndroidNotificationChannel(
      androidChannelId,
      'Recipe Book',
      description: 'New recipe and other updates',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) {
      log('FCM token refreshed');
      _sendTokenToServer(newToken);
    });
  }

  void _setMessageHandlers() {
    // Foreground: show in-app or ignore (notification won’t show automatically)
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // User tapped notification while app was in background
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // App opened from terminated state via notification tap
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) _handleNotificationTap(message);
    });
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    log('Foreground message: ${message.notification?.title}');
    final title = message.notification?.title ?? 'New recipe';
    final body = message.notification?.body ?? 'Tap to view';
    final recipeId = message.data['recipe_id']?.toString();
    final payload = recipeId != null ? jsonEncode({'recipe_id': recipeId}) : null;

    const androidDetails = AndroidNotificationDetails(
      androidChannelId,
      'Recipe Book',
      channelDescription: 'New recipe and other updates',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final id = (message.hashCode & 0x7FFFFFFF);
    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    _handleNotificationTap(message);
  }

  Future<void> _handleNotificationTap(RemoteMessage message) async {
    final data = message.data;
    // Expecting backend to send recipe_id in data payload.
    final recipeIdRaw = data['recipe_id'];
    final recipeId =
        recipeIdRaw != null ? int.tryParse(recipeIdRaw.toString()) : null;

    if (recipeId != null) {
      await _openRecipeById(recipeId);
    } else {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    final nav = navigatorKey.currentState;
    nav?.pushNamedAndRemoveUntil('/home', (route) => false);
  }

  Future<void> _openRecipeById(int id) async {
    final nav = navigatorKey.currentState;
    if (nav == null) {
      _navigateToHome();
      return;
    }

    try {
      final recipe = await RecipeService.fetchRecipeById(id);
      nav.push(MaterialPageRoute(
        builder: (_) => RecipeDetailPage(recipe: recipe),
      ));
    } catch (e, st) {
      log('Failed to open recipe from notification: $e');
      log('$st');
      _navigateToHome();
    }
  }

  /// Get current FCM token (for debugging or manual send to server).
  Future<String?> getToken() async {
    try {
      if (Platform.isIOS) {
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) return null;
      }
      return await _messaging.getToken();
    } catch (e) {
      log('FCM getToken error: $e');
      return null;
    }
  }

  /// Send FCM token to your backend so it can target this device.
  Future<void> _sendTokenToServerIfNeeded() async {
    final token = await getToken();
    if (token != null) {
      log('FCM token (copy for Firebase Console → Send test message): $token');
      _sendTokenToServer(token);
    }
  }

  Future<void> _sendTokenToServer(String token) async {
    final url = ApiEndpoints.registerFcmToken;
    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: _encodeTokenPayload(token),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        log('FCM token sent to server');
      } else {
        log('FCM token server error: ${res.statusCode}');
      }
    } catch (e) {
      log('FCM token send error: $e');
    }
  }

  String _encodeTokenPayload(String token) {
    return '{"fcm_token":"$token"}';
  }
}

