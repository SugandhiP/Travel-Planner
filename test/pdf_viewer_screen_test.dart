import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:travel_planner_project/itinerary/pdf_viewer_screen.dart';

void main() {
  group('PDFViewerScreen Tests', () {
    testWidgets('PDFViewerScreen renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PDFViewerScreen(pdfPath: 'assets/sample.pdf'),
        ),
      );

      // Check if the AppBar title is correct
      expect(find.text('View Itinerary'), findsOneWidget);

      // Check if PDFView widget exists
      expect(find.byType(PDFView), findsOneWidget);
    });

    testWidgets('PDFViewerScreen handles empty file path', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PDFViewerScreen(pdfPath: ''),
        ),
      );

      expect(find.byType(PDFView), findsOneWidget);
    });

    testWidgets('PDFViewerScreen has Scaffold, AppBar, and PDFView', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PDFViewerScreen(pdfPath: 'assets/sample.pdf'),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(PDFView), findsOneWidget);
    });

    testWidgets('PDFView widget loads with given pdfPath', (WidgetTester tester) async {
      const testPath = 'assets/sample.pdf';

      await tester.pumpWidget(
        MaterialApp(
          home: PDFViewerScreen(pdfPath: testPath),
        ),
      );

      final pdfViewFinder = find.byType(PDFView);
      expect(pdfViewFinder, findsOneWidget);
    });
  });
}
