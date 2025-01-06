import 'package:aks_internal/src/widget/cached_image/cached_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:octo_image/octo_image.dart';

class MockCachedNetworkImageProvider extends Mock implements CachedNetworkImageProvider {}

void main() {
  group('CachedImage Widget Tests', () {
    const imageUrl = 'https://example.com/image.jpg';

    testWidgets('Displays image when loaded', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: CachedImage(
            imageUrl: imageUrl,
          ),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(OctoImage), findsOneWidget);
      expect(find.byType(CachedNetworkImageProvider), findsNothing);
    });

    testWidgets('Shows placeholder while loading', (WidgetTester tester) async {
      // Arrange
      const placeholderKey = Key('placeholder');
      await tester.pumpWidget(
        MaterialApp(
          home: CachedImage(
            imageUrl: imageUrl,
            placeholderBuilder: (context) => const Center(
              key: placeholderKey,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byKey(placeholderKey), findsOneWidget);
    });

    testWidgets('Displays error widget on load failure', (WidgetTester tester) async {
      // Arrange
      const errorKey = Key('error');
      final cachedImageProvider = MockCachedNetworkImageProvider();
      when(() => cachedImageProvider.resolve(ImageConfiguration.empty)).thenThrow(Exception());

      await tester.pumpWidget(
        MaterialApp(
          home: CachedImage(
            imageUrl: 'https://invalid-url',
            cachedImageProvider: cachedImageProvider,
            errorBuilder: (context, error, stackTrace) => const Center(
              key: errorKey,
              child: Icon(Icons.error),
            ),
          ),
        ),
      );

      // Act
      await tester.pumpAndSettle(); // Wait for all initial async tasks
      await tester.pump(const Duration(seconds: 1)); // Add a small delay to ensure error handler triggers

      // Assert
      expect(find.byKey(errorKey), findsOneWidget);
    });

    testWidgets('Respects width and height parameters', (WidgetTester tester) async {
      // Arrange
      const width = 200.0;
      const height = 100.0;
      await tester.pumpWidget(
        const MaterialApp(
          home: CachedImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
          ),
        ),
      );

      // Assert
      final octoImage = tester.widget<OctoImage>(find.byType(OctoImage));
      expect(octoImage.width, equals(width));
      expect(octoImage.height, equals(height));
    });

    testWidgets('Applies BoxFit and color correctly', (WidgetTester tester) async {
      // Arrange
      const boxFit = BoxFit.cover;
      const color = Colors.red;
      await tester.pumpWidget(
        const MaterialApp(
          home: CachedImage(
            imageUrl: imageUrl,
            fit: boxFit,
            color: color,
          ),
        ),
      );

      // Assert
      final octoImage = tester.widget<OctoImage>(find.byType(OctoImage));
      expect(octoImage.fit, equals(boxFit));
      expect(octoImage.color, equals(color));
    });
  });
}
