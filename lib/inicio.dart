
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/criarConta.dart';
import 'package:mobile/fazerLogin.dart';

class Inicial extends StatefulWidget {
  const Inicial({super.key});

  @override
  State<Inicial> createState() => _InicialState();
}

class _InicialState extends State<Inicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "App do Aluno",
          style: GoogleFonts.poppins(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : const Color.fromARGB(255, 0, 52, 80),
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2.0,
        shadowColor: Colors.black,
        // widgets alinhados à direita na appbar
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    'login',
                    style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 0, 52, 80),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Criar()),
                    );
                  },
                  child: Text(
                    'criar conta',
                    style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 0, 52, 80),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 52, 80),
              Color(0xFF5B73FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // permite que o conteúdo role caso a tela seja pequena
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // exibe a logo do app
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white24,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                const SizedBox(height: 20),

                // card de conteúdo com efeito de vidro semi-transparente
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: 520,
                  height: 600,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 60, left: 19, right: 19, bottom: 2),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "objetivo",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "nosso aplicativo foi desenvolvido para auxiliar pessoas que enfrentam dificuldades com organização, foco e motivação nos estudos.\n\n"
                            "buscamos transformar a experiência de aprendizado por meio de recursos tecnológicos que tornam o processo mais atrativo, eficiente e disciplinado.\n\n"
                            "assim, proporcionamos ferramentas que facilitam o planejamento das atividades e ajudam a manter a constância, criando um ambiente mais\n"
                            "produtivo e estimulante para todos os usuários.",
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 19,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: 520,
                  height: 600,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 60, left: 19, right: 19, bottom: 2),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "metodologias",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            " - método pomodoro\n\n"
                            " - resumos\n\n"
                            " - mapas mentais\n\n"
                            " - bloco de notas para anotações\n\n"
                            " - video aulas disponíveis\n\n"
                            " - integração com o aplicativo\n\n",
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 19,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 40),
                  width: 520,
                  height: 600,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 60, left: 19, right: 19, bottom: 2),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "integração multiplataforma",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "nossas plataformas integram várias metodologias de estudo, permitindo que os usuários ajustem técnicas como por exemplo, o pomodoro, com alarmes personalizados para os ciclos de estudo e pausa. \n\n"
                            "ele também possibilita a criação de resumos a partir de videoaulas e o enriquecimento com anotações . \n\n"
                            "além disso, centraliza todo o material de estudo — como documentos, videoaulas e exercicios — facilitando o acesso, organização e aumentando a eficiência do aprendizado.",
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 19,
                              height: 1.6,
                            ),
                          ),
                        ],
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
}