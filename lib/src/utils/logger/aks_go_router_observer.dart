import 'package:aks_internal/aks_internal.dart';
import 'package:flutter/material.dart';

/// A navigator observer that logs route changes using [AksLogger].
///
/// This observer tracks push/pop/replace events in the navigation stack
/// and provides detailed logging for debugging purposes.
class AksGoRouterObserver extends NavigatorObserver {
  /// Logs a navigation event with the current route information
  void _logNavigationEvent(String event, {Route<dynamic>? current, Route<dynamic>? previous}) {
    final currentRoute = _getRouteInfo(current);
    final previousRoute = _getRouteInfo(previous);

    AksLogger.i('$event - Current: $currentRoute, Previous: $previousRoute');
  }

  /// Extracts meaningful information from a route
  String _getRouteInfo(Route<dynamic>? route) {
    if (route == null) return 'none';

    final settings = route.settings;
    return settings.name ?? route.runtimeType.toString();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logNavigationEvent(
      'PUSHED',
      current: route,
      previous: previousRoute,
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logNavigationEvent(
      'POPPED',
      current: previousRoute,
      previous: route,
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _logNavigationEvent(
      'REMOVED',
      current: previousRoute,
      previous: route,
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logNavigationEvent(
      'REPLACED',
      current: newRoute,
      previous: oldRoute,
    );
  }
}
