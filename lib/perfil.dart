import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/usuario_provider.dart';
import 'package:mobile/theme_provider.dart';
import 'package:mobile/usuario.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  // Controladores para gerir o texto nos campos de edição
  late TextEditingController _nomeUsuarioController;
  late TextEditingController _emailController;
  late TextEditingController _nomeCompletoController;
  late TextEditingController _telefoneController;

  int? _tarefasPendentesCount;
  int? _tarefasConcluidasCount;
  bool _isLoadingStats = true;
  bool _isLoadingSave = false; // Estado de carregamento para o botão Salvar

  @override
  void initState() {
    super.initState();
    // Inicializa os controladores
    _nomeUsuarioController = TextEditingController();
    _emailController = TextEditingController();
    _nomeCompletoController = TextEditingController();
    _telefoneController = TextEditingController();

    // Preenche os campos com os dados do utilizador assim que a página é construída
    final usuario = Provider.of<UsuarioProvider>(
      context,
      listen: false,
    ).usuario;
    if (usuario != null) {
      _nomeUsuarioController.text = usuario.nomeUsuario;
      _emailController.text = usuario.email;
      _nomeCompletoController.text = usuario.nomeCompleto ?? '';
      _telefoneController.text = usuario.telefone ?? '';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carregarContagemTarefas();
  }

  @override
  void dispose() {
    // Libera a memória dos controladores quando a página é fechada
    _nomeUsuarioController.dispose();
    _emailController.dispose();
    _nomeCompletoController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  // --- FUNÇÃO PARA SALVAR AS ALTERAÇÕES ---
  Future<void> _salvarAlteracoes() async {
    final usuarioProvider = Provider.of<UsuarioProvider>(
      context,
      listen: false,
    );
    final usuario = usuarioProvider.usuario;

    if (usuario == null) return;

    setState(() => _isLoadingSave = true);

    try {
      var url = Uri.parse('http://localhost:8080/api/usuarios/${usuario.id}');

      // Atualiza o objeto 'usuario' local com os novos dados dos campos de texto
      usuario.nomeUsuario = _nomeUsuarioController.text;
      usuario.email = _emailController.text;
      usuario.nomeCompleto = _nomeCompletoController.text;
      usuario.telefone = _telefoneController.text;

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(
          usuario.toJson(),
        ), // Envia o objeto atualizado como JSON
      );

      if (response.statusCode == 200) {
        // Atualiza o utilizador no Provider para que toda a app veja as mudanças
        usuarioProvider.setUsuario(Usuario.fromJson(jsonDecode(response.body)));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingSave = false);
      }
    }
  }

  Future<void> _carregarContagemTarefas() async {
    final usuario = Provider.of<UsuarioProvider>(
      context,
      listen: false,
    ).usuario;
    if (usuario == null) {
      setState(() => _isLoadingStats = false);
      return;
    }

    try {
      const baseUrl = 'http://localhost:8080/api';
      final urlPendentes = Uri.parse(
        '$baseUrl/tarefas/pendentes/usuario/${usuario.id}',
      );
      final responsePendentes = await http.get(urlPendentes);

      final urlConcluidas = Uri.parse(
        '$baseUrl/tarefas/concluidas/usuario/${usuario.id}',
      );
      final responseConcluidas = await http.get(urlConcluidas);

      if (responsePendentes.statusCode == 200 &&
          responseConcluidas.statusCode == 200) {
        final List<dynamic> listaPendentes = jsonDecode(responsePendentes.body);
        final List<dynamic> listaConcluidas = jsonDecode(
          responseConcluidas.body,
        );

        setState(() {
          _tarefasPendentesCount = listaPendentes.length;
          _tarefasConcluidasCount = listaConcluidas.length;
        });
      }
    } catch (e) {
      print('Erro ao carregar estatísticas: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingStats = false);
      }
    }
  }

  String getInitials(String? nome) {
    if (nome == null || nome.isEmpty) return '??';
    List<String> names = nome.split(' ');
    String initials = '';
    int numInitials = names.length > 1 ? 2 : 1;
    for (var i = 0; i < numInitials; i++) {
      if (names[i].isNotEmpty) {
        initials += names[i][0];
      }
    }
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final usuario = Provider.of<UsuarioProvider>(context).usuario;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 2.0,
        shadowColor: Colors.black,
        title: Text(
          "Editar Perfil",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color.fromARGB(255, 0, 52, 80),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : const Color.fromARGB(255, 0, 52, 80),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: isDark
                      ? const Color(0xFF335D9B)
                      : const Color.fromARGB(255, 241, 117, 34),
                  child: Text(
                    getInitials(usuario?.nomeUsuario),
                    style: GoogleFonts.poppins(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  usuario?.nomeUsuario ?? 'Nome do Aluno',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  usuario?.email ?? 'email@exemplo.com',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    _buildStatCard(
                      label: 'Pendentes',
                      count: _tarefasPendentesCount,
                      icon: Icons.list_alt_rounded,
                      color: Colors.orange,
                      isLoading: _isLoadingStats,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      label: 'Concluídas',
                      count: _tarefasConcluidasCount,
                      icon: Icons.check_circle_outline_rounded,
                      color: Colors.green,
                      isLoading: _isLoadingStats,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildTextField(
                  label: 'Nome de Usuário',
                  controller: _nomeUsuarioController,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Email',
                  controller: _emailController,
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Nome Completo',
                  controller: _nomeCompletoController,
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Telefone',
                  controller: _telefoneController,
                  icon: Icons.phone_outlined,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoadingSave ? null : _salvarAlteracoes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? const Color(0xFF335D9B)
                          : const Color.fromARGB(255, 241, 117, 34),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoadingSave
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            'Salvar Alterações',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark
                                  ? Colors.white
                                  : const Color.fromARGB(255, 0, 38, 58),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    int? count,
    required IconData icon,
    required Color color,
    required bool isLoading,
  }) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 14),
            ),
            const SizedBox(height: 4),
            isLoading
                ? SizedBox(
                    height: 28,
                    width: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  )
                : Text(
                    count?.toString() ?? '0',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return TextFormField(
      controller: controller,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? const Color(0xFF335D9B)
                : const Color.fromARGB(255, 241, 117, 34),
            width: 2,
          ),
        ),
      ),
    );
  }
}
