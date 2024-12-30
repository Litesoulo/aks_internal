import 'package:flutter/material.dart';
import 'package:l/l.dart';

/// Extension on [LogLevel] to add an emoji to each log level
///
/// This emojis are used to visually distinguish the different log levels in the
/// console. The emojis are:
///
/// - [LogLevel.shout]: ❗️
/// - [LogLevel.error]: 🚫
/// - [LogLevel.warning]: ⚠️
/// - [LogLevel.info]: 💡
/// - [LogLevel.debug]: 🐞
/// - orElse: 📌
extension LogLevelEmoji on LogLevel {
  /// Emoji for each log level
  ///
  /// This emojis are used to visually distinguish the different log levels in the
  /// console.
  String get emoji => maybeWhen(
        shout: () => '❗️',
        error: () => '🚫',
        warning: () => '⚠️',
        info: () => '💡',
        debug: () => '🐞',
        orElse: () => '📌',
      );
}

extension _DateTimeExtension on DateTime {
  /// Transforms DateTime to String with format: 00:00:00
  ///
  /// This is a helper method to format the datetime in a nice way in the console.
  String get formatted => [hour, minute, second].map(AksLogger.timeFormat).join(':');
}

/// AksLogger is a wrapper around the [L] library.
///
/// This class provides a nicer API for the [L] library and adds some additional
/// functionality like formatting the log messages with emojis.
class AksLogger {
  /// Logs a message at the info level
  ///
  /// This method is forwarded to the [L] library.
  static void i(Object message) => l.i(message);

  /// Logs a message at the warning level
  ///
  /// This method is forwarded to the [L] library.
  static void w(Object message, [StackTrace? stackTrace]) => l.w(message, stackTrace);

  /// Logs a message at the error level
  ///
  /// This method is forwarded to the [L] library.
  static void e(Object message, [StackTrace? stackTrace]) => l.e(message, stackTrace);

  /// Logs a message at the debug level
  ///
  /// This method is forwarded to the [L] library.
  static void d(Object message) => l.d(message);

  /// How much digits there should be in the time
  static const int timeLength = 2;

  /// Log options for the [L] library
  static const LogOptions _logOptions = LogOptions(
    printColors: false,
    messageFormatting: _formatLoggerMessage,
  );

  /// Formats the time to have [timeLength] digits
  static String timeFormat(int input) => input.toString().padLeft(timeLength, '0');

  /// Formats the message for the [L] library
  ///
  /// This method is used to format the message in the [L] library.
  static String _formatLoggerMessage(
    LogMessage message,
  ) =>
      '${message.level.emoji} ${message.timestamp.formatted} | $message';

  /// Formats the error message for the [L] library
  ///
  /// If [stackTrace] is null then we get the stack trace from the
  /// [StackTrace.current].
  ///
  /// Builds error through [StringBuffer] and returns it.
  static String formatError(
    String type,
    String error,
    StackTrace? stackTrace,
  ) {
    final trace = stackTrace ?? StackTrace.current;

    final buffer = StringBuffer(type)
      ..write(' error: ')
      ..writeln(error)
      ..writeln('Stack trace:')
      ..write(trace.toString());

    return buffer.toString();
  }

  /// Helper static method to log a zone error
  ///
  /// later, it would be send to the sentry
  static void logZoneError(
    Object? e,
    StackTrace s,
  ) =>
      l.e(formatError('Top-level', e.toString(), s), s);

  /// Helper static method to log a flutter error [FlutterError.onError]
  /// like widget overflow, etc.
  static void logFlutterError(
    FlutterErrorDetails details,
  ) =>
      l.e(
        formatError('Flutter', details.exceptionAsString(), details.stack),
        details.stack,
      );

  /// Helper static method to log a platform dispatcher error
  /// like native code errors
  static bool logPlatformDispatcherError(Object exception, StackTrace stackTrace) {
    l.e(
      formatError('PlatformDispatcher', exception.toString(), stackTrace),
      stackTrace,
    );
    return true;
  }

  /// run in a zone
  ///
  /// This method is forwarded to the [L] library.
  static T runLogging<T>(T Function() body) => l.capture(body, _logOptions);
}
