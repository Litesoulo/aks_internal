import 'package:mobx/mobx.dart';

/// Extension methods on [FutureStatus] to simplify status checks.
extension FutureStatusExtension on FutureStatus {
  /// Checks if the current [FutureStatus] is `pending`.
  ///
  /// A `pending` status indicates that the associated future is still in progress.
  bool get isPending => this == FutureStatus.pending;

  /// Checks if the current [FutureStatus] is `rejected`.
  ///
  /// A `rejected` status indicates that the associated future has completed
  /// with an error or was not fulfilled successfully.
  bool get isRejected => this == FutureStatus.rejected;

  /// Checks if the current [FutureStatus] is `fulfilled`.
  ///
  /// A `fulfilled` status indicates that the associated future has completed
  /// successfully with a value.
  bool get isFulfilled => this == FutureStatus.fulfilled;
}
