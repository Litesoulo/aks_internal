import 'dart:async';
import 'dart:collection';
import 'dart:developer' as developer;

import 'package:mobx/mobx.dart';

/// Typedef for the action callback to be executed.
typedef ActionCallback = FutureOr<void> Function();

/// Enumeration for different types of actions.
enum ActionType {
  /// Allows actions to run concurrently.
  concurrent,

  /// Ensures actions run sequentially, one at a time.
  sequential,

  /// Drops any new actions while an action is already in progress.
  droppable,
}

/// A utility mixin for managing concurrency in MobX actions.
mixin MobxConcurrencyUtils {
  // Internal queue for sequential actions.
  final Queue<Future<void> Function()> _sequentialQueue = Queue<Future<void> Function()>();

  // Flag to indicate if sequential processing is active.
  bool _isSequentialProcessing = false;

  // Flag to indicate if droppable processing is active.
  bool _isDroppableProcessing = false;

  /// Executes the action concurrently without any restrictions.
  ///
  /// [action]: The action to execute.
  /// [name]: Optional name for the action.
  Future<void> _concurrent(ActionCallback action, {String? name}) async {
    final mobxAction = Action(action, name: name);
    await mobxAction();
  }

  /// Queues actions to run sequentially, one at a time.
  ///
  /// [action]: The action to queue and execute sequentially.
  /// [name]: Optional name for the action.
  Future<void> _sequential(ActionCallback action, {String? name}) async {
    _sequentialQueue.add(() async {
      final mobxAction = Action(action, name: name);
      await mobxAction();
    });

    if (!_isSequentialProcessing) {
      _isSequentialProcessing = true;
      while (_sequentialQueue.isNotEmpty) {
        final currentAction = _sequentialQueue.removeFirst();
        try {
          await currentAction();
        } catch (e) {
          developer.log('Error in sequential action: $e');
        }
      }
      _isSequentialProcessing = false;
    }
  }

  /// Executes the action only if no other droppable action is in progress.
  ///
  /// [action]: The action to execute.
  /// [name]: Optional name for the action.
  Future<void> _droppable(ActionCallback action, {String? name}) async {
    if (_isDroppableProcessing) return;

    _isDroppableProcessing = true;
    try {
      final mobxAction = Action(action, name: name);
      await mobxAction();
    } finally {
      _isDroppableProcessing = false;
    }
  }

  /// Runs the given action based on the specified [ActionType].
  ///
  /// [action]: The action to execute.
  /// [type]: The type of action to perform (concurrent, sequential, or droppable).
  /// [name]: Optional name for the action.
  Future<void> runInConcurrentAction(ActionCallback action, ActionType type, {String? name}) async {
    switch (type) {
      case ActionType.concurrent:
        await _concurrent(action, name: name);
      case ActionType.sequential:
        await _sequential(action, name: name);
      case ActionType.droppable:
        await _droppable(action, name: name);
    }
  }

  /// Cleans up resources and resets internal state.
  void dispose() {
    _sequentialQueue.clear();
    _isSequentialProcessing = false;
    _isDroppableProcessing = false;
  }
}
