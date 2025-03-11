import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:travel_planner_project/itinerary/image_viewer_screen.dart';

class MockFile extends Mock implements File {}

void main() {
  group('ImageViewerScreen Tests', () {
    late List<String> imagePaths;

    setUp(() {
      imagePaths = ['path1.jpg', 'path2.jpg', 'path3.jpg'];
    });

    testWidgets('displays correct number of images', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ImageViewerScreen(imagePaths: imagePaths),
      ));

      expect(find.byType(Image), findsNWidgets(imagePaths.length));
    });

    testWidgets('navigates to FullScreenImageViewer on tap', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ImageViewerScreen(imagePaths: imagePaths),
      ));

      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      expect(find.byType(FullScreenImageViewer), findsOneWidget);
    });
  });

  group('FullScreenImageViewer Tests', () {
    late List<String> imagePaths;

    setUp(() {
      imagePaths = ['path1.jpg', 'path2.jpg', 'path3.jpg'];
    });

    testWidgets('displays initial image index correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: FullScreenImageViewer(imagePaths: imagePaths, initialIndex: 1),
      ));

      expect(find.text('Image 2 of 3'), findsOneWidget);
    });

    testWidgets('swiping changes image index', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: FullScreenImageViewer(imagePaths: imagePaths, initialIndex: 0),
      ));

      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(find.text('Image 2 of 3'), findsOneWidget);
    });
  });
}
