import 'package:aks_internal/aks_internal.dart';

/// Configuration class for the application.
///
/// Holds global configurations required by the app, such as constants
/// or other shared resources.
class AksAppConfig {
  /// Creates an instance of [AksAppConfig].
  ///
  /// Requires the [appConstants] to initialize.
  AksAppConfig({
    required this.appConstants,
  });

  /// Holds constants for the application.
  final AksAppConstants appConstants;
}
