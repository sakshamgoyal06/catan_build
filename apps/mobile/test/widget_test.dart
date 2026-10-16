import 'package:flutter_test/flutter_test.dart';
import 'package:hexwild/main.dart';

void main() {
  testWidgets('Hexwild home renders title', (tester) async {
    await tester.pumpWidget(const HexwildApp());
    expect(find.text('Hexwild'), findsOneWidget);
  });
}
