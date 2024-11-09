// lib/src/app_manager.dart
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';


class AppManager {
  // Private constructor for singleton pattern
  AppManager._privateConstructor();
  static final AppManager _instance = AppManager._privateConstructor();
  factory AppManager() {
    return _instance;
  }

  String _applicationName = 'YourAppName';
  bool _isDevelopingMode = true;
  String _applicationVersion = '1.0.0';

  /// Initializes the AppManager with optional configurations.
  /// [applicationName] allows setting a custom application name.
  /// [isDevelopingMode] sets the development mode flag.
  static Future<void> initialize({
    String applicationName = 'YourAppName',
    bool isDevelopingMode = true,
  }) async {
    _instance._applicationName = applicationName;
    _instance._isDevelopingMode = isDevelopingMode;
    await _instance._getApplicationVersion();
  }

  /// Retrieves the application version from PackageInfo.
  Future<void> _getApplicationVersion() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _applicationVersion = packageInfo.version;
    } catch (e) {
      _applicationVersion = '1.0.0';
    }
  }

  /// Gets the current application version.
  String get currentVersion => _applicationVersion;
  /// Gets the application name.
  String get applicationName => _applicationName;
  /// Checks if the app is in developing mode.
  bool get isDevelopingMode => _isDevelopingMode;
}
