import 'package:aks_internal/aks_internal.dart';

/// Configuration class for the application.
///
/// This class holds global configurations required by the app, such as constants,
/// separators, and default builder functions. It acts as a central place for accessing
/// app-wide configuration settings.
///
/// Use this class to pass shared configurations like [AksAppConstants] and [AksDefaultBuilders]
/// to other parts of the app.
class AksAppConfig {
  /// Creates an instance of [AksAppConfig].
  ///
  /// - [appConstants]: The application constants, such as default spacing, padding, etc.
  /// - [aksDefaultBuilders]: Custom builder functions for the default separators (horizontal and vertical).
  AksAppConfig({
    required this.appConstants,
    required this.aksDefaultBuilders,
  });

  /// Holds constants for the application, including default values for UI elements.
  final AksAppConstants appConstants;

  /// Contains custom builder functions for creating horizontal and vertical separators.
  final AksDefaultBuilders aksDefaultBuilders;
}
