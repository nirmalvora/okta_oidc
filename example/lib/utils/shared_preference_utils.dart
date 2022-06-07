import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

/// This file contains methods used for storing information on shared preferences (local dynamic storage).

Future<SharedPreferences> get _instance async =>
    _prefs ??= await SharedPreferences.getInstance();
SharedPreferences? _prefs;

SharedPreferences? _prefsInstance;

/// In case the developer does not explicitly call the init() function.
bool _initCalled = false;

/// Initialize the SharedPreferences object
/// in the State object's iniState() function.
Future<SharedPreferences> init() async {
  _initCalled = true;
  _prefsInstance = await _instance;
  return _prefsInstance!;
}

/// Best to clean up by calling this function in
/// the State object's dispose() function.
void dispose() {
  _prefs = null;
  _prefsInstance = null;
}

void isPreferenceReady() {
  assert(_initCalled,
      'Prefs.init() must be called first in an initState() preferably!');
  assert(_prefsInstance != null, 'SharedPreferences not ready yet!');
}

/// Returns all keys in the persistent storage.
Set<String> getKeys() {
  isPreferenceReady();
  return _prefsInstance!.getKeys();
}

/// Returns a Future.
Future<Set<String>> getKeysF() async {
  Set<String> value;
  if (_prefsInstance == null) {
    var prefs = await _instance;
    value = prefs.getKeys();
  } else {
    value = getKeys();
  }
  return value;
}

/// Reads a value of any type from persistent storage.
dynamic getDynamic(String key) {
  isPreferenceReady();
  return _prefsInstance!.get(key);
}

/// Returns a Future.
Future<dynamic> getDynamicF(String key) async {
  dynamic value;
  if (_prefsInstance == null) {
    var prefs = await _instance;
    value = prefs.get(key);
  } else {
    value = getDynamic(key);
  }
  return value;
}

bool getBool(String key, [bool? defValue]) {
  isPreferenceReady();
  return _prefsInstance!.getBool(key) ?? defValue ?? false;
}

/// Returns a Future.
Future<bool> getBoolF(String key, [bool? defValue]) async {
  bool value;
  if (_prefsInstance == null) {
    var prefs = await _instance;
    value = prefs.getBool(key) ?? defValue ?? false;
  } else {
    value = getBool(key);
  }
  return value;
}

int getInt(String key, [int? defValue]) {
  return _prefsInstance!.getInt(key) ?? defValue ?? 0;
}

/// Returns a Future.
Future<int> getIntF(String key, [int? defValue]) async {
  int value;
  if (_prefsInstance == null) {
    var prefs = await _instance;
    value = prefs.getInt(key) ?? defValue ?? 0;
  } else {
    value = getInt(key);
  }
  return value;
}

double getDouble(String key, [double? defValue]) {
  isPreferenceReady();
  return _prefsInstance!.getDouble(key) ?? defValue ?? 0.0;
}

/// Returns a Future.
Future<double> getDoubleF(String key, [double? defValue]) async {
  double value;
  if (_prefsInstance == null) {
    var prefs = await _instance;
    value = prefs.getDouble(key) ?? defValue ?? 0.0;
  } else {
    value = getDouble(key);
  }
  return value;
}

String getString(String key, [String? defValue]) {
  isPreferenceReady();
  return _prefsInstance!.getString(key) ?? defValue ?? '';
}

/// Returns a Future.
Future<String> getStringF(String key, [String? defValue]) async {
  String value;
  if (_prefsInstance == null) {
    var prefs = await _instance;
    value = prefs.getString(key) ?? defValue ?? '';
  } else {
    value = getString(key);
  }
  return value;
}

List<String> getStringList(String key, [List<String>? defValue]) {
  isPreferenceReady();
  return _prefsInstance!.getStringList(key) ?? defValue ?? [''];
}

/// Returns a Future.
Future<List<String>> getStringListF(String key,
    [List<String>? defValue]) async {
  List<String> value;
  if (_prefsInstance == null) {
    var prefs = await _instance;
    value = prefs.getStringList(key) ?? defValue ?? [''];
  } else {
    value = getStringList(key);
  }
  return value;
}

/// Saves a boolean [value] to persistent storage in the background.
/// If [value] is null, this is equivalent to calling [remove()] on the [key].
Future<bool> setBool(String key, bool value) async {
  var prefs = await _instance;
  return prefs.setBool(key, value);
}

/// Saves an integer [value] to persistent storage in the background.
/// If [value] is null, this is equivalent to calling [remove()] on the [key].
Future<bool> setInt(String key, int value) async {
  var prefs = await _instance;
  return prefs.setInt(key, value);
}

/// Saves a double [value] to persistent storage in the background.
/// Android doesn't support storing doubles, so it will be stored as a float.
/// If [value] is null, this is equivalent to calling [remove()] on the [key].
Future<bool> setDouble(String key, double value) async {
  var prefs = await _instance;
  return prefs.setDouble(key, value);
}

/// Saves a string [value] to persistent storage in the background.
/// If [value] is null, this is equivalent to calling [remove()] on the [key].
Future<bool> setString(String key, String value) async {
  var prefs = await _instance;
  return prefs.setString(key, value);
}

/// Saves a list of strings [value] to persistent storage in the background.
/// If [value] is null, this is equivalent to calling [remove()] on the [key].
Future<bool> setStringList(String key, List<String> value) async {
  var prefs = await _instance;
  return prefs.setStringList(key, value);
}

/// Removes an entry from persistent storage.
Future<bool> remove(String key) async {
  var prefs = await _instance;
  return prefs.remove(key);
}

/// Completes with true once the user preferences for the app has been cleared.
Future<bool> prefClear() async {
  var prefs = await _instance;
  return prefs.clear();
}
