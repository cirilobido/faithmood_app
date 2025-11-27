abstract class Endpoints {
  // static const base = "https://selah.up.railway.app/api/"; // Production server
  // static const base = "http://localhost:4221/api/"; // For local backend - works on iOS Simulator and desktop
  static const base = "http://192.168.100.41:4221/api/"; // For Android Emulator (10.0.2.2 points to host machine)
  // static const base = "http://192.168.x.x:4221/api/"; // For physical device - replace x.x with your computer's local IP
  // static const base = "https://864ed657db97.ngrok-free.app/api/"; // For mobile testing with local backend via ngrok

  static const settings = 'settings';
  static const plans = 'settings/plans';

  static const auth = 'auth';
  static const register = '$auth/register';
  static const login = '$auth/login';
  static const refreshToken = '$auth/refresh-t';
  static const changePassword = '$auth/change-password';
  static const sendOtp = '$auth/send-otp';
  static const verifyOtp = '$auth/verify-otp';
  static const syncSubscription = 'subscription/sync';

  static const user = 'user';
  static String saveDevotionalLog(int userId) => '$user/devotional/logs/$userId';

  static const dreams = 'dreams';

  static const verse = 'verse';
  static String dailyVerse(String lang) => '$verse/daily?lang=$lang';

  static const devotional = 'devotional';
  static String dailyDevotional(String lang) => '$devotional/today?lang=$lang';
  static String getDevotionalById(int id, String lang) => '$devotional/$id?lang=$lang';
  static String devotionalsByCategory(int categoryId, String lang, {int? page, int? limit}) {
    final queryParams = <String>['lang=$lang'];
    if (page != null) queryParams.add('page=$page');
    if (limit != null) queryParams.add('limit=$limit');
    return '$devotional/category/$categoryId?${queryParams.join('&')}';
  }
  static String getAllDevotionals(String lang, {int? page, int? limit, int? categoryId, String? tags}) {
    final queryParams = <String>['lang=$lang'];
    if (page != null) queryParams.add('page=$page');
    if (limit != null) queryParams.add('limit=$limit');
    if (categoryId != null) queryParams.add('categoryId=$categoryId');
    if (tags != null && tags.isNotEmpty) queryParams.add('tags=$tags');
    return '$devotional/all?${queryParams.join('&')}';
  }
  
  static const categories = 'categories';
  static String getCategories(String lang) => '$categories/?lang=$lang';
  
  static const tags = 'tags';
  static String getTags(String lang) => '$tags?lang=$lang';
  static String devotionalsByTag(int tagId, String lang, {int? page, int? limit}) {
    final queryParams = <String>['lang=$lang'];
    if (page != null) queryParams.add('page=$page');
    if (limit != null) queryParams.add('limit=$limit');
    return '$tags/$tagId/devotionals?${queryParams.join('&')}';
  }
  
  static const mood = 'mood';
  static String getMoods(String lang) => '$mood?lang=$lang';
  static String createMoodSession(int userId) => '$user/mood/session/$userId';
  static String getMoodSessions(int userId, {Map<String, dynamic>? queryParams}) {
    final baseUrl = '$user/mood/session/$userId';
    if (queryParams == null || queryParams.isEmpty) {
      return baseUrl;
    }
    final queryString = queryParams.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
    return queryString.isNotEmpty ? '$baseUrl?$queryString' : baseUrl;
  }
  static String getMoodSessionDetail(int userId, String sessionId, String lang) {
    return '$user/mood/session/details/$userId/$sessionId?lang=$lang';
  }
  static String deleteMoodSession(int userId, String sessionId) {
    return '$user/mood/session/$userId/$sessionId';
  }
  static String updateMoodSession(int userId, String sessionId) {
    return '$user/mood/session/$userId/$sessionId';
  }
  static String getDevotionalLogs(int userId, {Map<String, dynamic>? queryParams}) {
    final baseUrl = '$user/devotional/logs/$userId';
    if (queryParams == null || queryParams.isEmpty) {
      return baseUrl;
    }
    final queryString = queryParams.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
    return queryString.isNotEmpty ? '$baseUrl?$queryString' : baseUrl;
  }
  static String getDevotionalLogDetail(int userId, int id, String lang) {
    return '$user/devotional/logs/details/$userId/$id?lang=$lang';
  }
  static String updateDevotionalLog(int userId, int id) {
    return '$user/devotional/logs/$userId/$id';
  }
  static String deleteDevotionalLog(int userId, int id) {
    return '$user/devotional/logs/$userId/$id';
  }
  
  static String getUserAnalytics(int userId, String startDate, String endDate) {
    return '$user/analytics/$userId?startDate=$startDate&endDate=$endDate';
  }
}
