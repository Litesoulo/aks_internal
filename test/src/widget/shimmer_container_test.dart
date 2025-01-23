import 'package:aks_internal/aks_internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

// Mock configuration for testing
AksAppConfig createMockConfig() {
  return AksAppConfig(
    appConstants: AksAppConstants(
      verticalSeparator: const SizedBox.shrink(),
      horizontalSeparator: const SizedBox.shrink(),
      borderRadius: 10,
      padding: 8,
      animationDuration: const Duration(seconds: 1),
    ),
  );
}

void main() {
  // Set up the mock configuration and initialize AksInternal once
  setUp(() {
    final mockConfig = createMockConfig();
    // Initialize the singleton with the mock config only once
    AksInternal(aksConfig: mockConfig); // This can be skipped if initialize() is automatically called by the factory.
  });

  // Test the ShimmerContainer widget
  testWidgets('ShimmerContainer renders with default values', (WidgetTester tester) async {
    // Build the ShimmerContainer widget with default values
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ShimmerContainer(),
      ),
    ));

    // Verify that a shimmer effect is visible
    expect(find.byType(Shimmer), findsOneWidget);

    // Check if the default background color is applied (primary color with reduced alpha)
    final shimmerContainer = tester.widget<ShimmerContainer>(find.byType(ShimmerContainer));
    expect(shimmerContainer.backgroundColor, null);

    // Check if the default duration is applied (1 second)
    final shimmer = tester.widget<Shimmer>(find.byType(Shimmer));
    expect(shimmer.period, const Duration(seconds: 1));
  });

  testWidgets('ShimmerContainer renders with custom values', (WidgetTester tester) async {
    // Build the ShimmerContainer with custom values
    const customWidth = 200.0;
    const customHeight = 100.0;
    const customBorderRadius = 15.0;
    const customBackgroundColor = Colors.red;
    const customBaseColor = Colors.blue;
    const customHighlightColor = Colors.green;
    const customPeriod = Duration(seconds: 2);

    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ShimmerContainer(
          width: customWidth,
          height: customHeight,
          borderRadius: customBorderRadius,
          backgroundColor: customBackgroundColor,
          baseColor: customBaseColor,
          highlightColor: customHighlightColor,
          period: customPeriod,
        ),
      ),
    ));

    // Verify if custom values are applied correctly
    final shimmerContainer = tester.widget<ShimmerContainer>(find.byType(ShimmerContainer));
    expect(shimmerContainer.width, customWidth);
    expect(shimmerContainer.height, customHeight);
    expect(shimmerContainer.borderRadius, customBorderRadius);
    expect(shimmerContainer.backgroundColor, customBackgroundColor);
    expect(shimmerContainer.baseColor, customBaseColor);
    expect(shimmerContainer.highlightColor, customHighlightColor);
    expect(shimmerContainer.period, customPeriod);

    // Check if the shimmer effect is visible
    expect(find.byType(Shimmer), findsOneWidget);
  });

  testWidgets('ShimmerContainer renders with child widget', (WidgetTester tester) async {
    // Build the ShimmerContainer with a custom child
    const child = Text('Shimmering text');
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ShimmerContainer(child: child),
      ),
    ));

    // Check if the child widget is rendered correctly
    expect(find.byWidget(child), findsOneWidget);
  });

  testWidgets('ShimmerContainer has correct border radius', (WidgetTester tester) async {
    const customBorderRadius = 20.0;

    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ShimmerContainer(
          borderRadius: customBorderRadius,
        ),
      ),
    ));

    // Verify the container's border radius
    final container = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    final borderRadius = container.decoration as BoxDecoration;
    expect(borderRadius.borderRadius?.resolve(TextDirection.ltr).topLeft, const Radius.circular(customBorderRadius));
  });
}
