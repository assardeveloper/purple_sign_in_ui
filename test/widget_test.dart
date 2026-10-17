import 'package:flutter_test/flutter_test.dart';

import 'package:youtube_videos/main.dart';
import 'package:youtube_videos/sign_in_page.dart';

void main() {
  testWidgets('Sign in page loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(SignInPage), findsOneWidget);
  });
}
