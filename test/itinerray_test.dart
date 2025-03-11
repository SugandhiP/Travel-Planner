import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/database/database.dart';
import 'package:travel_planner_project/database/travel_details_dao.dart';
import 'package:travel_planner_project/itinerary/itineraries_home_page.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:mockito/annotations.dart';
import 'itineraries_home_page_test.mocks.dart';

@GenerateMocks([AppDatabase, TravelDetailsDao])
void main() {
  late MockAppDatabase mockDatabase;
  late MockTravelDetailsDao mockTravelDetailsDao;

  setUp(() {
    mockDatabase = MockAppDatabase();
    mockTravelDetailsDao = MockTravelDetailsDao();
    when(mockDatabase.travelDetailsDao).thenReturn(mockTravelDetailsDao);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Provider<AppDatabase>.value(
        value: mockDatabase,
        child: ItinerariesHomePage(),
      ),
    );
  }

  testWidgets('Displays itinerrais not available when list is empty', (WidgetTester tester) async {
    when(mockTravelDetailsDao.getAllTravelDetails()).thenAnswer((_) async => []);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text("No itineraries available"), findsOneWidget);
  });

  testWidgets('Displays travel itinerary list in the home page', (WidgetTester tester) async {
    final travelDetailsList = [
      TravelDetails(
        id: 1,
        name: "Vacation",
        source: "New York",
        destination: "Paris",
        departureTime: "2025-05-01T10:00:00",
        arrivalTime: "2025-05-01T18:00:00",
        airline: "Air France",
        flightNumber: "AF123",
        hotelName: "Eiffel Hotel",
        initialBudget: 2000,
        tripMember: 2,
        selectedAttractions: ["Eiffel Tower"],
        imagePaths: [],
        isFavorite: false,
        pdfPath: null, expenses: [],
      ),
    ];

    when(mockTravelDetailsDao.getAllTravelDetails()).thenAnswer((_) async => travelDetailsList);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text("Vacation"), findsOneWidget);
    expect(find.text("Paris"), findsOneWidget);
  });

  testWidgets('Working of toggle for TFavourite status', (WidgetTester tester) async {
    final travelDetail = TravelDetails(
      id: 1,
      name: "Vacation",
      source: "New York",
      destination: "Paris",
      departureTime: "2025-05-01T10:00:00",
      arrivalTime: "2025-05-01T18:00:00",
      airline: "Air France",
      flightNumber: "AF123",
      hotelName: "Eiffel Hotel",
      initialBudget: 2000,
      tripMember: 2,
      selectedAttractions: ["Eiffel Tower"],
      imagePaths: [],
      isFavorite: false,
      pdfPath: null, expenses: [],
    );

    when(mockTravelDetailsDao.getAllTravelDetails()).thenAnswer((_) async => [travelDetail]);
    when(mockTravelDetailsDao.deleteTravelDetail(any)).thenAnswer((_) async {});
    when(mockTravelDetailsDao.insertTravelDetail(any)).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byIcon(Icons.star_border), findsOneWidget);
    await tester.tap(find.byIcon(Icons.star_border));
    await tester.pump();

    verify(mockTravelDetailsDao.deleteTravelDetail(travelDetail.name)).called(1);
    verify(mockTravelDetailsDao.insertTravelDetail(any)).called(1);
  });

  testWidgets('Deletes an itinerary', (WidgetTester tester) async {
    final travelDetail = TravelDetails(
      id: 1,
      name: "Vacation",
      source: "New York",
      destination: "Paris",
      departureTime: "2025-05-01T10:00:00",
      arrivalTime: "2025-05-01T18:00:00",
      airline: "Air France",
      flightNumber: "AF123",
      hotelName: "Eiffel Hotel",
      initialBudget: 2000,
      tripMember: 2,
      selectedAttractions: ["Eiffel Tower"],
      imagePaths: [],
      isFavorite: false,
      pdfPath: null, expenses: [],
    );

    when(mockTravelDetailsDao.getAllTravelDetails()).thenAnswer((_) async => [travelDetail]);
    when(mockTravelDetailsDao.deleteTravelDetail(travelDetail.name)).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text("Vacation"), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    verify(mockTravelDetailsDao.deleteTravelDetail(travelDetail.name)).called(1);
  });




  testWidgets('Views PDF when it is already created', (WidgetTester tester) async {
    final travelDetail = TravelDetails(
      id: 1,
      name: "Vacation",
      source: "New York",
      destination: "Paris",
      departureTime: "2025-05-01T10:00:00",
      arrivalTime: "2025-05-01T18:00:00",
      airline: "Air France",
      flightNumber: "AF123",
      hotelName: "Eiffel Hotel",
      initialBudget: 2000,
      tripMember: 2,
      selectedAttractions: ["Eiffel Tower"],
      imagePaths: [],
      isFavorite: false,
      pdfPath: "/path/to/existing.pdf", expenses: [],
    );

    when(mockTravelDetailsDao.getAllTravelDetails()).thenAnswer((_) async => [travelDetail]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text("View PDF"), findsOneWidget);

    await tester.tap(find.text("View PDF"));
    await tester.pumpAndSettle();
    expect(find.text("View PDF"), findsNothing);
  });


  testWidgets('Navigates to ItineraryTravelDetailsPage if new itinerary is added', (WidgetTester tester) async {
    when(mockTravelDetailsDao.getAllTravelDetails()).thenAnswer((_) async => []);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text("New Itinerary"), findsNothing);
  });

  testWidgets('Navigates to itinerary details view', (WidgetTester tester) async {
    final travelDetail = TravelDetails(
      id: 1,
      name: "Vacation",
      source: "New York",
      destination: "Paris",
      departureTime: "2025-05-01T10:00:00",
      arrivalTime: "2025-05-01T18:00:00",
      airline: "Air France",
      flightNumber: "AF123",
      hotelName: "Eiffel Hotel",
      initialBudget: 2000,
      tripMember: 2,
      selectedAttractions: ["Eiffel Tower"],
      imagePaths: [],
      isFavorite: false,
      pdfPath: null, expenses: [],
    );

    when(mockTravelDetailsDao.getAllTravelDetails()).thenAnswer((_) async => [travelDetail]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byIcon(Icons.remove_red_eye), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove_red_eye));
    await tester.pumpAndSettle();

    expect(find.text("View Itinerary"), findsNothing);
  });


  testWidgets('Ensuring all UI elements in the detail page  are rendered properly', (WidgetTester tester) async {
    when(mockTravelDetailsDao.getAllTravelDetails()).thenAnswer((_) async => []);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text("Your Itineraries"), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Handling PDF generation if it fails', (WidgetTester tester) async {
    final travelDetail = TravelDetails(
      id: 1,
      name: "Vacation",
      source: "New York",
      destination: "Paris",
      departureTime: "2025-05-01T10:00:00",
      arrivalTime: "2025-05-01T18:00:00",
      airline: "Air France",
      flightNumber: "AF123",
      hotelName: "Eiffel Hotel",
      initialBudget: 2000,
      tripMember: 2,
      selectedAttractions: ["Eiffel Tower"],
      imagePaths: [],
      isFavorite: false,
      pdfPath: null, expenses: [],
    );

    when(mockTravelDetailsDao.getAllTravelDetails()).thenAnswer((_) async => [travelDetail]);
    when(mockTravelDetailsDao.updateTravelDetail(any)).thenThrow(Exception("PDF generation failed"));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    await tester.tap(find.text("Generate PDF"));
    await tester.pumpAndSettle();

    expect(find.text("Error generating PDF"), findsNothing);
  });

}
