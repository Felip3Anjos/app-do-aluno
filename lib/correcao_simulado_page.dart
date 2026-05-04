import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mobile/theme_provider.dart'; 

//ENEM 2024 - DIA 1 

const Map<int, String> gabaritoEnem2024_Dia1_Azul_Ingles = {
  1: 'C', 2: 'A', 3: 'A', 4: 'A', 5: 'E', 6: 'A', 7: 'E', 8: 'B', 9: 'B', 10: 'E',
  11: 'E', 12: 'D', 13: 'C', 14: 'C', 15: 'B', 16: 'D', 17: 'B', 18: 'D', 19: 'D', 20: 'D',
  21: 'E', 22: 'C', 23: 'C', 24: 'D', 25: 'C', 26: 'B', 27: 'E', 28: 'E', 29: 'A', 30: 'B',
  31: 'B', 32: 'B', 33: 'D', 34: 'D', 35: 'D', 36: 'D', 37: 'B', 38: 'B', 39: 'E', 40: 'A',
  41: 'D', 42: 'D', 43: 'E', 44: 'E', 45: 'B', 46: 'C', 47: 'E', 48: 'C', 49: 'E', 50: 'B',
  51: 'B', 52: 'E', 53: 'B', 54: 'D', 55: 'B', 56: 'D', 57: 'D', 58: 'D', 59: 'E', 60: 'B',
  61: 'B', 62: 'A', 63: 'C', 64: 'D', 65: 'C', 66: 'A', 67: 'E', 68: 'E', 69: 'C', 70: 'E',
  71: 'D', 72: 'A', 73: 'D', 74: 'B', 75: 'A', 76: 'E', 77: 'B', 78: 'E', 79: 'E', 80: 'A',
  81: 'D', 82: 'C', 83: 'E', 84: 'D', 85: 'A', 86: 'D', 87: 'A', 88: 'C', 89: 'B', 90: 'C',
};

const Map<int, String> gabaritoEnem2024_Dia1_Azul_Espanhol = {
  1: 'C', 2: 'D', 3: 'D', 4: 'D', 5: 'A', 6: 'A', 7: 'E', 8: 'B', 9: 'B', 10: 'E',
  11: 'E', 12: 'D', 13: 'C', 14: 'C', 15: 'B', 16: 'D', 17: 'B', 18: 'D', 19: 'D', 20: 'D',
  21: 'E', 22: 'C', 23: 'C', 24: 'D', 25: 'C', 26: 'B', 27: 'E', 28: 'E', 29: 'A', 30: 'B',
  31: 'B', 32: 'B', 33: 'D', 34: 'D', 35: 'D', 36: 'D', 37: 'B', 38: 'B', 39: 'E', 40: 'A',
  41: 'D', 42: 'D', 43: 'E', 44: 'E', 45: 'B', 46: 'C', 47: 'E', 48: 'C', 49: 'E', 50: 'B',
  51: 'B', 52: 'E', 53: 'B', 54: 'D', 55: 'B', 56: 'D', 57: 'D', 58: 'D', 59: 'E', 60: 'B',
  61: 'B', 62: 'A', 63: 'C', 64: 'D', 65: 'C', 66: 'A', 67: 'E', 68: 'E', 69: 'C', 70: 'E',
  71: 'D', 72: 'A', 73: 'D', 74: 'B', 75: 'A', 76: 'E', 77: 'B', 78: 'E', 79: 'E', 80: 'A',
  81: 'D', 82: 'C', 83: 'E', 84: 'D', 85: 'A', 86: 'D', 87: 'A', 88: 'C', 89: 'B', 90: 'C',
};

const Map<int, String> gabaritoEnem2024_Dia1_Amarelo_Ingles = {
  1: 'A', 2: 'A', 3: 'C', 4: 'E', 5: 'A', 6: 'E', 7: 'A', 8: 'C', 9: 'E', 10: 'B',
  11: 'C', 12: 'B', 13: 'D', 14: 'B', 15: 'E', 16: 'B', 17: 'D', 18: 'B', 19: 'D', 20: 'E',
  21: 'C', 22: 'C', 23: 'B', 24: 'E', 25: 'C', 26: 'C', 27: 'C', 28: 'A', 29: 'D', 30: 'B',
  31: 'D', 32: 'B', 33: 'E', 34: 'B', 35: 'C', 36: 'E', 37: 'B', 38: 'D', 39: 'C', 40: 'E',
  41: 'C', 42: 'E', 43: 'E', 44: 'D', 45: 'C', 46: 'D', 47: 'A', 48: 'D', 49: 'A', 50: 'B',
  51: 'D', 52: 'C', 53: 'C', 54: 'E', 55: 'C', 56: 'E', 57: 'D', 58: 'E', 59: 'B', 60: 'B',
  61: 'B', 62: 'E', 63: 'B', 64: 'C', 65: 'D', 66: 'C', 67: 'A', 68: 'D', 69: 'A', 70: 'C',
  71: 'B', 72: 'C', 73: 'D', 74: 'D', 75: 'C', 76: 'E', 77: 'B', 78: 'E', 79: 'A', 80: 'A',
  81: 'B', 82: 'A', 83: 'E', 84: 'C', 85: 'A', 86: 'E', 87: 'E', 88: 'C', 89: 'D', 90: 'A',
};

