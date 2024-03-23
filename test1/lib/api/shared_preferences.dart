import 'package:shared_preferences/shared_preferences.dart';

class NotificationHelper {
  static late SharedPreferences _prefs;

  static Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static List<String> getSeenNotifications() {
    return _prefs.getStringList('seenNotifications') ?? [];
  }

  static void markAsSeen(String notificationId) {
    List<String> seenNotifications = getSeenNotifications();
    seenNotifications.add(notificationId);
    _prefs.setStringList('seenNotifications', seenNotifications);
  }

  static bool isNotificationSeen(String notificationId) {
    List<String> seenNotifications = getSeenNotifications();
    return seenNotifications.contains(notificationId);
  }

  // Lưu trạng thái thông báo chưa đọc vào SharedPreferences
  static Future<int?> getUnreadNotificationCount() async {
    return _prefs.getInt('unreadNotifications');
  }

  // Lưu trạng thái thông báo chưa đọc vào SharedPreferences
  static Future<void> saveUnreadNotificationCount(int count) async {
    await _prefs.setInt('unreadNotifications', count);
  }
  static Future<void> resetUnreadNotificationCount() async {
    await _prefs.setInt('unreadNotifications', 0);
  }

}