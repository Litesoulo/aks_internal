import 'dart:async';

import 'package:aks_internal/aks_internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataFetcher extends Mock {
  Future<List<String>> call();
}

void main() {
  late MockDataFetcher mockDataFetcher;
  late DataFetcherStore<String> store;

  setUp(() {
    mockDataFetcher = MockDataFetcher();
    store = DataFetcherStore<String>(dataFetcher: mockDataFetcher.call);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: DataListWidget<String>(
          store: store,
          errorBuilder: (context) => const Text('Error occurred'),
          emptyBuilder: (context) => const Text('No items available'),
          loadingBuilder: (context) => const CircularProgressIndicator(),
          itemBuilder: (context, item) => ListTile(title: Text(item)),
          separatorBuilder: (context, index) => const Divider(),
        ),
      ),
    );
  }

  group('DataListWidget Tests', () {
    testWidgets('Displays loading state when store is loading', (tester) async {
      // Arrange
      when(() => mockDataFetcher.call()).thenAnswer(
        (_) => Future.delayed(const Duration(milliseconds: 500), () => []),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      unawaited(store.fetch()); // Trigger the fetch operation
      await tester.pump(const Duration(milliseconds: 100)); // Simulate partial delay for loading state

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('Displays error state when store fetch fails', (tester) async {
      // Arrange
      when(() => mockDataFetcher.call()).thenAnswer((_) async => Future.error('Error occurred'));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.runAsync(() => store.fetch());
      await tester.pump(); // Wait for the state update

      // Assert
      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('Displays empty state when store fetch returns no items', (tester) async {
      // Arrange
      when(() => mockDataFetcher.call()).thenAnswer((_) async => []);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.runAsync(() => store.fetch());
      await tester.pump(); // Wait for the state update

      // Assert
      expect(find.text('No items available'), findsOneWidget);
    });

    testWidgets('Displays list of items when store fetch returns data', (tester) async {
      // Arrange
      when(() => mockDataFetcher.call()).thenAnswer((_) async => ['Item 1', 'Item 2', 'Item 3']);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.runAsync(() => store.fetch());
      await tester.pump(); // Wait for the state update

      // Assert
      expect(find.byType(ListTile), findsNWidgets(3));
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('Displays separators between list items', (tester) async {
      // Arrange
      when(() => mockDataFetcher.call()).thenAnswer((_) async => ['Item 1', 'Item 2', 'Item 3']);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.runAsync(() => store.fetch());
      await tester.pump(); // Wait for the state update

      // Assert
      expect(find.byType(Divider), findsNWidgets(2)); // 3 items = 2 separators
    });
  });
}
