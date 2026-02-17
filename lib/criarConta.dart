// importa os pacotes necessários
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobile/fazerLogin.dart';
import 'package:mobile/theme_provider.dart';
import 'package:provider/provider.dart';

// cria um widget com estado para a tela de criação de conta
class Criar extends StatefulWidget {
  Criar({super.key});

  @override
  State<Criar> createState() => _CriarState();
}

class _CriarState extends State<Criar> {
  // controladores que pegam o texto dos campos de input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // variáveis de estado
  String _message = ''; // armazena mensagens de feedback (erro/sucesso)
  Color _messageColor = Colors.redAccent; 
  bool _isLoading = false; // controla a exibição do indicador de carregamento
  bool _obscurePassword = true; 

  // função para registrar
  Future<void> _register() async {
    // endpoint da api para registrar
    var url = Uri.parse('http://localhost:8080/api/usuarios/registrar');

    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    // validação para campos vazios
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        _message = 'preencha todos os campos.';
        _messageColor = Colors.redAccent;
      });
      return;
    }

    // ativa o estado de carregamento e limpa mensagens antigas
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      // faz a requisição http post, enviando os dados do usuário em formato json
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'nomeUsuario': username,
          'email': email,
          'senha': password,
        }),
      );

      // 201 indica que a conta foi criada
      if (response.statusCode == 201) {
        setState(() {
          _message = 'conta criada com sucesso!';
          _messageColor = Colors.green;
          // limpa os campos de texto após o sucesso
          _usernameController.clear();
          _emailController.clear();
          _passwordController.clear();
        });

        // aguarda e navega para a tela de login
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            //substitui a tela atual pela de login, impedindo o usuário de "voltar" para o cadastro
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        });

      } else {
        // se a api retornar um erro exibe a mensagem 
        setState(() {
          _message = response.body;
          _messageColor = Colors.redAccent;
        });
      }
    } catch (e) {
      // trata erros de conexão com a api
      setState(() {
        _message = 'erro de conexão. verifique a api.';
        _messageColor = Colors.redAccent;
      });
    } finally {
      // 'finally' garante que o carregamento será desativado, ocorrendo sucesso ou falha
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
        // aplica um gradiente como plano de fundo
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeProvider.isDarkMode
                ? [const Color.fromARGB(255, 0, 52, 80), const Color(0xFF5B73FF)]
                : [const Color.fromARGB(255, 0, 52, 80), const Color(0xFF5B73FF)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Center(
          // permite que td role caso a tela seja pequena 
          child: SingleChildScrollView(
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(20),
              // decoração do card de cadastro com efeito de vidro
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_add_alt_1_rounded,
                      size: 80, color: Colors.white70),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: Colors.white70),
                      label: Text(
                        'nome de usuário',
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
                      label: Text(
                        'email',
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                      label: Text(
                        'senha',
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),                  
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 241, 117, 34),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    // desabilita o botão enquanto estiver carregando para evitar múltiplos cliques
                    onPressed: _isLoading ? null : _register,
                    // exibe um indicador de progresso no lugar do texto enquanto carrega
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'cadastrar',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 38, 58),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  // exibe a mensagem de feedback apenas se ela não estiver vazia
                  if (_message.isNotEmpty)
                    Text(
                      _message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: _messageColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 20),
                  // texto clicável para voltar à tela anterior
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'voltar',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 16,
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
}