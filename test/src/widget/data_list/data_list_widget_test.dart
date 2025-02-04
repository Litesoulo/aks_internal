import 'dart:async';

import 'package:aks_internal/aks_internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/test_utils.dart';

class MockDataFetcher extends Mock {
  Future<List<String>> call();
}

void main() {
  late MockDataFetcher mockDataFetcher;
  late DataFetcherStore<String> store;

  setUp(() {
    mockDataFetcher = MockDataFetcher();
    store = DataFetcherStore<String>(dataFetcher: mockDataFetcher.call);

    final mockConfig = createMockConfig();
    // Initialize the singleton with the mock config only once
    AksInternal(aksConfig: mockConfig); // This can be skipped if initialize() is automatically called by the factory.
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

    testWidgets('Displays custom widget when customBuilder is provided', (tester) async {
      // Arrange
      when(() => mockDataFetcher.call()).thenAnswer((_) async => ['Item 1', 'Item 2', 'Item 3']);

      // Define a custom builder that returns a Column with the items
      Widget customBuilder(BuildContext context, List<String> items) {
        return Column(
          children: items.map(Text.new).toList(),
        );
      }

      // Create the widget under test with the customBuilder
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataListWidget<String>(
              store: store,
              loadingBuilder: (context) => const CircularProgressIndicator(),
              customBuilder: customBuilder,
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ),
      );

      // Act
      await tester.runAsync(() => store.fetch());
      await tester.pump(); // Wait for the state update

      // Assert
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
      expect(find.byType(Column), findsOneWidget); // Ensure the custom builder's Column is used
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

  group('Additional DataListWidget Tests', () {
    testWidgets('Displays initialItem as the first item when provided', (tester) async {
      // Arrange
      when(() => mockDataFetcher.call()).thenAnswer((_) async => ['Item 1', 'Item 2', 'Item 3']);

      const initialItem = Text('Initial Item');

      // Create the widget under test with initialItem
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataListWidget<String>(
              store: store,
              loadingBuilder: (context) => const CircularProgressIndicator(),
              itemBuilder: (context, item) => ListTile(title: Text(item)),
              initialItem: initialItem,
            ),
          ),
        ),
      );

      // Act
      await tester.runAsync(() => store.fetch());
      await tester.pump(); // Wait for the state update

      // Assert
      expect(find.text('Initial Item'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('Uses custom separator builder when provided', (tester) async {
      // Arrange
      when(() => mockDataFetcher.call()).thenAnswer((_) async => ['Item 1', 'Item 2', 'Item 3']);

      // Define a custom separator builder
      Widget customSeparatorBuilder(BuildContext context, int index) {
        return const Divider(color: Colors.red);
      }

      // Create the widget under test with custom separator builder
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataListWidget<String>(
              store: store,
              loadingBuilder: (context) => const CircularProgressIndicator(),
              itemBuilder: (context, item) => ListTile(title: Text(item)),
              separatorBuilder: customSeparatorBuilder,
            ),
          ),
        ),
      );

      // Act
      await tester.runAsync(() => store.fetch());
      await tester.pump(); // Wait for the state update

      // Assert
      expect(find.byType(Divider), findsNWidgets(2)); // 3 items = 2 separators
      final divider = tester.widget<Divider>(find.byType(Divider).first);
      expect(divider.color, Colors.red);
    });

    testWidgets('Applies padding to the list when provided', (tester) async {
      // Arrange
      when(() => mockDataFetcher.call()).thenAnswer((_) async => ['Item 1', 'Item 2', 'Item 3']);

      const padding = EdgeInsets.all(16.0);

      // Create the widget under test with padding
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataListWidget<String>(
              store: store,
              loadingBuilder: (context) => const CircularProgressIndicator(),
              itemBuilder: (context, item) => ListTile(title: Text(item)),
              padding: padding,
            ),
          ),
        ),
      );

      // Act
      await tester.runAsync(() => store.fetch());
      await tester.pump(); // Wait for the state update

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.padding, padding);
    });

    testWidgets('Displays error state when store fetch fails', (tester) async {
      // Arrange
      when(() => mockDataFetcher.call()).thenAnswer((_) async => Future.error('Error occurred'));

      // Create the widget under test with errorBuilder
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataListWidget<String>(
              store: store,
              loadingBuilder: (context) => const CircularProgressIndicator(),
              itemBuilder: (context, item) => ListTile(title: Text(item)),
              errorBuilder: (context) => const Text('Error occurred'),
            ),
          ),
        ),
      );

      // Act
      await tester.runAsync(() => store.fetch());
      await tester.pump(); // Wait for the state update

      // Assert
      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('Displays loading state while fetching data', (tester) async {
      // Arrange
      when(() => mockDataFetcher.call()).thenAnswer(
        (_) => Future.delayed(const Duration(milliseconds: 500), () => ['Item 1', 'Item 2', 'Item 3']),
      );

      // Create the widget under test
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataListWidget<String>(
              store: store,
              loadingBuilder: (context) => const CircularProgressIndicator(),
              itemBuilder: (context, item) => ListTile(title: Text(item)),
            ),
          ),
        ),
      );

      // Act
      unawaited(store.fetch()); // Trigger the fetch operation
      await tester.pump(const Duration(milliseconds: 100)); // Simulate partial delay for loading state

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle(); // Wait for the fetch to complete
    });

    testWidgets('Displays empty state when store fetch returns no items', (tester) async {
      // Arrange
      when(() => mockDataFetcher.call()).thenAnswer((_) async => []);

      // Create the widget under test with emptyBuilder
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataListWidget<String>(
              store: store,
              loadingBuilder: (context) => const CircularProgressIndicator(),
              itemBuilder: (context, item) => ListTile(title: Text(item)),
              emptyBuilder: (context) => const Text('No items available'),
            ),
          ),
        ),
      );

      // Act
      await tester.runAsync(() => store.fetch());
      await tester.pump(); // Wait for the state update

      // Assert
      expect(find.text('No items available'), findsOneWidget);
    });
  });
}
