import 'dart:async';

import 'package:aks_internal/aks_internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSingleDataFetcher extends Mock {
  Future<String?> call();
}

void main() {
  late MockSingleDataFetcher mockDataFetcher;
  late SingleDataFetcherStore<String?> store;

  setUp(() {
    mockDataFetcher = MockSingleDataFetcher();
    store = SingleDataFetcherStore<String?>(dataFetcher: mockDataFetcher.call);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: SingleDataWidget<String?>(
          store: store,
          loadingBuilder: (context) => const CircularProgressIndicator(),
          errorBuilder: (context) => const Text('Error occurred'),
          itemBuilder: (context, item) => Text('Data: $item'),
        ),
      ),
    );
  }

  group('SingleDataWidget Tests', () {
    testWidgets('Displays loading state when store is loading', (tester) async {
      // Arrange
      when(() => mockDataFetcher.call()).thenAnswer(
        (_) => Future.delayed(const Duration(seconds: 1), () => 'Fetched Item'),
      );

      // Act
      unawaited(store.fetch());
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); // Trigger loading state

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('Displays error state when fetch fails', (tester) async {
      // Arrange
      when(() => mockDataFetcher.call()).thenThrow(Exception('Fetch error'));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.runAsync(() => store.fetch());
      await tester.pump(); // Trigger error state

      // Assert
      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('Displays item when fetch succeeds', (tester) async {
      // Arrange
      const fetchedItem = 'Fetched Item';
      when(() => mockDataFetcher.call()).thenAnswer((_) async => fetchedItem);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.runAsync(() => store.fetch());
      await tester.pump(); // Trigger item rendering

      // Assert
      expect(find.text('Data: $fetchedItem'), findsOneWidget);
    });

    testWidgets('Displays error state when item is null', (tester) async {
      // Arrange
      when(() => mockDataFetcher.call()).thenAnswer((_) async => null);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.runAsync(() => store.fetch());
      await tester.pump(); // Trigger null item check

      // Assert
      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('Handles state transitions correctly', (tester) async {
      // Arrange
      const fetchedItem = 'Fetched Item';
      when(() => mockDataFetcher.call()).thenAnswer(
        (_) => Future.delayed(
          const Duration(milliseconds: 500),
          () => fetchedItem,
        ),
      );

      // Act: Start with loading state
      await tester.pumpWidget(createWidgetUnderTest()); // Build the widget tree
      unawaited(store.fetch()); // Trigger the fetch operation
      await tester.pump(const Duration(milliseconds: 100)); // Partial loading

      // Assert: Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the fetch operation to complete
      await tester.pump(const Duration(milliseconds: 500)); // Allow fetch to complete

      // Assert: Verify item rendering
      expect(find.text('Data: $fetchedItem'), findsOneWidget);
    });
  });
}
