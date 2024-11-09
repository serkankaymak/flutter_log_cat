// log_cat.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../app_manager.dart';
import 'log_cat_entry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';

class LogCat {
  static String logFileName = '${AppManager().applicationName}_log.txt';
  static final _lock = Lock();

  static Future<LogCatEntry> _createErrorLine({
    required String className,
    String? methodName,
    required String message,
    Exception? exception,
  }) async {
    return LogCatEntry(
      logEntryType: LogEntryType.error,
      timestamp: DateTime.now(),
      platformInfo: Platform.operatingSystemVersion,
      className: className,
      methodName: methodName,
      message: message,
      exception: exception?.toString(),
    );
  }

  static Future<void> error({
    required String className,
    String? methodName,
    required String message,
    Exception? exception,
  }) async {
    debugPrint('LogCatError: $className${methodName != null ? '.$methodName' : ''} --> ${message ?? exception?.toString() ?? ''}');

    LogCatEntry logCatEntry = await _createErrorLine(
      className: className,
      methodName: methodName,
      message: message,
      exception: exception,
    );
    await _writeErrorLine(logCatEntry);
  }

  static void warning(String className, String message) {
    if (!AppManager().isDevelopingMode) return;
    debugPrint('LogCatWarning: $className --> $message');
  }

  static void information(String className, String message) {
    if (!AppManager().isDevelopingMode) return;
    debugPrint('LogCatInformation: $className --> $message');
  }

  static void debug(String className, String message) {
    if (!AppManager().isDevelopingMode) return;
    debugPrint('LogCatDebug: $className --> $message');
  }

  static void verbose(String className, String message) {
    if (!AppManager().isDevelopingMode) return;
    debugPrint('LogCatVerbose: $className --> $message');
  }

  static Future<void> _writeErrorLine(LogCatEntry logCatEntry) async {
    try {
      String line = logCatEntry.toJson();
      final directory = await getApplicationDocumentsDirectory();
      final logFile = File('${directory.path}/$logFileName');

      await _lock.synchronized(() async {
        await logFile.writeAsString('$line\n',
            mode: FileMode.append, flush: true);
      });
    } catch (e) {
      debugPrint('Error writing to log file: $e');
    }
  }

  static Future<List<LogCatEntry>> readLogEntries() async {
    String logContent = await readErrorDetailsFromLogFile();
    List<LogCatEntry> entries = [];

    List<String> lines = logContent.split('\n');
    for (String line in lines) {
      if (line.trim().isEmpty) continue;
      try {
        LogCatEntry entry = LogCatEntry.fromJson(line);
        entries.add(entry);
      } catch (e) {
        debugPrint('Error parsing log line: $e');
      }
    }

    return entries;
  }

  static Future<String> readErrorDetailsFromLogFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logFile = File('${directory.path}/$logFileName');
      if (await logFile.exists()) {
        return await logFile.readAsString();
      }
    } catch (e) {
      debugPrint('Error reading log file: $e');
    }
    return '';
  }

  static Future<List<int>?> getCompressedLogFile() async {
    try {
      final logContent = await readErrorDetailsFromLogFile();
      final bytes = utf8.encode(logContent);
      final compressedBytes = gzip.encode(bytes);
      return compressedBytes;
    } catch (e) {
      debugPrint('Error compressing log file: $e');
      return null;
    }
  }

  static Future<File> getLogFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$logFileName');
  }

  static Future<void> clearLogFile() async {
    try {
      final file = await getLogFile();
      if (await file.exists()) {
        await file.writeAsString('', flush: true);
        debugPrint('Log file cleared.');
      }
    } catch (e) {
      debugPrint('Error clearing log file: $e');
    }
  }
}
