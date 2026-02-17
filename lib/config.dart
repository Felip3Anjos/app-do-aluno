import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/main.dart';
import 'package:mobile/mudarSenha.dart';
import 'package:mobile/perfil.dart';
import 'package:mobile/pomodoro_provider.dart';
import 'package:mobile/usuario_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile/theme_provider.dart';

class ConfiguracaoPage extends StatefulWidget {
  ConfiguracaoPage({super.key});

  @override
  State<ConfiguracaoPage> createState() => _ConfiguracaoPageState();
}

class _ConfiguracaoPageState extends State<ConfiguracaoPage> {
  // desloga o usuário, e reseta tudo
  void _logout() {
    Provider.of<UsuarioProvider>(context, listen: false).logout();
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme(false);
    RestartWidget.restartApp(context);
  }

  // envia uma requisição à api para apagar todas as tarefas do usuário
  Future<void> _apagarTodasAsTarefas() async {
    final usuario = Provider.of<UsuarioProvider>(
      context,
      listen: false,
    ).usuario;
    if (usuario == null) return;

    try {
      final url = Uri.parse(
        'http://localhost:8080/api/tarefas/usuario/${usuario.id}',
      );
      // faz a chamada http do tipo delete
      final response = await http.delete(url);

      if (response.statusCode == 204) {
        // 'mounted' verifica se o widget ainda está na tela antes de mostrar a snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('todas as tarefas foram apagadas!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception('falha ao apagar tarefas');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('erro ao apagar tarefas.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // exibe o pop-up
  void _confirmarApagarTarefas() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("apagar todas as tarefas?"),
        content: const Text("Esta ação não pode ser desfeita. Tem a certeza?"),
        actions: [
          TextButton(
            child: const Text("cancelar"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("apagar", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
              _apagarTodasAsTarefas();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // obtém os providers para gerenciar o estado do tema e do pomodoro
    final themeProvider = Provider.of<ThemeProvider>(context);
    final pomodoroProvider = Provider.of<PomodoroProvider>(context);
    final isDark = themeProvider.isDarkMode;

    // define cores que mudam de acordo com o tema
    final Color sectionTitleColor = isDark
        ? const Color.fromARGB(255, 241, 117, 34)
        : const Color.fromARGB(255, 0, 52, 80);
    final Color tileColor = isDark ? const Color(0xFF1E1E2C) : Colors.white;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A192F)
          : const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: isDark
            ? const Color.fromARGB(255, 0, 38, 58)
            : Colors.white,
        elevation: 1,
        title: Text(
          "configurações",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color.fromARGB(255, 0, 52, 80),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : const Color.fromARGB(255, 0, 52, 80),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('conta', sectionTitleColor),
          _buildCard(tileColor, [
            _buildListTile(
              'editar perfil',
              Icons.person_outline,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PerfilPage()),
              ),
              isDark,
            ),
            _buildDivider(isDark),
            _buildListTile(
              'mudar senha',
              Icons.lock_outline,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MudarSenhaPage()),
              ),
              isDark,
            ),
          ]),

          SizedBox(height: 24),

          _buildSectionTitle('preferências', sectionTitleColor),
          _buildCard(tileColor, [
            SwitchListTile(
              title: Text(
                'modo escuro',
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              secondary: Icon(
                Icons.brightness_6_outlined,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              value: themeProvider.isDarkMode,
              // chama a função
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),
            _buildDivider(isDark),
            SwitchListTile(
              title: Text(
                'notificações sonoras',
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              secondary: Icon(
                Icons.notifications_outlined,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              value: pomodoroProvider.soundEnabled,
              onChanged: (value) {
                pomodoroProvider.toggleSound(value);
              },
            ),
          ]),
          const SizedBox(height: 24),

          //secção pomodoro
          _buildSectionTitle('pomodoro', sectionTitleColor),
          _buildCard(tileColor, [
            _buildSliderTile(
              'tempo de foco (min)',
              pomodoroProvider.focusDuration,
              5,
              60,
              (val) => pomodoroProvider.updateFocusDuration(val),
              isDark,
            ),
            _buildSliderTile(
              'pausa curta (min)',
              pomodoroProvider.shortBreakDuration,
              1,
              15,
              (val) => pomodoroProvider.updateShortBreakDuration(val),
              isDark,
            ),
            _buildSliderTile(
              'pausa longa (min)',
              pomodoroProvider.longBreakDuration,
              10,
              30,
              (val) => pomodoroProvider.updateLongBreakDuration(val),
              isDark,
            ),
          ]),
          const SizedBox(height: 24),

          // sessão dados
          _buildSectionTitle('gestão de dados', sectionTitleColor),
          _buildCard(tileColor, [
            _buildListTile(
              'apagar todas as tarefas',
              Icons.delete_sweep_outlined,
              _confirmarApagarTarefas,
              isDark,
              textColor: Colors.red,
            ),
          ]),
          const SizedBox(height: 40),

          // botão sair
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.logout, color: Colors.red),
              label: Text(
                'sair da conta',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _logout,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red.withOpacity(0.3)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // constrói o título de cada seção (ex: 'conta')
  Padding _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // constrói o container que agrupa os itens de uma seção
  Card _buildCard(Color cardColor, List<Widget> children) {
    return Card(
      color: cardColor,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(children: children),
    );
  }

  // constrói um item de lista clicável, usado para navegação
  ListTile _buildListTile(
    String title,
    IconData icon,
    VoidCallback onTap,
    bool isDark, {
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.white70 : Colors.black54),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: textColor ?? (isDark ? Colors.white : Colors.black87),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[600],
      ),
      onTap: onTap,
    );
  }

  // constrói a linha divisória entre os itens de lista
  Padding _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(
        height: 1,
        color: isDark ? Colors.white12 : Colors.grey[200],
      ),
    );
  }

  // faz o trem que desliza para ajustar valores
  Padding _buildSliderTile(
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              Text(
                '${value.round()} min',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            // define o número de passos
            divisions: (max - min).round(),
            label: value.round().toString(),
            onChanged: onChanged,
            activeColor: isDark
                ? const Color(0xFF335D9B)
                : const Color.fromARGB(255, 241, 117, 34),
          ),
        ],
      ),
    );
  }
}
