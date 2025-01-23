import 'package:aks_internal/aks_internal.dart';

/// {@template aks_internal}
/// Shared utilities for Flutter apps.
///
/// This class implements a singleton pattern to ensure only one instance
/// is created and shared throughout the application.
/// {@endtemplate}
class AksInternal {
  /// Factory constructor to return the singleton instance.
  ///
  /// Always returns the same instance of [AksInternal].
  factory AksInternal() => _instance;

  /// Private internal constructor for the singleton pattern.
  ///
  /// Prevents external instantiation of the class.
  AksInternal._internal();

  /// The singleton instance of [AksInternal].
  static final AksInternal _instance = AksInternal._internal();

  /// Initializes the [AksInternal] singleton with optional configurations.
  ///
  /// Use this method to set up dependencies or configurations
  /// necessary for the application. If a [config] is provided,
  /// logs an initialization message.
  ///
  /// - [config]: Optional application configurations.
  void initialize({AksAppConfig? config}) {
    // Perform any setup actions here, e.g., setting up dependencies.
    if (config != null) {
      AksLogger.i('AksInternal initialized');
    }
  }
}
