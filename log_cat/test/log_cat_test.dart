// test/log_cat_entry_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:log_cat_entry/common/LogCat/log_cat_entry.dart';
import 'dart:convert';

void main() {
  group('LogCatEntry', () {
    test('toJson and fromJson should work correctly with all fields', () {
      final entry = LogCatEntry(
        logEntryType: LogEntryType.debug,
        timestamp: DateTime.parse('2024-04-27T10:20:30Z'),
        platformInfo: 'Flutter 3.0',
        className: 'TestClass',
        methodName: 'testMethod',
        message: 'This is a test message.',
        exception: 'TestException',
      );

      final jsonString = json.encode(entry.toJson());
      final newEntry = LogCatEntry.fromJson(json.decode(jsonString));

      expect(newEntry.logEntryType, entry.logEntryType);
      expect(newEntry.timestamp, entry.timestamp);
      expect(newEntry.platformInfo, entry.platformInfo);
      expect(newEntry.className, entry.className);
      expect(newEntry.methodName, entry.methodName);
      expect(newEntry.message, entry.message);
      expect(newEntry.exception, entry.exception);
    });

    test('fromJson should handle missing optional fields and set default values', () {
      final jsonString = '''
      {
        "logType": "info",
        "message": "Application started"
      }
      ''';

      final entry = LogCatEntry.fromJson(json.decode(jsonString));

      expect(entry.logEntryType, LogEntryType.info);
      expect(entry.timestamp, isNotNull);
      expect(entry.platformInfo, isNull);
      expect(entry.className, isNull);
      expect(entry.methodName, isNull);
      expect(entry.message, 'Application started');
      expect(entry.exception, isNull);
    });

    test('fromJson should throw FormatException on invalid JSON', () {
      final invalidJson = 'Invalid JSON String';

      expect(() => LogCatEntry.fromJson(json.decode(invalidJson)), throwsA(isA<FormatException>()));
    });

    test('fromJson should default to LogEntryType.info for unknown log types', () {
      final jsonString = '''
      {
        "logType": "unknown",
        "message": "Unknown log type"
      }
      ''';

      final entry = LogCatEntry.fromJson(json.decode(jsonString));

      expect(entry.logEntryType, LogEntryType.info);
      expect(entry.timestamp, isNotNull);
      expect(entry.message, 'Unknown log type');
    });

    test('multiple default values are correctly assigned', () {
      final entry = LogCatEntry(
        logEntryType: LogEntryType.error,
        message: 'Error occurred',
      );

      expect(entry.timestamp, isNotNull);
      expect(entry.logEntryType, LogEntryType.error);
      expect(entry.message, 'Error occurred');
      expect(entry.platformInfo, isNull);
      expect(entry.className, isNull);
      expect(entry.methodName, isNull);
      expect(entry.exception, isNull);
    });
  });


}
