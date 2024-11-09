// log_entry.dart
import 'dart:convert';

enum LogEntryType { error, debug, info }

class LogCatEntry {
  final LogEntryType logEntryType;
  final DateTime timestamp;
  final String? platformInfo;
  final String? className;
  final String? methodName;
  final String message;
  final String? exception;

  LogCatEntry({
    LogEntryType? logEntryType,
    DateTime? timestamp,
    this.platformInfo,
    this.className,
    this.methodName,
    required this.message,
    this.exception,
  })  : timestamp = timestamp ?? DateTime.now().toUtc(),
        logEntryType = logEntryType ?? LogEntryType.info;

  factory LogCatEntry.fromJson(String jsonString) {
    try {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return LogCatEntry(
        logEntryType: _logEntryTypeFromString(jsonMap['logType'] as String?),
        timestamp: jsonMap['timestamp'] != null
            ? DateTime.parse(jsonMap['timestamp'] as String)
            : null,
        platformInfo: jsonMap['platformInfo'] as String?,
        className: jsonMap['className'] as String?,
        methodName: jsonMap['methodName'] as String,
        message: jsonMap['message'] as String,
        exception: jsonMap['exception'] as String?,
      );
    } catch (e) {
      throw FormatException('Invalid JSON format: $e');
    }
  }

  String toJson() {
    final Map<String, dynamic> jsonMap = {
      'logType': _logEntryTypeToString(logEntryType),
      'methodName': methodName,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      if (platformInfo != null) 'platformInfo': platformInfo,
      if (className != null) 'className': className,
      if (exception != null) 'exception': exception,
    };

    return json.encode(jsonMap);
  }

  static String _logEntryTypeToString(LogEntryType type) {
    return type.toString().split('.').last;
  }

  static LogEntryType _logEntryTypeFromString(String? type) {
    if (type == null) return LogEntryType.info;
    return LogEntryType.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == type.toLowerCase(),
      orElse: () => LogEntryType.info,
    );
  }
}
