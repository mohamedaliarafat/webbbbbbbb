import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final Logger _logger = Logger();
  SharedPreferences? _prefs;

  // Initialize storage service
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _logger.i('✅ Storage service initialized');
    } catch (e) {
      _logger.e('❌ Failed to initialize storage service: $e');
      rethrow;
    }
  }

  // Check if storage is ready
  bool get isReady => _prefs != null;

  // String operations
  Future<bool> setString(String key, String value) async {
    try {
      if (!isReady) await init();
      final result = await _prefs!.setString(key, value);
      _logger.d('💾 Saved string: $key = $value');
      return result;
    } catch (e) {
      _logger.e('❌ Failed to save string: $key - $e');
      return false;
    }
  }

  String? getString(String key) {
    try {
      if (!isReady) return null;
      final value = _prefs!.getString(key);
      _logger.d('📖 Retrieved string: $key = $value');
      return value;
    } catch (e) {
      _logger.e('❌ Failed to get string: $key - $e');
      return null;
    }
  }

  Future<String?> getStringAsync(String key) async {
    try {
      if (!isReady) await init();
      final value = _prefs!.getString(key);
      _logger.d('📖 Retrieved string async: $key = $value');
      return value;
    } catch (e) {
      _logger.e('❌ Failed to get string async: $key - $e');
      return null;
    }
  }

  // Int operations
  Future<bool> setInt(String key, int value) async {
    try {
      if (!isReady) await init();
      final result = await _prefs!.setInt(key, value);
      _logger.d('💾 Saved int: $key = $value');
      return result;
    } catch (e) {
      _logger.e('❌ Failed to save int: $key - $e');
      return false;
    }
  }

  int? getInt(String key) {
    try {
      if (!isReady) return null;
      final value = _prefs!.getInt(key);
      _logger.d('📖 Retrieved int: $key = $value');
      return value;
    } catch (e) {
      _logger.e('❌ Failed to get int: $key - $e');
      return null;
    }
  }

  Future<int?> getIntAsync(String key) async {
    try {
      if (!isReady) await init();
      final value = _prefs!.getInt(key);
      _logger.d('📖 Retrieved int async: $key = $value');
      return value;
    } catch (e) {
      _logger.e('❌ Failed to get int async: $key - $e');
      return null;
    }
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    try {
      if (!isReady) await init();
      final result = await _prefs!.setDouble(key, value);
      _logger.d('💾 Saved double: $key = $value');
      return result;
    } catch (e) {
      _logger.e('❌ Failed to save double: $key - $e');
      return false;
    }
  }

  double? getDouble(String key) {
    try {
      if (!isReady) return null;
      final value = _prefs!.getDouble(key);
      _logger.d('📖 Retrieved double: $key = $value');
      return value;
    } catch (e) {
      _logger.e('❌ Failed to get double: $key - $e');
      return null;
    }
  }

  Future<double?> getDoubleAsync(String key) async {
    try {
      if (!isReady) await init();
      final value = _prefs!.getDouble(key);
      _logger.d('📖 Retrieved double async: $key = $value');
      return value;
    } catch (e) {
      _logger.e('❌ Failed to get double async: $key - $e');
      return null;
    }
  }

  // Bool operations
  Future<bool> setBool(String key, bool value) async {
    try {
      if (!isReady) await init();
      final result = await _prefs!.setBool(key, value);
      _logger.d('💾 Saved bool: $key = $value');
      return result;
    } catch (e) {
      _logger.e('❌ Failed to save bool: $key - $e');
      return false;
    }
  }

  bool? getBool(String key) {
    try {
      if (!isReady) return null;
      final value = _prefs!.getBool(key);
      _logger.d('📖 Retrieved bool: $key = $value');
      return value;
    } catch (e) {
      _logger.e('❌ Failed to get bool: $key - $e');
      return null;
    }
  }

  Future<bool?> getBoolAsync(String key) async {
    try {
      if (!isReady) await init();
      final value = _prefs!.getBool(key);
      _logger.d('📖 Retrieved bool async: $key = $value');
      return value;
    } catch (e) {
      _logger.e('❌ Failed to get bool async: $key - $e');
      return null;
    }
  }

  // List operations
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      if (!isReady) await init();
      final result = await _prefs!.setStringList(key, value);
      _logger.d('💾 Saved string list: $key = $value');
      return result;
    } catch (e) {
      _logger.e('❌ Failed to save string list: $key - $e');
      return false;
    }
  }

  List<String>? getStringList(String key) {
    try {
      if (!isReady) return null;
      final value = _prefs!.getStringList(key);
      _logger.d('📖 Retrieved string list: $key = $value');
      return value;
    } catch (e) {
      _logger.e('❌ Failed to get string list: $key - $e');
      return null;
    }
  }

  Future<List<String>?> getStringListAsync(String key) async {
    try {
      if (!isReady) await init();
      final value = _prefs!.getStringList(key);
      _logger.d('📖 Retrieved string list async: $key = $value');
      return value;
    } catch (e) {
      _logger.e('❌ Failed to get string list async: $key - $e');
      return null;
    }
  }

  // Remove key
  Future<bool> remove(String key) async {
    try {
      if (!isReady) await init();
      final result = await _prefs!.remove(key);
      _logger.d('🗑️ Removed key: $key');
      return result;
    } catch (e) {
      _logger.e('❌ Failed to remove key: $key - $e');
      return false;
    }
  }

  // Check if key exists
  Future<bool> containsKey(String key) async {
    try {
      if (!isReady) await init();
      final result = _prefs!.containsKey(key);
      _logger.d('🔍 Checked key existence: $key = $result');
      return result;
    } catch (e) {
      _logger.e('❌ Failed to check key existence: $key - $e');
      return false;
    }
  }

  // Get all keys
  Future<Set<String>> getKeys() async {
    try {
      if (!isReady) await init();
      final keys = _prefs!.getKeys();
      _logger.d('🔑 Retrieved all keys: $keys');
      return keys;
    } catch (e) {
      _logger.e('❌ Failed to get keys: $e');
      return {};
    }
  }

  // Clear all data
  Future<bool> clear() async {
    try {
      if (!isReady) await init();
      final result = await _prefs!.clear();
      _logger.i('🧹 Cleared all storage data');
      return result;
    } catch (e) {
      _logger.e('❌ Failed to clear storage: $e');
      return false;
    }
  }

  // Remove multiple keys
  Future<void> removeMultiple(List<String> keys) async {
    try {
      if (!isReady) await init();
      for (String key in keys) {
        await _prefs!.remove(key);
      }
      _logger.d('🗑️ Removed multiple keys: $keys');
    } catch (e) {
      _logger.e('❌ Failed to remove multiple keys: $e');
    }
  }

  // Save object as JSON
  Future<bool> setObject(String key, Map<String, dynamic> object) async {
    try {
      final jsonString = json.encode(object);
      return await setString(key, jsonString);
    } catch (e) {
      _logger.e('❌ Failed to save object: $key - $e');
      return false;
    }
  }

  // Get object from JSON
  Map<String, dynamic>? getObject(String key) {
    try {
      final jsonString = getString(key);
      if (jsonString != null) {
        return json.decode(jsonString);
      }
      return null;
    } catch (e) {
      _logger.e('❌ Failed to get object: $key - $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getObjectAsync(String key) async {
    try {
      final jsonString = await getStringAsync(key);
      if (jsonString != null) {
        return json.decode(jsonString);
      }
      return null;
    } catch (e) {
      _logger.e('❌ Failed to get object async: $key - $e');
      return null;
    }
  }

  // Backup and restore methods (for future use)
  Future<Map<String, dynamic>> backupData() async {
    try {
      final keys = await getKeys();
      final backup = <String, dynamic>{};

      for (String key in keys) {
        final value = _prefs!.get(key);
        backup[key] = value;
      }

      _logger.i('💾 Backup created with ${backup.length} items');
      return backup;
    } catch (e) {
      _logger.e('❌ Backup failed: $e');
      return {};
    }
  }

  Future<bool> restoreData(Map<String, dynamic> backup) async {
    try {
      for (var entry in backup.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String) {
          await setString(key, value);
        } else if (value is int) {
          await setInt(key, value);
        } else if (value is double) {
          await setDouble(key, value);
        } else if (value is bool) {
          await setBool(key, value);
        } else if (value is List<String>) {
          await setStringList(key, value);
        }
      }

      _logger.i('🔄 Restored ${backup.length} items from backup');
      return true;
    } catch (e) {
      _logger.e('❌ Restore failed: $e');
      return false;
    }
  }
}