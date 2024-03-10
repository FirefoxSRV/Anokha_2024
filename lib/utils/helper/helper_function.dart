import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userTokenKey = "USERTOKENKEY";
  static String otpTokenKey = "OTPTOKENKEY";

  // saving the data to SecureStorage
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserTokenSF(String userToken) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userTokenKey, userToken);
  }

  static Future<bool> saveOTPTokenSF(String otpToken) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(otpTokenKey, otpToken);
  }

  // getting the data from SecureStorage

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getUserTokenKeyFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userTokenKey);
  }

  static Future<String?> getOTPTokenKeyFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(otpTokenKey);
  }
}