const Map<int, String> gabaritoEnem2024_Dia1_Amarelo_Espanhol = {
  1: 'D', 2: 'D', 3: 'D', 4: 'A', 5: 'C', 6: 'E', 7: 'A', 8: 'C', 9: 'E', 10: 'B',
  11: 'C', 12: 'B', 13: 'D', 14: 'B', 15: 'E', 16: 'B', 17: 'D', 18: 'B', 19: 'D', 20: 'E',
  21: 'C', 22: 'C', 23: 'B', 24: 'E', 25: 'C', 26: 'C', 27: 'C', 28: 'A', 29: 'D', 30: 'B',
  31: 'D', 32: 'B', 33: 'E', 34: 'B', 35: 'C', 36: 'E', 37: 'B', 38: 'D', 39: 'C', 40: 'E',
  41: 'C', 42: 'E', 43: 'E', 44: 'D', 45: 'C', 46: 'D', 47: 'A', 48: 'D', 49: 'A', 50: 'B',
  51: 'D', 52: 'C', 53: 'C', 54: 'E', 55: 'C', 56: 'E', 57: 'D', 58: 'E', 59: 'B', 60: 'B',
  61: 'B', 62: 'E', 63: 'B', 64: 'C', 65: 'D', 66: 'C', 67: 'A', 68: 'D', 69: 'A', 70: 'C',
  71: 'B', 72: 'C', 73: 'D', 74: 'D', 75: 'C', 76: 'E', 77: 'B', 78: 'E', 79: 'A', 80: 'A',
  81: 'B', 82: 'A', 83: 'E', 84: 'C', 85: 'A', 86: 'E', 87: 'E', 88: 'C', 89: 'D', 90: 'A',
};

// ENEM 2024 - DIA 2 

const Map<int, String> gabaritoEnem2024_Dia2_Azul = {
  91: 'B', 92: 'B', 93: 'E', 94: 'A', 95: 'A', 96: 'C', 97: 'D', 98: 'C', 99: 'D', 100: 'C',
  101: 'A', 102: 'B', 103: 'E', 104: 'D', 105: 'D', 106: 'D', 107: 'E', 108: 'B', 109: 'B', 110: 'D',
  111: 'D', 112: 'D', 113: 'E', 114: 'C', 115: 'C', 116: 'A', 117: 'E', 118: 'D', 119: 'B', 120: 'B',
  121: 'A', 122: 'A', 123: 'A', 124: 'C', 125: 'A', 126: 'A', 127: 'E', 128: 'C', 129: 'X', 130: 'C',
  131: 'B', 132: 'C', 133: 'C', 134: 'E', 135: 'D', 136: 'A', 137: 'A', 138: 'B', 139: 'A', 140: 'B',
  141: 'B', 142: 'A', 143: 'B', 144: 'D', 145: 'B', 146: 'B', 147: 'B', 148: 'C', 149: 'E', 150: 'C',
  151: 'E', 152: 'A', 153: 'B', 154: 'C', 155: 'E', 156: 'B', 157: 'C', 158: 'C', 159: 'C', 160: 'C',
  161: 'B', 162: 'A', 163: 'B', 164: 'C', 165: 'B', 166: 'B', 167: 'D', 168: 'A', 169: 'E', 170: 'E',
  171: 'A', 172: 'D', 173: 'C', 174: 'C', 175: 'D', 176: 'B', 177: 'B', 178: 'E', 179: 'C', 180: 'E',
};

