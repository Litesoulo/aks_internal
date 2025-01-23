import 'dart:async';

import 'package:aks_internal/aks_internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockInfiniteListDataFetcher<T> extends Mock {
  Future<List<T>> call({int? offset, int? limit});
}

void main() {
  late MockInfiniteListDataFetcher<int> mockFetcher;
  late InfiniteListStore<int> store;

  setUp(() {
    mockFetcher = MockInfiniteListDataFetcher<int>();
    store = InfiniteListStore(fetchData: mockFetcher.call);
    registerFallbackValue(<int>[]);
    registerFallbackValue(0);
  });

  Widget buildTestWidget({required InfiniteListWidget<int> child}) {
    return MaterialApp(home: Scaffold(body: child));
  }

  testWidgets('renders loading state correctly', (tester) async {
    when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit'))).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      return List.filled(30, 0);
    });

    unawaited(store.fetch());

    await tester.pumpWidget(
      buildTestWidget(
        child: InfiniteListWidget<int>(
          store: store,
          loadingBuilder: (context) => const CircularProgressIndicator(),
          itemBuilder: (context, item) => Text('Item: $item'),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOne);

    await tester.pumpAndSettle();
  });

  testWidgets('renders empty state correctly', (tester) async {
    when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit'))).thenAnswer((_) async {
      return <int>[];
    });

    unawaited(store.fetch());

    await tester.pumpWidget(
      buildTestWidget(
        child: InfiniteListWidget<int>(
          store: store,
          emptyBuilder: (context) => const Text('Empty builder'),
          itemBuilder: (context, item) => Text('Item: $item'),
        ),
      ),
    );

    expect(find.textContaining('Empty builder'), findsOne);
  });

  testWidgets('renders error state correctly', (tester) async {
    when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
        .thenAnswer((_) => Future.error('Error'));

    try {
      await store.fetch();
    } catch (_) {}

    await tester.pumpWidget(
      buildTestWidget(
        child: InfiniteListWidget<int>(
          store: store,
          errorBuilder: (context) => const Text('Error builder'),
          itemBuilder: (context, item) => Text('Item: $item'),
        ),
      ),
    );

    expect(find.textContaining('Error builder'), findsOne);
  });

  testWidgets('renders list items correctly', (tester) async {
    final items = List.generate(30, (i) => i);

    // Mock the data fetcher to return the items
    when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit'))).thenAnswer((_) async => items);

    // Fetch the data
    await store.fetch();

    // Pump the widget
    await tester.pumpWidget(
      buildTestWidget(
        child: InfiniteListWidget<int>(
          store: store,
          itemBuilder: (context, item) => Text(
            'Item: $item',
            key: ValueKey(item),
          ),
        ),
      ),
    );

    // Define the scrollable Finder
    final scrollableFinder = find.byType(Scrollable);

    // Verify each item is present by scrolling
    for (final item in items) {
      await tester.scrollUntilVisible(
        find.byKey(ValueKey(item)), // Find the item
        50.0, // Scroll by 50 pixels
        scrollable: scrollableFinder,
      );

      expect(find.byKey(ValueKey(item)), findsOne);
    }
  });

  testWidgets('renders separators correctly', (tester) async {
    final items = List.generate(30, (i) => i);

    // Mock the data fetcher to return the items
    when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit'))).thenAnswer((_) async => items);

    // Fetch the data
    await store.fetch();

    // Pump the widget
    await tester.pumpWidget(
      buildTestWidget(
        child: InfiniteListWidget<int>(
          store: store,
          separatorBuilder: (context, index) => Divider(
            key: ValueKey('separator-$index'), // Custom key for clarity
          ),
          itemBuilder: (context, item) => Text(
            'Item: $item',
            key: ValueKey('item-$item'),
          ),
        ),
      ),
    );

    // Define the scrollable Finder
    final scrollableFinder = find.byType(Scrollable);

    // Verify each separator is present by scrolling
    for (int i = 0; i < items.length - 1; i++) {
      await tester.scrollUntilVisible(
        find.byKey(ValueKey('separator-$i')), // Find the separator
        50.0, // Scroll by 50 pixels
        scrollable: scrollableFinder,
      );

      expect(find.byKey(ValueKey('separator-$i')), findsOne);
    }
  });

  testWidgets('triggers data fetch when scrolled to end', (tester) async {
    final initialItems = List.generate(30, (i) => i);
    final additionalItems = List.generate(10, (i) => i + 30);

    // Mock the initial fetch to return the first 30 items
    when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
        .thenAnswer((_) async => initialItems);

    // Fetch the initial data
    await store.fetch();

    // Set the physical size of the tester view
    tester.view.physicalSize = const Size(300, 800);

    // Pump the widget
    await tester.pumpWidget(
      buildTestWidget(
        child: InfiniteListWidget<int>(
          store: store,
          itemBuilder: (context, item) => SizedBox(
            height: 100, // Ensure items are tall enough to require scrolling
            child: Text(
              'Item: $item',
              key: ValueKey('item-$item'),
            ),
          ),
        ),
      ),
    );

    // Mock the subsequent fetch to return 10 additional items
    when(() => mockFetcher(offset: 30, limit: any(named: 'limit'))).thenAnswer((_) async => additionalItems);

    final scrollableFinder = find.byType(Scrollable);

    // Scroll to the bottom of the list to trigger fetching additional items

    await tester.drag(scrollableFinder, const Offset(0, -3000));
    await tester.pumpAndSettle();

    // Verify the second fetch is triggered
    verify(() => mockFetcher(offset: 30, limit: any(named: 'limit'))).called(1);

    for (final item in additionalItems) {
      await tester.scrollUntilVisible(
        find.byKey(ValueKey('item-$item')), // Corrected key format
        100.0, // Scroll by 100 pixels to bring the item into view
        scrollable: scrollableFinder,
      );

      expect(find.byKey(ValueKey('item-$item')), findsOne);
    }
  });

  testWidgets('does not trigger fetch if hasReachedMax is true', (tester) async {
    final items = List.generate(20, (i) => i);

    // Mock the initial fetch to return the first 30 items
    when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit'))).thenAnswer((_) async => items);

    // Fetch the initial data
    await store.fetch();

    // Set the physical size of the tester view
    tester.view.physicalSize = const Size(300, 800);

    // Pump the widget
    await tester.pumpWidget(
      buildTestWidget(
        child: InfiniteListWidget<int>(
          store: store,
          itemBuilder: (context, item) => SizedBox(
            height: 100, // Ensure items are tall enough to require scrolling
            child: Text(
              'Item: $item',
              key: ValueKey('item-$item'),
            ),
          ),
        ),
      ),
    );

    final scrollableFinder = find.byType(Scrollable);

    // Scroll to the bottom of the list to trigger fetching additional items

    await tester.drag(scrollableFinder, const Offset(0, -2000));
    await tester.pumpAndSettle();

    // Verify the second fetch is triggered
    verify(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit'))).called(1);
  });
}
