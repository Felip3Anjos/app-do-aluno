// ignore_for_file: directives_ordering
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

// Imports que já estavam
import 'package:mobile/evento.dart';
import 'package:mobile/usuario.dart';
import 'package:mobile/usuario_provider.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _currentDate = DateTime.now();
  Usuario? _usuario;

  // Variáveis do Calendário
  List<Evento> _eventos = [];
  List<String> months = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];

  // --- VARIÁVEIS DO MURAL (MOVIDAS PARA CÁ) ---
  List<Evento> _avisos = []; // armazena os avisos filtrados
  String _errorMessage = ''; // armazena mensagens de erro
  bool _isLoading = true; // Controla os dois (calendário e mural)

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    if (usuarioProvider.usuario != null && _usuario == null) {
      _usuario = usuarioProvider.usuario!;
      _carregarEventosEMural(); // Nome da função atualizado
    }
  }

  String _getBaseUrl() => 'http://localhost:8080/api';

  // --- FUNÇÃO _carregarEventos ATUALIZADA (COM LÓGICA DO MURAL) ---
  Future<void> _carregarEventosEMural() async {
    if (_usuario == null) return;
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Reseta o erro
    });

    try {
      final url = Uri.parse('${_getBaseUrl()}/eventos/usuario/${_usuario!.id}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final todosOsEventos = eventoFromJson(response.body);

        // --- LÓGICA DO MURAL (FILTRAGEM) ---
        final agora = DateTime.now();
        final hoje = DateTime(agora.year, agora.month, agora.day);
        final limite = hoje.add(const Duration(days: 30));

        final avisosFiltrados = todosOsEventos.where((evento) {
          final dataDoEvento = DateTime(
              evento.dataEvento.year, evento.dataEvento.month, evento.dataEvento.day);
          return dataDoEvento.isAfter(hoje.subtract(const Duration(days: 1))) &&
              dataDoEvento.isBefore(limite);
        }).toList();

        // Ordena os avisos filtrados por data
        avisosFiltrados.sort((a, b) => a.dataEvento.compareTo(b.dataEvento));
        // --- FIM DA LÓGICA DO MURAL ---

        setState(() {
          _eventos = todosOsEventos; // Para o calendário
          _avisos = avisosFiltrados; // Para a lista do mural
        });

      } else {
        setState(() {
          _errorMessage = 'Falha ao carregar eventos.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro de conexão.';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Função _salvarEvento (sem mudanças)
  Future<void> _salvarEvento(DateTime data, String titulo) async {
    if (_usuario == null || titulo.isEmpty) return;
    try {
      final url = Uri.parse('${_getBaseUrl()}/eventos/usuario/${_usuario!.id}');
      await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'titulo': titulo,
          // Corrigido para 'dataEvento' ou o que sua API esperar
          'data': DateFormat('yyyy-MM-dd').format(data), 
        }),
      );
      _carregarEventosEMural(); // Recarrega ambos
    } catch (e) {
      // Tratar erro
    }
  }

  // Função _showAnnotationDialog (sem mudanças)
  void _showAnnotationDialog(int day) {
    final dataSelecionada = DateTime(_currentDate.year, _currentDate.month, day);
    final eventoExistente = _eventos.firstWhere(
        (ev) => DateUtils.isSameDay(ev.dataEvento, dataSelecionada),
        orElse: () => Evento(id: 0, titulo: '', dataEvento: dataSelecionada));

    TextEditingController controller =
        TextEditingController(text: eventoExistente.titulo);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text('Anotações para o dia $day', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          maxLines: 4,
          style: GoogleFonts.poppins(),
          decoration: const InputDecoration(
            hintText: 'Digite sua anotação...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              _salvarEvento(dataSelecionada, controller.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Anotação para o dia $day salva!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 241, 117, 34),
              foregroundColor: const Color.fromARGB(255, 0, 38, 58),
            ),
            child: Text('Salvar', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Funções do calendário (sem mudanças)
  void _prevMonth() { setState(() { _currentDate = DateTime(_currentDate.year, _currentDate.month - 1); }); }
  void _nextMonth() { setState(() { _currentDate = DateTime(_currentDate.year, _currentDate.month + 1); }); }
  int _getDaysInMonth(int month, int year) { return DateTime(year, month + 1, 0).day; }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Calendário e Avisos', // Título atualizado
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color.fromARGB(255, 0, 52, 80),
          ),
        ),
        centerTitle: true,
        elevation: 2.0,
        shadowColor: Colors.black,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity, // Garante que o gradiente cubra tudo
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF002F5A), const Color(0xFF335D9B)]
                : [const Color.fromARGB(255, 0, 52, 80), const Color(0xFF5B73FF)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        // O Center foi removido para que o Column possa expandir
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Padding que substitui o margin
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2C) : Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            // Seção principal de carregamento ou erro
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: isDark ? Colors.white : const Color.fromARGB(255, 0, 52, 80)))
                : _errorMessage.isNotEmpty
                    ? Center(
                        child: Text(_errorMessage,
                            style: const TextStyle(color: Colors.red, fontSize: 16)))
                    : Column(
                        // O Column agora é o filho principal
                        children: [
                          // 1. SEÇÃO DO CALENDÁRIO
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _prevMonth,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark ? const Color(0xFF335D9B) : const Color.fromARGB(255, 241, 117, 34),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text('< Anterior',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : const Color.fromARGB(255, 0, 38, 58))),
                              ),
                              Text(
                                '${months[_currentDate.month - 1]} ${_currentDate.year}',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _nextMonth,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark ? const Color(0xFF335D9B) : const Color.fromARGB(255, 241, 117, 34),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text('Próximo >',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : const Color.fromARGB(255, 0, 38, 58))),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            shrinkWrap: true, // Importante para estar dentro de um Column
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 7 + 42, // Dias da semana + células
                            itemBuilder: (context, index) {
                              // Header (Dom, Seg, Ter...)
                              if (index < 7) {
                                final weekDays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
                                return Center(
                                  child: Text(
                                    weekDays[index],
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.grey[700],
                                    ),
                                  ),
                                );
                              }

                              // Células dos dias
                              final dayIndex = index - 7;
                              int firstWeekdayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1).weekday % 7;
                              int daysInMonth = _getDaysInMonth(_currentDate.month, _currentDate.year);
                              int dayNum = dayIndex - firstWeekdayOfMonth + 1;

                              if (dayIndex < firstWeekdayOfMonth || dayNum > daysInMonth) {
                                return Container(); // Célula vazia
                              } else {
                                final dataAtual = DateTime(_currentDate.year, _currentDate.month, dayNum);
                                bool hasAnnotation = _eventos.any((ev) => DateUtils.isSameDay(ev.dataEvento, dataAtual));

                                return GestureDetector(
                                  onTap: () => _showAnnotationDialog(dayNum),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF2C2C3C) : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                      border: hasAnnotation
                                          ? const Border(
                                              bottom: BorderSide(
                                                color: Color.fromARGB(255, 241, 117, 34),
                                                width: 3,
                                              ),
                                            )
                                          : null,
                                    ),
                                    child: Text('$dayNum',
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: isDark ? Colors.white : Colors.black87)),
                                  ),
                                );
                              }
                            },
                          ),

                          // --- 2. SEÇÃO DO MURAL DE AVISOS ---
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
                            child: Text(
                              'Próximos 30 Dias',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),

                          // Se não houver avisos...
                          if (_avisos.isEmpty)
                            Center(
                              child: Text(
                                'Nenhum aviso para os próximos 30 dias.',
                                style: GoogleFonts.poppins(
                                    color: isDark ? Colors.white70 : Colors.grey[600],
                                    fontSize: 16),
                              ),
                            ),

                          // Se houver avisos, mostra a lista
                          // O 'Expanded' faz a lista ocupar o espaço restante
                          if (_avisos.isNotEmpty)
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero, // Padding já foi dado
                                itemCount: _avisos.length,
                                itemBuilder: (context, index) {
                                  final aviso = _avisos[index];
                                  final diasRestantes =
                                      aviso.dataEvento.difference(DateTime.now()).inDays;

                                  // Card do Mural (copiado da pág. Mural)
                                  return Card(
                                    color: Colors.white.withOpacity(0.1),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.orange.withOpacity(0.8),
                                        child: Text(
                                          '${diasRestantes + 1}',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      title: Text(aviso.titulo,
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                      subtitle: Text(
                                        'Faltam ${diasRestantes + 1} dias - ${DateFormat('dd/MM/yyyy').format(aviso.dataEvento)}',
                                        style:
                                            GoogleFonts.poppins(color: Colors.white70),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}