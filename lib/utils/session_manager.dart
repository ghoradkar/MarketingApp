import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _isLoggedInKey = 'isLoggedIn';
  static const _isKeepSigned = 'isKeepSigned';
  static String routeDateKey = 'start_route_date';
  static String routeResetKey = 'start_route_reset';


  Future<void> setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> setKeepSignedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isKeepSigned, isLoggedIn);
  }

  Future<bool> getKeepSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isKeepSigned) ?? false;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<void> markStartRouteTapped() async {
    final prefs = await SharedPreferences.getInstance();
    final todayStr = _formattedToday();
    await prefs.setString(routeDateKey, todayStr);
    await prefs.setBool(routeResetKey, false);
  }

  static Future<void> resetStartRouteByLab() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(routeResetKey, true);
  }

  static Future<int> shouldShowStartRouteButton() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString(routeDateKey);
    final isReset = prefs.getBool(routeResetKey) ?? false;
    final todayStr = _formattedToday();

    print("[RouteCheck] savedDate=$savedDate, reset=$isReset, today=$todayStr");

    if (isReset) return 1;
    if (savedDate == null || savedDate != todayStr) return 1;
    return 0;
  }

  static String _formattedToday() {
    final today = DateTime.now();
    return '${today.year}-${today.month}-${today.day}';
  }
}