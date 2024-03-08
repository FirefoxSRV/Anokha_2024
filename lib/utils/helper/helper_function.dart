import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HelperFunctions {
  //keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userTokenKey = "USERTOKENKEY";
  static String otpTokenKey = "OTPTOKENKEY";

  // Instance of FlutterSecureStorage
  static const storage = FlutterSecureStorage();

  //clearing all the stored data
  static Future<void> clearAllData() async {
    await storage.deleteAll();
  }

  // saving the data to SecureStorage

  static Future<void> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    await storage.write(key: userLoggedInKey, value: isUserLoggedIn.toString());
  }

  static Future<void> saveUserNameSF(String userName) async {
    await storage.write(key: userNameKey, value: userName);
  }

  static Future<void> saveUserEmailSF(String userEmail) async {
    await storage.write(key: userEmailKey, value: userEmail);
  }

  static Future<void> saveUserTokenSF(String userToken) async {
    await storage.write(key: userTokenKey, value: userToken);
  }

  static Future<void> saveOTPTokenSF(String otpToken) async {
    await storage.write(key: otpTokenKey, value: otpToken);
  }

  // getting the data from SecureStorage

  static Future<bool?> getUserLoggedInStatus() async {
    String? value = await storage.read(key: userLoggedInKey);
    if (value == null) {
      return null;
    }
    return value.toLowerCase() == 'true';
  }

  static Future<String?> getUserEmailFromSF() async {
    return await storage.read(key: userEmailKey);
  }

  static Future<String?> getUserNameFromFromSF() async {
    return await storage.read(key: userNameKey);
  }

  static Future<String?> getUserTokenKeyFromSF() async {
    return await storage.read(key: userTokenKey);
  }

  static Future<String?> getOTPTokenKeyFromSF() async {
    return await storage.read(key: otpTokenKey);
  }
}

