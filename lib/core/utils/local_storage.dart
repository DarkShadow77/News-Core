import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/strings.dart';

class LocalStorageHelper {
  LocalStorageHelper._internal();

  static final LocalStorageHelper _instance = LocalStorageHelper._internal();

  factory LocalStorageHelper() => _instance;

  static final _secureStorage = FlutterSecureStorage();
  static final _systemPrefs = Hive.box(HiveStrings.box1);
  static final _myPrefs = Hive.box(Strings.appName);

  //Store Api Key
  void setApiKey({required String apiKey}) {
    _secureStorage.write(key: "apiKey", value: apiKey);
  }

  //Retrieve Api Key
  Future<String?> getApiKey() {
    return _secureStorage.read(key: "apiKey");
  }

  //Store Access Token
  void setAccessToken({required String accessToken}) {
    _secureStorage.write(key: "accessToken", value: accessToken);
  }

  //Retrieve Access Token
  Future<String?> getAccessToken() {
    return _secureStorage.read(key: "accessToken");
  }

  //Store Refresh Token
  void setRefreshToken({required String refreshToken}) {
    _secureStorage.write(key: "refreshToken", value: refreshToken);
  }

  //Retrieve Refresh Token
  Future<String?> getRefreshToken() {
    return _secureStorage.read(key: "refreshToken");
  }

  //Store App Theme in System Hive
  void setDarkMode(bool darkMode) {
    _systemPrefs.put("isDarkMode", darkMode);
  }

  //Retrieve App Theme in System Hive
  bool getDarkMode() {
    return _systemPrefs.get("isDarkMode", defaultValue: false);
  }

  //Store the result when checked if it's the User's first time running the app in System Hive
  void setIsFirstRun(bool isFirstRun) {
    _systemPrefs.put("isFirstRun", isFirstRun);
  }

  //Retrieve the result when checked if it's the User's first time running the app in System Hive
  bool getIsFirstRun() {
    return _systemPrefs.get("isFirstRun", defaultValue: false);
  }
}
