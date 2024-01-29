import 'package:flutter_test/flutter_test.dart';
import 'package:todo/main.dart';
import 'package:todo/shared_preferences_util.dart';

void main() {
  testWidgets('Seu teste aqui', (WidgetTester tester) async {
    // Crie um objeto SharedPreferencesUtil para os testes
    SharedPreferencesUtil prefsUtil = SharedPreferencesUtil();
    await prefsUtil.init(); // Certifique-se de inicializar o objeto

    // Crie o widget MyApp passando o SharedPreferencesUtil
    await tester.pumpWidget(MyApp(prefsUtil: prefsUtil));

    // Agora, você pode testar o TodoListPage ou outras partes do seu aplicativo.

    // Por exemplo, se quiser testar o TodoListPage, você pode fazer algo assim:
    await tester
        .pump(); // Certifique-se de que todos os widgets foram construídos

    // Se você estiver testando um estado inicial específico, pode verificar widgets na tela, por exemplo:
    expect(find.text('Lista'), findsOneWidget);

    // Restante do seu teste...
  });
}
