import 'package:flutter_test/flutter_test.dart';
import 'package:hexwild/main.dart';

void main() {
  testWidgets('Hexwild home renders title', (tester) async {
    await tester.pumpWidget(const HexwildApp());
    expect(find.text('Hexwild'), findsOneWidget);
  });

  testWidgets('Play demo board opens table', (tester) async {
    await tester.pumpWidget(const HexwildApp());
    await tester.tap(find.text('Play demo board'));
    await tester.pumpAndSettle();
    expect(find.text('Demo expedition'), findsOneWidget);
  });
}
