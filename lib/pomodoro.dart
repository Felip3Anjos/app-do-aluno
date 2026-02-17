import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/pomodoro_provider.dart';
import 'package:mobile/theme_provider.dart';
import 'package:provider/provider.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context) {
    // A página agora 'ouve' as mudanças do PomodoroProvider
    final pomodoroProvider = Provider.of<PomodoroProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        // CORRIGIDO: Usa a cor do tema central
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 2.0,
        shadowColor: Colors.black,
        title: Text(
          "Cronômetro Pomodoro",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color.fromARGB(255, 0, 52, 80),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : const Color.fromARGB(255, 0, 52, 80)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // CORRIGIDO: Usa o mesmo gradiente e alinhamento do resto da aplicação
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF002F5A), const Color(0xFF335D9B)]
                : [const Color.fromARGB(255, 0, 52, 80), const Color(0xFF5B73FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- MOSTRADOR DO CRONÓMETRO ---
            SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: pomodoroProvider.progress, // Pega o progresso do provider
                    strokeWidth: 12,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      pomodoroProvider.currentSession == 'Foco' 
                        ? (isDark ? const Color(0xFFFACC15) : const Color.fromARGB(255, 241, 117, 34))
                        : (isDark ? Colors.greenAccent : Colors.green),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          pomodoroProvider.formatTime(pomodoroProvider.currentTimeInSeconds), // Pega o tempo do provider
                          style: GoogleFonts.poppins(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          pomodoroProvider.currentSession, // Pega a sessão do provider
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white70,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),

            // --- BOTÕES DE CONTROLO ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botão de Iniciar/Pausar
                ElevatedButton.icon(
                  icon: Icon(
                    pomodoroProvider.isRunning ? Icons.pause : Icons.play_arrow, // Pega o estado do provider
                    size: 32,
                    color: isDark ? Colors.white : const Color.fromARGB(255, 0, 38, 58),
                  ),
                  label: Text(
                    pomodoroProvider.isRunning ? 'PAUSAR' : 'INICIAR', // Pega o estado do provider
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isDark ? Colors.white : const Color.fromARGB(255, 0, 38, 58),
                    ),
                  ),
                  onPressed: pomodoroProvider.startPauseTimer, // Chama a função do provider
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF335D9B) : const Color.fromARGB(255, 241, 117, 34),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Botão de Reiniciar
                IconButton(
                  icon: const Icon(Icons.refresh, size: 32, color: Colors.white70),
                  onPressed: pomodoroProvider.resetTimer, // Chama a função do provider
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

