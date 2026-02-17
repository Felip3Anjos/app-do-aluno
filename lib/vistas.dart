// importa os pacotes necessários
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/theme_provider.dart';
import 'dart:convert';
import 'package:mobile/usuario_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile/tarefa.dart';
import 'package:mobile/usuario.dart';

// cria um widget com estado para a tela de histórico de atividades
class Vistas extends StatefulWidget {
  Vistas({Key? key}) : super(key: key);

  @override
  State<Vistas> createState() => _VistasState();
}

class _VistasState extends State<Vistas> {
  final TextEditingController _searchController = TextEditingController();

  Usuario? _usuario;
  // Listas separadas para os dados da API
  List<Tarefa> _tarefasConcluidas = [];
  List<Subtarefa> _subtarefasConcluidas = [];
  
  // Lista combinada para a interface
  List<dynamic> _itensDoHistorico = [];
  List<dynamic> _filteredItens = []; // Lista para ser exibida (já filtrada)
  
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterTasks);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    if (usuarioProvider.usuario != null && _usuario == null) {
      _usuario = usuarioProvider.usuario!;
      _carregarHistorico();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  String _getBaseUrl() {
    return 'http://localhost:8080/api';
  }

  // --- LÓGICA DE CARREGAMENTO ATUALIZADA ---
  Future<void> _carregarHistorico() async {
    if (_usuario == null) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Passo 1: Buscar as Tarefas Principais Concluídas
      var urlTarefas = Uri.parse('${_getBaseUrl()}/tarefas/concluidas/usuario/${_usuario!.id}');
      final responseTarefas = await http.get(urlTarefas);
      if (responseTarefas.statusCode == 200) {
        _tarefasConcluidas = tarefaFromJson(responseTarefas.body);
      } else {
        throw Exception('Falha ao carregar tarefas concluídas.');
      }

      // Passo 2: Buscar as Subtarefas Concluídas
      var urlSubtarefas = Uri.parse('${_getBaseUrl()}/subtarefas/concluidas/usuario/${_usuario!.id}');
      final responseSubtarefas = await http.get(urlSubtarefas);
      if (responseSubtarefas.statusCode == 200) {
         // Usa a função 'subtarefaFromJson' do seu ficheiro tarefa.dart
         _subtarefasConcluidas = subtarefaFromJson(responseSubtarefas.body);
      } else {
        throw Exception('Falha ao carregar subtarefas concluídas.');
      }

      // Passo 3: Combinar as duas listas numa só para a UI
      setState(() {
        _itensDoHistorico = [..._tarefasConcluidas, ..._subtarefasConcluidas];
        _filterTasks(); // Aplica o filtro inicial
      });

    } catch (e) {
      print(e); // Imprime o erro no terminal
      setState(() {
        _errorMessage = 'Erro de ligação ao carregar o histórico.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  // --- FIM DA LÓGICA DE CARREGAMENTO ---

  // Filtra a lista combinada
  void _filterTasks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      // Filtra a lista 'master'
      _filteredItens = _itensDoHistorico.where((item) {
        if (item is Tarefa) {
          return item.titulo.toLowerCase().contains(query) ||
                 item.subtarefas.any((sub) => sub.titulo.toLowerCase().contains(query));
        } else if (item is Subtarefa) {
          return item.titulo.toLowerCase().contains(query);
        }
        return false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 2.0,
        shadowColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'pesquisar tarefas...',
                  hintStyle: GoogleFonts.poppins(
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                  border: InputBorder.none,
                ),
                cursorColor: Color.fromARGB(255, 241, 117, 34),
              )
            : Text(
                "Atividades Vistas",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Color.fromARGB(255, 0, 52, 80),
                ),
              ),
               centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Color(0xFF002F5A), Color(0xFF335D9B)]
                : [
                    Color.fromARGB(255, 0, 52, 80),
                    Color(0xFF5B73FF),
                  ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : _errorMessage.isNotEmpty
                ? Center(
                    child:
                        Text(_errorMessage, style: TextStyle(color: Colors.red)))
                : _filteredItens.isEmpty // Usa a lista filtrada
                    ? Center(
                        child: Text(
                          _isSearching
                              ? 'nenhuma tarefa encontrada'
                              : 'o seu histórico está vazio.',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        itemCount: _filteredItens.length, // Usa a lista filtrada
                        itemBuilder: (context, index) {
                          final item = _filteredItens[index];

                          // --- LÓGICA DE VISUALIZAÇÃO ATUALIZADA ---
                          if (item is Tarefa) {
                            // Se for uma Tarefa principal, mostra o ExpansionTile
                            return _buildTarefaCard(item, isDark);
                          } else if (item is Subtarefa) {
                            // Se for uma Subtarefa individual, mostra um ListTile simples
                            return _buildSubtarefaCard(item, isDark);
                          }
                          return Container();
                        },
                      ),
      ),
    );
  }

  // Widget para construir o cartão de uma Tarefa principal concluída
  Widget _buildTarefaCard(Tarefa task, bool isDark) {
    return Card(
      color: isDark ? Color(0xFF1E1E2C) : Colors.white.withOpacity(0.9),
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          task.titulo,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
            decorationColor: isDark ? Colors.white70 : Colors.black54,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
        children: [
          Divider(
              color: isDark ? Colors.white24 : Colors.black26,
              indent: 16,
              endIndent: 16),
          ...task.subtarefas.map((sub) {
            return ListTile(
              title: Text(
                sub.titulo,
                style: GoogleFonts.poppins(
                  decoration: sub.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                  decorationColor: isDark ? Colors.white70 : Colors.black54,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // Widget para construir o cartão de uma Subtarefa individual concluída
  Widget _buildSubtarefaCard(Subtarefa sub, bool isDark) {
    return Card(
      color: isDark ? Color(0xFF1E1E2C).withOpacity(0.6) : Colors.white.withOpacity(0.7),
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(Icons.subdirectory_arrow_right, color: isDark ? Colors.white54 : Colors.black54),
        title: Text(
          sub.titulo,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.lineThrough,
            decorationColor: isDark ? Colors.white70 : Colors.black54,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
      ),
    );
  }
}