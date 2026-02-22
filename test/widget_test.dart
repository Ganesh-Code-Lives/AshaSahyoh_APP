import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:asha_sahyog/main.dart';

void main() {
  testWidgets('App shows login screen when not logged in', (WidgetTester tester) async {
    // Build the app with a user who is not logged in
    await tester.pumpWidget(
      const MyApp(
        hasCompletedProfile: false,
        isLoggedIn: false,
      ),
    );

    // Verify that the login prompt or related UI is visible
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('App shows home screen when logged in and profile completed', (WidgetTester tester) async {
    // Build the app with a user who is logged in and has completed profile
    await tester.pumpWidget(
      const MyApp(
        hasCompletedProfile: true,
        isLoggedIn: true,
      ),
    );

    // Verify that the home screen loads (replace with actual text from your home screen)
    expect(find.text('Asha Sahyog'), findsOneWidget);
  });

  testWidgets('App shows profile completion prompt when logged in but profile incomplete', (WidgetTester tester) async {
    // Build the app with a user who is logged in but has not completed profile
    await tester.pumpWidget(
      const MyApp(
        hasCompletedProfile: false,
        isLoggedIn: true,
      ),
    );

    // Verify that the profile completion prompt is visible (replace with actual text from your UI)
    expect(find.text('Complete your profile'), findsOneWidget);
  });
}
