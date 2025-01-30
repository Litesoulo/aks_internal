import 'package:aks_internal/aks_internal.dart';
import 'package:flutter/material.dart';

AksAppConfig createMockConfig() {
  return AksAppConfig(
    aksDefaultBuilders: AksDefaultBuilders(
      horizontalSeparatorBuilder: (_, __) => Space.empty,
      verticalSeparatorBuilder: (_, __) => Space.empty,
    ),
    appConstants: AksAppConstants(
      verticalSeparator: const SizedBox.shrink(),
      horizontalSeparator: const SizedBox.shrink(),
      borderRadius: 10,
      padding: 8,
      animationDuration: const Duration(seconds: 1),
    ),
  );
}
