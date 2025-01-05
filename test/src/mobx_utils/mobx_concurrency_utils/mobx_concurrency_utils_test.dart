import 'dart:async';

import 'package:aks_internal/src/mobx_utils/mobx_concurrency/mobx_concurrency_utils.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test class for MobxConcurrencyUtils functionality.
class TestMobxConcurrencyUtils with MobxConcurrencyUtils {}

void main() {
  late TestMobxConcurrencyUtils utils;

  setUp(() {
    // Initialize the test utility instance before each test.
    utils = TestMobxConcurrencyUtils();
  });

  tearDown(() {
    // Dispose of resources and clear state after each test.
    utils.dispose();
  });

  group('MobxConcurrencyUtils Tests', () {
    test('Concurrent Action Execution', () async {
      final callOrder = <String>[];

      // Run two concurrent actions and collect the order of their execution.
      await Future.wait([
        utils.runInConcurrentAction(() async {
          callOrder.add('action1');
          await Future<void>.delayed(const Duration(milliseconds: 100));
        }, ActionType.concurrent),
        utils.runInConcurrentAction(() async {
          callOrder.add('action2');
          await Future<void>.delayed(const Duration(milliseconds: 50));
        }, ActionType.concurrent),
      ]);

      // Verify both actions were executed, irrespective of the order.
      expect(callOrder, containsAll(['action1', 'action2']));
    });

    test('Sequential Action Execution', () async {
      final callOrder = <String>[];

      // Start two sequential actions and record their execution order.
      unawaited(
        utils.runInConcurrentAction(
          () async {
            callOrder.add('action1');
            await Future<void>.delayed(const Duration(milliseconds: 100));
          },
          ActionType.sequential,
        ),
      );
      unawaited(
        utils.runInConcurrentAction(
          () async {
            callOrder.add('action2');
            await Future<void>.delayed(const Duration(milliseconds: 50));
          },
          ActionType.sequential,
        ),
      );

      // Allow sufficient time for both actions to complete.
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Verify actions were executed in the correct order.
      expect(callOrder, ['action1', 'action2']);
    });

    test('Droppable Action Execution', () async {
      final callOrder = <String>[];

      // Start two droppable actions. Only the first should execute.
      unawaited(
        utils.runInConcurrentAction(
          () async {
            callOrder.add('action1');
            await Future<void>.delayed(const Duration(milliseconds: 100));
          },
          ActionType.droppable,
        ),
      );
      unawaited(
        utils.runInConcurrentAction(
          () async {
            callOrder.add('action2');
          },
          ActionType.droppable,
        ),
      );

      // Allow sufficient time for the actions to complete.
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Verify that only the first action was executed.
      expect(callOrder, ['action1']);
    });
  });
}
