// importa os pacotes necessários
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/app.dart';
import 'package:mobile/usuario.dart';
import 'package:mobile/usuario_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // variáveis de estado
  String message = ''; // armazena mensagens de erro
  bool _isLoading = false; // controla a exibição do indicador de carregamento

  // função para autenticar o usuário na api
  Future<void> _login() async {
    // endpoint da api para login
    var url = Uri.parse('http://localhost:8080/api/usuarios/login');

    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() => message = 'preencha todos os campos.');
      return;
    }

    // ativa o estado de carregamento e limpa mensagens antigas
    setState(() {
      _isLoading = true;
      message = '';
    });

    try {
      // faz a requisição http post, enviando as credenciais em formato json
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'nomeUsuario': username, 'senha': password}),
      );

      // 200 indica que o login foi sucedido
      if (response.statusCode == 200) {
        // converte a resposta json da api em um objeto 'usuario'
        final usuario = Usuario.fromJson(jsonDecode(response.body));

        if (mounted) {
          //provider para salvar os dados do usuário no estado global 
          Provider.of<UsuarioProvider>(
            context,
            listen: false,
          ).setUsuario(usuario);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Mobile()),
          );
        }
      } else {
        // trata de credenciais inválidas retornados pela api
        setState(() {
          message = 'nome de usuário ou senha inválidos.';
        });
      }
    } catch (e) {
      // erro de conexão com a api
      setState(() {
        message = 'erro de conexão. verifique a api.';
      });
    } finally {
      // garante que o carregamento será desativado
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 0, 52, 80), Color(0xFF5B73FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            // decoração do card de login com efeito de vidro
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.school_outlined,
                  size: 80,
                  color: Colors.white70,
                ),
                const SizedBox(height: 20),
                TextField(
                  textInputAction: TextInputAction.next,
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person_2_outlined,
                      color: Colors.white70,
                    ),
                    label: Text(
                      'nome do usuário',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  // permite submeter o formulário pressionando 'enter' no teclado
                  onSubmitted: (_) => _isLoading ? null : _login(),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white70,
                    ),
                    label: Text(
                      'senha',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 241, 117, 34),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                  // desabilita o botão e mostra um spinner enquanto carrega
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                      : Text(
                          'login',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 38, 58),
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                // exibe a mensagem de erro apenas se ela não estiver vazia
                if (message.isNotEmpty)
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.redAccent,
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
    );
  }
}