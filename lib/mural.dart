import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mobile/theme_provider.dart';

class Mural extends StatefulWidget {
  const Mural({super.key});

  @override
  State<Mural> createState() => _MuralState();
}

class _MuralState extends State<Mural> {
  // Todas as funções de API e listas foram removidas
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Mural de Avisos',
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : const Color.fromARGB(255, 0, 52, 80),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF002F5A), const Color(0xFF335D9B)]
                : [
                    const Color.fromARGB(255, 0, 52, 80),
                    const Color(0xFF5B73FF),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // Apenas uma mensagem centralizada
        child: Center(
          child: Text(
            'Esta página ainda não está em uso.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white70, 
              fontSize: 18
            ),
          ),
        ),
      ),
    );
  }
}