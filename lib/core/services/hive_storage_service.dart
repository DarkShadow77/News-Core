// lib/core/services/hive_storage_service.dart
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

import '../../featured/auth/data/models/session_model.dart';

class HiveStorageService {
  static const String _sessionBoxName = 'session_box';
  static const String _sessionKey = 'user_session';
  static const String _isLoggedInKey = 'is_logged_in';

  Box? _sessionBox;

  // Initialize Hive boxes
  Future<void> init() async {
    try {
      // Hive.initFlutter() is already called in main.dart
      // Just open the box
      _sessionBox = await Hive.openBox(_sessionBoxName);
    } catch (e) {
      log('Error initializing Hive storage: $e');
      rethrow;
    }
  }

  // Ensure box is open
  Box _ensureBoxOpen() {
    if (_sessionBox == null || !_sessionBox!.isOpen) {
      throw Exception('Hive box is not initialized or is closed');
    }
    return _sessionBox!;
  }

  // Save session
  Future<bool> saveSession(SessionModel session) async {
    try {
      final box = _ensureBoxOpen();
      await box.put(_sessionKey, session.toMap());
      await box.put(_isLoggedInKey, true);
      return true;
    } catch (e) {
      log('Error saving session: $e');
      return false;
    }
  }

  // Get session
  SessionModel? getSession() {
    try {
      final box = _ensureBoxOpen();
      final sessionMap = box.get(_sessionKey);

      if (sessionMap == null) return null;

      return SessionModel.fromMap(Map<String, dynamic>.from(sessionMap));
    } catch (e) {
      log('Error getting session: $e');
      return null;
    }
  }

  // Check if logged in
  bool isLoggedIn() {
    try {
      final box = _ensureBoxOpen();
      return box.get(_isLoggedInKey, defaultValue: false) as bool;
    } catch (e) {
      log('Error checking login status: $e');
      return false;
    }
  }

  // Clear session (logout)
  Future<bool> clearSession() async {
    try {
      final box = _ensureBoxOpen();
      await box.delete(_sessionKey);
      await box.put(_isLoggedInKey, false);
      return true;
    } catch (e) {
      log('Error clearing session: $e');
      return false;
    }
  }

  // Update session
  Future<bool> updateSession(SessionModel session) async {
    return await saveSession(session);
  }

  // Get specific value
  T? getValue<T>(String key, {T? defaultValue}) {
    try {
      final box = _ensureBoxOpen();
      return box.get(key, defaultValue: defaultValue) as T?;
    } catch (e) {
      log('Error getting value for key $key: $e');
      return defaultValue;
    }
  }

  // Set specific value
  Future<void> setValue<T>(String key, T value) async {
    try {
      final box = _ensureBoxOpen();
      await box.put(key, value);
    } catch (e) {
      log('Error setting value for key $key: $e');
    }
  }

  // Delete specific value
  Future<void> deleteValue(String key) async {
    try {
      final box = _ensureBoxOpen();
      await box.delete(key);
    } catch (e) {
      log('Error deleting value for key $key: $e');
    }
  }

  // Clear all data
  Future<void> clearAll() async {
    try {
      final box = _ensureBoxOpen();
      await box.clear();
    } catch (e) {
      log('Error clearing all data: $e');
    }
  }

  // Get all keys
  Iterable<dynamic> getAllKeys() {
    try {
      final box = _ensureBoxOpen();
      return box.keys;
    } catch (e) {
      log('Error getting all keys: $e');
      return [];
    }
  }

  // Check if key exists
  bool containsKey(String key) {
    try {
      final box = _ensureBoxOpen();
      return box.containsKey(key);
    } catch (e) {
      log('Error checking key existence: $e');
      return false;
    }
  }

  // Close box
  Future<void> close() async {
    try {
      if (_sessionBox != null && _sessionBox!.isOpen) {
        await _sessionBox!.close();
      }
    } catch (e) {
      log('Error closing box: $e');
    }
  }
}
