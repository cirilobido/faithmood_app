import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../dev_utils/dev_utils_exports.dart';
import '../core_exports.dart';

class LocalNotificationsService {
  // Singleton
  LocalNotificationsService._internal();

  static final LocalNotificationsService _instance =
      LocalNotificationsService._internal();

  factory LocalNotificationsService.instance() => _instance;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Canal de notificación Android
  final _androidChannel = const AndroidNotificationChannel(
    'daily_channel_id',
    'Daily Reminders',
    description: 'Channel for daily reminders',
    importance: Importance.max,
  );

  bool _initialized = false;

  /// Inicializa plugin y timezone
  Future<void> init() async {
    if (_initialized) return;

    // Inicializar timezone
    tz.initializeTimeZones();
    final TimezoneInfo timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName.identifier));
    devLogger('Local timezone: $timeZoneName');

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        devLogger('Notification tapped: ${response.payload}');
      },
    );

    // Crear canal Android
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    _initialized = true;
  }

  /// Mostrar notificación inmediata (debug/test)
  Future<void> showNotification({
    String? title,
    String? body,
    String? payload,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Programar notificación diaria
  /// Programar notificación diaria
  Future<void> scheduleDailyNotification({
    required int hour,
    required int minute,
    String title = 'Dream time 🌙',
    String body = 'Write your dreams before they fade away.',
    String? payload,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    // Si la hora ya pasó hoy, se programa para mañana
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      1001,
      title,
      body,
      scheduled,
      details,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );

    // Guardar hora en secure storage
    await _secureStorage.write(key: Constant.dailyNotificationHourKey, value: hour.toString());
    await _secureStorage.write(key: Constant.dailyNotificationMinuteKey, value: minute.toString());

    devLogger('Daily notification scheduled at $hour:$minute (scheduled: $scheduled)');
  }


  /// Cancelar notificación diaria
  Future<void> cancelDailyNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(1001);
    await _secureStorage.delete(key: Constant.dailyNotificationHourKey);
    await _secureStorage.delete(key: Constant.dailyNotificationMinuteKey);
  }

  /// Restaurar notificación diaria desde storage
  Future<void> restoreDailyNotification() async {
    final hourStr = await _secureStorage.read(
      key: Constant.dailyNotificationHourKey,
    );
    final minuteStr = await _secureStorage.read(
      key: Constant.dailyNotificationMinuteKey,
    );

    if (hourStr != null && minuteStr != null) {
      final hour = int.parse(hourStr);
      final minute = int.parse(minuteStr);

      await scheduleDailyNotification(hour: hour, minute: minute);

      devLogger('Daily notification restored at $hour:$minute');
    }
  }
}
