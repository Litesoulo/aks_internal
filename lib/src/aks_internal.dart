import 'package:aks_internal/aks_internal.dart';

/// {@template aks_internal}
/// Shared utilities for Flutter apps, implementing a singleton pattern.
/// This class ensures only one instance is created and shared throughout
/// the application, maintaining a consistent configuration across the app.
/// {@endtemplate}
class AksInternal {
  /// Factory constructor to return the singleton instance of [AksInternal].
  ///
  /// This constructor ensures that only one instance of [AksInternal] is
  /// created and shared across the entire application. The provided
  /// [aksConfig] will be assigned to the singleton instance's configuration.
  ///
  /// - [aksConfig]: The configuration to be assigned to the instance.
  factory AksInternal({required AksAppConfig aksConfig}) {
    // Initialize the config only if it hasn't been initialized yet
    _instance._config ??= aksConfig;

    return _instance;
  }

  /// Private internal constructor for the singleton pattern.
  ///
  /// This constructor prevents external instantiation of [AksInternal].
  /// The singleton instance is created via the factory constructor.
  AksInternal._internal();

  /// The singleton instance of [AksInternal].
  ///
  /// This instance is the only one used throughout the application.
  static final AksInternal _instance = AksInternal._internal();

  /// The configuration associated with the singleton instance.
  ///
  /// This [AksAppConfig] object holds the necessary configuration for the app.
  ///
  static AksAppConfig get config => _instance._config!;

  /// Provides access to the application constants.
  ///
  /// This getter retrieves the [AksAppConstants] from the current configuration.
  /// It ensures a centralized and consistent access point for app-wide constants.
  static AksAppConstants get constants => config.appConstants;

  // We change _config to be nullable to allow for checking before initialization.
  AksAppConfig? _config;
}
