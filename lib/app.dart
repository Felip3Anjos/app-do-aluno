import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobile/calendario.dart';
import 'package:mobile/config.dart';
import 'package:mobile/correcao_simulado_page.dart';
import 'package:mobile/mural.dart';
import 'package:mobile/pomodoro.dart';
import 'package:mobile/sobrenos.dart';
import 'package:mobile/theme_provider.dart';
import 'package:mobile/vestibulares_page.dart';
import 'package:mobile/vistas.dart';
import 'package:provider/provider.dart';
import 'package:mobile/tarefa.dart';
import 'package:mobile/usuario.dart';
import 'package:mobile/usuario_provider.dart';


class Mobile extends StatefulWidget {
  Mobile({super.key});

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  final TextEditingController _taskController = TextEditingController();

  List<Tarefa> _tasks = [];
  Usuario? _usuario;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final usuarioProvider = Provider.of<UsuarioProvider>(
      context,
      listen: false,
    );
    if (usuarioProvider.usuario != null && _usuario == null) {
      _usuario = usuarioProvider.usuario!;
      _carregarTarefas();
    }
  }

  String _getBaseUrl() {
    return 'http://localhost:8080/api';
  }

  Future<void> _carregarTarefas() async {
    if (_usuario == null) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      var url = Uri.parse(
        '${_getBaseUrl()}/tarefas/pendentes/usuario/${_usuario!.id}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _tasks = tarefaFromJson(response.body);
        });
      } else {
        throw Exception('Falha ao carregar tarefas.');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Erro de ligação.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _adicionarTarefa() async {
    if (_taskController.text.trim().isEmpty || _usuario == null) return;

    var url = Uri.parse('${_getBaseUrl()}/tarefas/usuario/${_usuario!.id}');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'titulo': _taskController.text.trim()}),
      );

      if (response.statusCode == 201) {
        _taskController.clear();
        _carregarTarefas();
      }
    } catch (e) {}
  }

  Future<void> _adicionarSubtarefa(Tarefa tarefa, String titulo) async {
    var url = Uri.parse('${_getBaseUrl()}/subtarefas/tarefa/${tarefa.id}');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'titulo': titulo}),
      );

      if (response.statusCode == 201) {
        _carregarTarefas();
      }
    } catch (e) {
      // Tratar erro
    }
  }

  Future<void> _concluirTarefa(int tarefaId) async {
    var url = Uri.parse('${_getBaseUrl()}/tarefas/$tarefaId/concluir');
    try {
      final response = await http.put(url);
      if (response.statusCode == 200) {
        _carregarTarefas();
      }
    } catch (e) {
      // Tratar erro
    }
  }

  Future<void> _concluirSubtarefa(int subtarefaId) async {
    var url = Uri.parse('${_getBaseUrl()}/subtarefas/$subtarefaId/concluir');
    try {
      final response = await http.put(url);
      if (response.statusCode == 200) {
        _carregarTarefas();
      }
    } catch (e) {
      // Tratar erro
    }
  }

  Future<void> _deletarTarefa(int tarefaId) async {
    var url = Uri.parse('${_getBaseUrl()}/tarefas/$tarefaId');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 204) {
        _carregarTarefas();
      }
    } catch (e) {
      // Tratar erro
    }
  }

  Future<void> _deletarSubtarefa(int subtarefaId) async {
    var url = Uri.parse('${_getBaseUrl()}/subtarefas/$subtarefaId');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 204) {
        _carregarTarefas();
      }
    } catch (e) {
      // Tratar erro
    }
  }

  void _navigateToVistas() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Vistas()),
    ).then((_) {
      _carregarTarefas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        title: Text(
          "App do Aluno",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Color.fromARGB(255, 0, 52, 80),
          ),
        ),
        elevation: 2.0,
        shadowColor: Colors.black,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      // CORRIGIDO: Usa o gradiente para consistência
                      gradient: LinearGradient(
                        colors: isDark
                            ? [Color(0xFF002F5A), Color(0xFF335D9B)]
                            : [
                                Color.fromARGB(255, 0, 52, 80),
                                Color(0xFF5B73FF),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 7,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Text(
                      'Olá, ${_usuario?.nomeUsuario ?? ""} !',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Início'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.task_alt_outlined),
                    title: Text('Vistas'),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToVistas();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('Calendario'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CalendarPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.comment_outlined),
                    title: Text('Mural'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Mural()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.timer_outlined),
                    title: Text('Pomodoro'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PomodoroPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.vertical_align_bottom_sharp),
                    title: Text('Simulados'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaginaProvasEnem(),
                        ),
                      );
                    },                   
                  ),
                    // Dentro do seu ListView em app.dart

ListTile(
  leading: Icon(Icons.edit_note), // Ícone de correção
  title: Text('Corrigir Simulados'),
  onTap: () {
    // Fecha o menu/drawer se estiver aberto
    Navigator.pop(context); 
    
    // Navega para a PÁGINA DE SELEÇÃO
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaginaSelecaoSimulado(),
      ),
    );
  },
),
                ],
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConfiguracaoPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.groups),
              title: Text('Sobre nós'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Sobrenos()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Color(0xFF002F5A), Color(0xFF335D9B)]
                : [Color.fromARGB(255, 0, 52, 80), Color(0xFF5B73FF)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            children: [
              Card(
                color: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _taskController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Qual a sua próxima tarefa?',
                          hintStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(
                                Icons.add,
                                color: isDark
                                    ? Colors.white
                                    : Color.fromARGB(255, 0, 38, 58),
                              ),
                              label: Text(
                                'Adicionar',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: _adicionarTarefa,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: isDark
                                    ? Colors.white
                                    : Color.fromARGB(255, 0, 38, 58),
                                backgroundColor: isDark
                                    ? Color(0xFF335D9B)
                                    : Color.fromARGB(255, 241, 117, 34),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(
                                Icons.visibility,
                                color: isDark
                                    ? Colors.white
                                    : Color.fromARGB(255, 0, 38, 58),
                              ),
                              label: Text(
                                'Vistas',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: _navigateToVistas,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: isDark
                                    ? Colors.white
                                    : Color.fromARGB(255, 0, 38, 58),
                                backgroundColor: isDark
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.blueGrey[200],
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : _tasks.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhuma tarefa pendente.\nAdicione uma acima!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          final task = _tasks[index];
                          final subController = TextEditingController();
                          return Card(
                            color: isDark
                                ? Color(0xFF1E1E2C)
                                : Colors.white.withOpacity(0.9),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              title: Row(
                                children: [
                                  Checkbox(
                                    value: task.isCompleted,
                                    activeColor: Color.fromARGB(
                                      255,
                                      241,
                                      117,
                                      34,
                                    ),
                                    onChanged: (val) {
                                      _concluirTarefa(task.id);
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      task.titulo,
                                      style: GoogleFonts.poppins(
                                        decoration: task.isCompleted
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        decorationColor: isDark
                                            ? Colors.white70
                                            : Colors.black54,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: task.isCompleted
                                            ? (isDark
                                                  ? Colors.white54
                                                  : Colors.black54)
                                            : (isDark
                                                  ? Colors.white
                                                  : Colors.black87),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red.withOpacity(0.8),
                                ),
                                onPressed: () {
                                  _deletarTarefa(task.id);
                                },
                              ),
                              children: [
                                Divider(
                                  color: isDark
                                      ? Colors.white24
                                      : Colors.black26,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                ...task.subtarefas.map((sub) {
                                  return ListTile(
                                    leading: Checkbox(
                                      value: sub.isCompleted,
                                      activeColor: Color.fromARGB(
                                        255,
                                        241,
                                        117,
                                        34,
                                      ),
                                      onChanged: (val) {
                                        _concluirSubtarefa(sub.id);
                                      },
                                    ),
                                    title: Text(
                                      sub.titulo,
                                      style: GoogleFonts.poppins(
                                        decoration: sub.isCompleted
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black87,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red.withOpacity(0.7),
                                      ),
                                      onPressed: () {
                                        _deletarSubtarefa(sub.id);
                                      },
                                    ),
                                  );
                                }).toList(),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: subController,
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Nova subtarefa',
                                            hintStyle: TextStyle(
                                              color: isDark
                                                  ? Colors.white54
                                                  : Colors.black54,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          color: isDark
                                              ? Color.fromARGB(
                                                  255,
                                                  241,
                                                  117,
                                                  34,
                                                )
                                              : Color.fromARGB(255, 0, 52, 80),
                                        ),
                                        onPressed: () {
                                          if (subController.text
                                              .trim()
                                              .isNotEmpty) {
                                            _adicionarSubtarefa(
                                              task,
                                              subController.text.trim(),
                                            );
                                            subController.clear();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
