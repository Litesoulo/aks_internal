import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

/// Exception to handle errors returned by the Parse Server SDK.
///
/// This class wraps the error information provided by the Parse server,
/// making it easier to handle and debug issues in the application.
class ParseErrorException implements Exception {
  /// Constructs a [ParseErrorException] with the provided [parseError].
  ///
  /// [parseError] should contain details about the specific error
  /// encountered during an operation with the Parse server.
  ParseErrorException({
    required this.parseError,
  });

  /// The [ParseError] object that contains details of the error returned by the Parse server.
  final ParseError? parseError;
}