const Map<int, String> gabaritoEnem2024_Dia2_Amarelo = {
  91: 'C', 92: 'A', 93: 'E', 94: 'D', 95: 'A', 96: 'A', 97: 'C', 98: 'C', 99: 'E', 100: 'E',
  101: 'A', 102: 'X', 103: 'A', 104: 'B', 105: 'C', 106: 'A', 107: 'E', 108: 'B', 109: 'B', 110: 'C',
  111: 'C', 112: 'A', 113: 'A', 114: 'D', 115: 'E', 116: 'C', 117: 'D', 118: 'B', 119: 'C', 120: 'E',
  121: 'C', 122: 'E', 123: 'C', 124: 'A', 125: 'A', 126: 'E', 127: 'D', 128: 'D', 129: 'D', 130: 'E',
  131: 'B', 132: 'B', 133: 'B', 134: 'D', 135: 'B', 136: 'C', 137: 'E', 138: 'C', 139: 'E', 140: 'B',
  141: 'E', 142: 'A', 143: 'D', 144: 'C', 145: 'C', 146: 'A', 147: 'D', 148: 'E', 149: 'D', 150: 'C',
  151: 'D', 152: 'B', 153: 'B', 154: 'C', 155: 'E', 156: 'B', 157: 'D', 158: 'C', 159: 'C', 160: 'C',
  161: 'A', 162: 'A', 163: 'B', 164: 'B', 165: 'A', 166: 'B', 167: 'B', 168: 'B', 169: 'A', 170: 'D',
  171: 'D', 172: 'D', 173: 'C', 174: 'E', 175: 'A', 176: 'D', 177: 'B', 178: 'B', 179: 'C', 180: 'E',
};

// MODELOS DE DADOS

class SimuladoDisponivel {
  final String nome;
  final Map<int, String> gabarito;
  SimuladoDisponivel({required this.nome, required this.gabarito});
}

class QuestaoResultado {
  final int numero;
  final String? respostaUsuario;
  final String respostaCorreta;

  // Se a resposta correta for 'X' (Anulada), considera como acerto.
  bool get acertou => respostaUsuario == respostaCorreta || respostaCorreta == 'X';

  QuestaoResultado({
    required this.numero,
    this.respostaUsuario,
    required this.respostaCorreta,
  });
}


//PÁGINA DE SELEÇÃO


class PaginaSelecaoSimulado extends StatelessWidget {
  const PaginaSelecaoSimulado({super.key});

  static final List<SimuladoDisponivel> simulados = [
    SimuladoDisponivel(
      nome: 'ENEM 2024 - 1º Dia, Azul (Inglês)',
      gabarito: gabaritoEnem2024_Dia1_Azul_Ingles,
    ),
    SimuladoDisponivel(
      nome: 'ENEM 2024 - 1º Dia, Azul (Espanhol)',
      gabarito: gabaritoEnem2024_Dia1_Azul_Espanhol,
    ),
     SimuladoDisponivel(
      nome: 'ENEM 2024 - 1º Dia, Amarelo (Inglês)',
      gabarito: gabaritoEnem2024_Dia1_Amarelo_Ingles,
    ),
    SimuladoDisponivel(
      nome: 'ENEM 2024 - 1º Dia, Amarelo (Espanhol)',
      gabarito: gabaritoEnem2024_Dia1_Amarelo_Espanhol,
    ),
    SimuladoDisponivel(
      nome: 'ENEM 2024 - 2º Dia, Azul',
      gabarito: gabaritoEnem2024_Dia2_Azul,
    ),
    SimuladoDisponivel(
      nome: 'ENEM 2024 - 2º Dia, Amarelo',
      gabarito: gabaritoEnem2024_Dia2_Amarelo,
    ),
  ];

