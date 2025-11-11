abstract class Endpoints {
  static const base = "https://faithmood.up.railway.app/api/";
  // static const base = "http://localhost:4221/api/";
  // static const base = "https://864ed657db97.ngrok-free.app/api/";

  static const settings = 'settings';
  static const plans = 'settings/plans';

  static const auth = 'auth';
  static const register = '$auth/register';
  static const login = '$auth/login';
  static const refreshToken = '$auth/refresh-token';
  static const changePassword = '$auth/change-password';
  static const sendOtp = '$auth/send-otp';
  static const verifyOtp = '$auth/verify-otp';
  static const syncSubscription = 'subscription/sync';

  static const user = 'user';

  static const dreams = 'dreams';
}
