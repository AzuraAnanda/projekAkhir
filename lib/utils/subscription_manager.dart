import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionManager {
  static const String _subscriptionKey = 'isSubscribed';

  // Cek apakah pengguna sudah berlangganan
  static Future<bool> isSubscribed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_subscriptionKey) ?? false;
  }

  // Set status berlangganan
  static Future<void> setSubscription(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_subscriptionKey, status);
  }
}
