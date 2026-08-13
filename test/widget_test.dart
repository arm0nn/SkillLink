import 'package:flutter_test/flutter_test.dart';
import 'package:skillink_app/main.dart';

void main() {
  testWidgets('shows the SkillLink landing experience', (tester) async {
    await tester.pumpWidget(const SkillLinkApp());
    expect(find.text('Get Started'), findsOneWidget);
  });
}
