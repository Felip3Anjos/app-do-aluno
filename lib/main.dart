// importa os pacotes necessários
import 'package:flutter/material.dart';
import 'package:mobile/inicio.dart';
import 'package:mobile/pomodoro_provider.dart';
import 'package:mobile/usuario_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile/theme_provider.dart';

// função principal, ponto de entrada da aplicação
void main() {
  runApp(
    // widget que provê múltiplos estados para a árvore de widgets abaixo dele
    MultiProvider(
      providers: [
        // provê o estado do tema (claro/escuro) para o app
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        // provê o estado do usuário (dados do usuário logado)
        ChangeNotifierProvider(create: (context) => UsuarioProvider()),
        // provê o estado do timer pomodoro
        ChangeNotifierProvider(create: (context) => PomodoroProvider()),
      ],
      // envolve o app com um widget que permite reiniciá-lo programaticamente
      child: RestartWidget(child: MyApp()),
    ),
  );
}

// widget personalizado para reiniciar o app
class RestartWidget extends StatefulWidget {
  final Widget child;
  const RestartWidget({Key? key, required this.child}) : super(key: key);

  // método estático que pode ser chamado de qualquer lugar para encontrar e acionar o reinício
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  // uma chave única que, ao ser trocada, força o flutter a reconstruir o widget
  Key key = UniqueKey();

  // função que atualiza a chave, causando a reconstrução (reinício) do app
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 'keyedsubtree' é reconstruído toda vez que a 'key' muda
    return KeyedSubtree(key: key, child: widget.child);
  }
}

// widget raiz da aplicação
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // 'ouve' as mudanças no themeprovider para reconstruir o app quando o tema mudar
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false, // remove a faixa de "debug" no canto
      title: 'app do aluno',
      // tema padrão para o modo claro
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // tema para o modo escuro
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 0, 52, 80),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // controla qual tema (claro, escuro ou do sistema) está ativo
      themeMode: themeProvider.themeMode,
      // define a tela inicial que será exibida ao abrir o app
      home: Inicial(),
    );
  }
}
 