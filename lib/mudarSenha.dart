// importa os pacotes necessários
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/theme_provider.dart';
import 'package:provider/provider.dart';

// cria um widget com estado para a tela de mudança de senha
class MudarSenhaPage extends StatefulWidget {
  const MudarSenhaPage({super.key});

  @override
  State<MudarSenhaPage> createState() => _MudarSenhaPageState();
}

class _MudarSenhaPageState extends State<MudarSenhaPage> {
  // controladores para capturar o texto dos campos de input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _obscureOld = true; 
  bool _obscureNew = true; 
  String message = ''; // armazena mensagens de feedback (erro/sucesso)
  bool _isLoading = false; // controla a exibição do indicador de carregamento

  // função para enviar os dados de mudança de senha para a api
  Future<void> _mudarSenha() async {
    var url = Uri.parse('http://localhost:8080/api/usuarios/mudar-senha');

    String username = _usernameController.text.trim();
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;

    if (username.isEmpty || oldPassword.isEmpty || newPassword.isEmpty) {
      setState(() => message = 'preencha todos os campos.');
      return;
    }

    // ativa o estado de carregamento
    setState(() {
      _isLoading = true;
      message = '';
    });

    try {
      // faz a requisição http put, ideal para atualizar um recurso existente
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'nomeUsuario': username,
          'senhaAntiga': oldPassword,
          'senhaNova': newPassword,
        }),
      );

      // exibe a mensagem de sucesso ou erro vinda diretamente do corpo da resposta da api
      setState(() {
        message = response.body;
      });
    } catch (e) {
      // trata erros de conexão com a api
      setState(() {
        message = 'erro de conexão. verifique a api.';
      });
    } finally {
      // garante que o carregamento será desativado, ocorrendo sucesso ou falha
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 52, 80),
              Color(0xFF5B73FF),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            // decoração do card com efeito de vidro
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(Icons.lock_reset_rounded,
                      size: 80, color: Colors.white70),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _usernameController,
                    icon: Icons.person,
                    label: 'usuário',
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _oldPasswordController,
                    icon: Icons.lock_outline,
                    label: 'senha antiga',
                    obscureText: _obscureOld,
                    toggleVisibility: () {
                      setState(() {
                        _obscureOld = !_obscureOld;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _newPasswordController,
                    icon: Icons.lock,
                    label: 'nova senha',
                    obscureText: _obscureNew,
                    toggleVisibility: () {
                      setState(() {
                        _obscureNew = !_obscureNew;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    // desabilita o botão e mostra um spinner enquanto carrega
                    onPressed: _isLoading ? null : _mudarSenha,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 241, 117, 34),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'alterar',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 38, 58),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  // exibe a mensagem de feedback apenas se ela não estiver vazia
                  if (message.isNotEmpty)
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: message.toLowerCase().contains('sucesso')
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'voltar',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // widget auxiliar para criar os campos de texto e evitar repetição de código
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        label: Text(label,
            style: GoogleFonts.poppins(
                color: Colors.white70)),
        //ícone de visibilidade apenas se a função 'togglevisibility' for fornecida
        suffixIcon: toggleVisibility != null
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: toggleVisibility,
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white70, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}