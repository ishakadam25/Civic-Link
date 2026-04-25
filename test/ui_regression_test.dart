import 'package:civiclink_mumbai/screens/admin/add_announcement_screen.dart';
import 'package:civiclink_mumbai/screens/citizen/bills_screen.dart';
import 'package:civiclink_mumbai/screens/citizen/home_screen.dart';
import 'package:civiclink_mumbai/screens/citizen/tourist_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home screen renders quick actions and cards', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen(role: 'user')));
    expect(find.text('CivicLink Mumbai'), findsOneWidget);
    expect(find.text('Chat Assistant'), findsOneWidget);
    expect(find.text('Tourist Spots'), findsOneWidget);
  });

  testWidgets('Bills screen shows payment categories', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: BillsScreen()));
    expect(find.text('Electricity'), findsOneWidget);
    expect(find.text('Mobile Recharge'), findsOneWidget);
  });

  testWidgets('Tourist spots screen shows search input', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TouristPlaceScreen()));
    expect(find.byIcon(Icons.search), findsWidgets);
    expect(find.text('Explore Mumbai'), findsOneWidget);
  });

  testWidgets('Announcement screen has title and area selector', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddAnnouncementScreen()));
    expect(find.text('Headline'), findsOneWidget);
    expect(find.text('Targeted area'), findsOneWidget);
  });
}
