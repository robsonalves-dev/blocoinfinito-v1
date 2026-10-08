import 'package:flutter_test/flutter_test.dart';

import 'package:blocoinfinito/main.dart';

void main() {
  testWidgets('Bloco Infinito inicia corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const BlocoInfinitoApp());

    expect(find.text('BLOCO INFINITO'), findsOneWidget);
    expect(find.text('JOGAR'), findsOneWidget);
    expect(find.text('RECORDE'), findsOneWidget);
    expect(find.text('CONFIGURAÇÕES'), findsOneWidget);
  });
}