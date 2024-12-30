import 'dart:async';

import 'package:aks_internal/aks_internal.dart';
import 'package:flutter/foundation.dart';
import 'package:test/test.dart';

void main() {
  group('AksLogger', () {
    // Time Formatting Tests
    group('Time Formatting', () {
      test('timeFormat pads single-digit numbers with zero', () {
        expect(AksLogger.timeFormat(5), '05');
        expect(AksLogger.timeFormat(12), '12');
        expect(AksLogger.timeFormat(0), '00');
      });

      test('timeFormat handles edge cases', () {
        expect(AksLogger.timeFormat(-1), '-1');
        expect(AksLogger.timeFormat(100), '100');
      });
    });

    // Error Formatting Tests
    group('Error Formatting', () {
      test('formatError creates correct error message', () {
        final errorMessage = AksLogger.formatError('Test', 'Sample error', StackTrace.current);

        expect(errorMessage, contains('Test error: Sample error'));
        expect(errorMessage, contains('Stack trace:'));
      });

      test('formatError handles null stackTrace', () {
        final errorMessage = AksLogger.formatError('Null', 'Null stack trace test', null);

        expect(errorMessage, contains('Null error: Null stack trace test'));
        expect(errorMessage, contains('Stack trace:'));
      });
    });

    // Logging Methods Tests
    group('Logging Methods', () {
      test('Logging methods do not throw', () {
        expect(() => AksLogger.i('Info message'), returnsNormally);
        expect(() => AksLogger.d('Debug message'), returnsNormally);
        expect(() => AksLogger.w('Warning message'), returnsNormally);
        expect(() => AksLogger.e('Error message'), returnsNormally);
      });

      test('Logging methods accept various input types', () {
        expect(() => AksLogger.i(42), returnsNormally);
        expect(() => AksLogger.i(['list', 'of', 'items']), returnsNormally);
        expect(() => AksLogger.i({'key': 'value'}), returnsNormally);
      });
    });

    // Zone Error Logging Tests
    group('Zone Error Logging', () {
      test('logZoneError logs correctly', () {
        final testError = Exception('Test zone error');
        expect(() => AksLogger.logZoneError(testError, StackTrace.current), returnsNormally);
      });

      test('logZoneError handles null error', () {
        expect(() => AksLogger.logZoneError(null, StackTrace.current), returnsNormally);
      });
    });

    // Flutter Error Logging Tests
    group('Flutter Error Logging', () {
      test('logFlutterError logs correctly', () {
        final testFlutterError = FlutterErrorDetails(
          exception: Exception('Test flutter error'),
          stack: StackTrace.current,
        );

        expect(() => AksLogger.logFlutterError(testFlutterError), returnsNormally);
      });
    });

    // Platform Dispatcher Error Logging Tests
    group('Platform Dispatcher Error Logging', () {
      test('logPlatformDispatcherError logs and returns true', () {
        final testException = Exception('Test platform error');
        final result = AksLogger.logPlatformDispatcherError(testException, StackTrace.current);

        expect(result, isTrue);
      });
    });

    // RunLogging Method Tests
    group('RunLogging Method', () {
      test('runLogging executes the provided body', () {
        var executed = false;
        final result = AksLogger.runLogging(() {
          executed = true;
          return 42;
        });

        expect(executed, isTrue);
        expect(result, 42);
      });

      test('runLogging handles async functions', () {
        final result = AksLogger.runLogging(() async {
          await Future<void>.delayed(Duration.zero);
          return 'async result';
        });

        expect(result, completion(equals('async result')));
      });
    });
  });
}