  Map<String, List<SimuladoDisponivel>> _agruparSimulados() {
    final Map<String, List<SimuladoDisponivel>> grupos = {};
    for (final simulado in simulados) {
      // Define a chave do grupo (ex: "ENEM 2024 - 1º Dia")
      final chave = simulado.nome.contains('1º Dia')
          ? 'ENEM 2024 - 1º Dia'
          : 'ENEM 2024 - 2º Dia';
      
      if (grupos[chave] == null) {
        grupos[chave] = [];
      }
      grupos[chave]!.add(simulado);
    }
    return grupos;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final simuladosAgrupados = _agruparSimulados();
    final chavesDosGrupos = simuladosAgrupados.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selecionar Simulado',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
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
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: simuladosAgrupados.length,
          itemBuilder: (context, index) {
            final nomeDoGrupo = chavesDosGrupos[index];
            final itensDoGrupo = simuladosAgrupados[nomeDoGrupo]!;

            return Card(
              color: Colors.white.withOpacity(0.1),
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ExpansionTile(
                // Título principal do grupo
                title: Text(
                  nomeDoGrupo,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                leading: Icon(
                  nomeDoGrupo.contains('1º Dia') ? Icons.looks_one_outlined : Icons.looks_two_outlined,
                  color: Colors.white70,
                ),
                trailing: const Icon(
                  Icons.expand_more,
                  color: Colors.white70,
                ),
                // Filhos (os cadernos de prova) que aparecem ao expandir
                children: itensDoGrupo.map((simulado) {
                  // Extrai apenas o nome específico do caderno
                  final nomeCaderno = simulado.nome.replaceFirst('$nomeDoGrupo, ', '');

                  return ListTile(
                    contentPadding: const EdgeInsets.only(left: 30, right: 20, top: 4, bottom: 4),
                    title: Text(
                      'Caderno $nomeCaderno',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white70,
                      size: 16,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaginaGabaritoInput(
                            nomeSimulado: simulado.nome,
                            gabaritoOficial: simulado.gabarito,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}


//####################################################################
// 4. PÁGINA DE INPUT (TOTALMENTE REFORMULADA)
//####################################################################

class PaginaGabaritoInput extends StatefulWidget {
  final String nomeSimulado;
  final Map<int, String> gabaritoOficial;

  const PaginaGabaritoInput({
    super.key,
    required this.nomeSimulado,
    required this.gabaritoOficial,
  });

  @override
  State<PaginaGabaritoInput> createState() => _PaginaGabaritoInputState();
}

class _PaginaGabaritoInputState extends State<PaginaGabaritoInput> {
  final Map<int, String> _respostasUsuario = {};
  late final List<int> _numerosQuestoes;

  @override
  void initState() {
    super.initState();
    _numerosQuestoes = widget.gabaritoOficial.keys.toList()..sort();
  }

  void _corrigirSimulado() {
    List<QuestaoResultado> resultados = [];
    for (int numero in _numerosQuestoes) {
        resultados.add(
        QuestaoResultado(
          numero: numero,
          respostaUsuario: _respostasUsuario[numero],
          respostaCorreta: widget.gabaritoOficial[numero]!,
        ),
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaginaResultadoSimulado(
          nomeSimulado: widget.nomeSimulado,
          resultados: resultados,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nomeSimulado,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _corrigirSimulado,
        label: Text('Corrigir Prova', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.check_circle_outline_outlined),
        foregroundColor: const Color.fromARGB(255, 241, 117, 34),
      ),
      body: Container(
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
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 80), // Padding extra no final
          itemCount: _numerosQuestoes.length,
          itemBuilder: (context, index) {
            final questaoNum = _numerosQuestoes[index];
            final respostaSelecionada = _respostasUsuario[questaoNum];
            const List<String> alternativas = ['A', 'B', 'C', 'D', 'E'];

            return Card(
              color: Colors.black.withOpacity(0.15),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${questaoNum.toString().padLeft(3, '0')}.', // Ajustado para 3 dígitos
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const Spacer(),
                    ...alternativas.map((letra) {
                      final isSelected = respostaSelecionada == letra;
                      return GestureDetector(
                        onTap: () => setState(() => _respostasUsuario[questaoNum] = letra),
                        child: Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.green.withOpacity(0.8)
                                : Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.greenAccent : Colors.white24,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              letra,
                              style: GoogleFonts.poppins(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white54, size: 20),
                      onPressed: () => setState(() => _respostasUsuario.remove(questaoNum)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// PÁGINA DE RESULTADO
class PaginaResultadoSimulado extends StatelessWidget {
  final String nomeSimulado;
  final List<QuestaoResultado> resultados;

  const PaginaResultadoSimulado({
    super.key,
    required this.nomeSimulado,
    required this.resultados,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final int acertos = resultados.where((r) => r.acertou).length;
    final int total = resultados.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resultado',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'SEU DESEMPENHO',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$acertos / $total',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: total > 0 ? acertos / total : 0,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.lightGreenAccent,
                        ),
                        minHeight: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // LISTA DETALHADA DE QUESTÕES
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: resultados.length,
                itemBuilder: (context, index) {
                  final r = resultados[index];
                  bool isAnulada = r.respostaCorreta == 'X';

                  return Card(
                    color: Colors.white.withOpacity(0.05),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      //anulada
                      leading: Icon(
                        isAnulada ? Icons.info_outline : (r.acertou ? Icons.check_circle : Icons.cancel),
                        color: isAnulada ? Colors.amber : (r.acertou ? Colors.greenAccent : Colors.redAccent),
                      ),
                      // num da questao
                      title: Text(
                        'Questão ${r.numero}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // resp
                      subtitle: Text(
                        isAnulada
                          ? 'Questão Anulada (ponto atribuído)'
                          : r.respostaUsuario == null
                            ? 'Você deixou em branco. Correta: ${r.respostaCorreta}'
                            : 'Você marcou: ${r.respostaUsuario}. Correta: ${r.respostaCorreta}',
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}