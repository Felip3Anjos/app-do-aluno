import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sobrenos extends StatelessWidget {
  const Sobrenos({super.key});

  @override
  Widget build(BuildContext context) {
    final membros = [ // Lista para chamada membros
  { 
    'nome': 'Felipe', // Nome do membro
    'imagem': 'assets/images/Felipe.png', // Caminho da imagem do membro
    'descricao': 'Responsável pelo desenvolvimento mobile.', // Função do membro no projeto
  },
  { 
    'nome': 'Gabriel',
    'imagem': 'assets/images/Jacomi.png', 
    'descricao': 'Cuidou da parte Web e design.', 
  },
  { 
    'nome': 'João', 
    'imagem': 'assets/images/Joao.png', 
    'descricao': 'Desenvolvedor responsável pela integração do backend.', 
  },
  { 
    'nome': 'Guilherme', 
    'imagem': 'assets/images/Guilherme.png', 
    'descricao': 'Auxiliou na parte Web e é consultor digital.', 
  },
]; 


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Sobre Nós',
          style: GoogleFonts.poppins(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                :  Color.fromARGB(255, 0, 52, 80),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        shadowColor: Colors.black,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 52, 80),
              Color(0xFF5B73FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      child: ListView.builder( // cria uma lista que pode ser rolada
  padding: const EdgeInsets.symmetric(vertical: 30), // da espaço em cima e embaixo
  itemCount: membros.length, // define quantos itens a lista vai ter 
  itemBuilder: (context, index) { // função que monta cada item da lista
    final membro = membros[index]; // pega os dados do membro atual da lista
    return _MembroCard( // retorna um cartão com os dados do membro
      imagem: membro['imagem']!, 
      nome: membro['nome']!, 
      descricao: membro['descricao']!, 
    );
  },
),

      ),
    );
  }
}

class _MembroCard extends StatefulWidget { // define um widget com estado chamado _MembroCard
  final String imagem; // armazena o caminho da imagem
  final String nome; // armazena o nome do membro
  final String descricao; // armazena a descrição do membro

   const _MembroCard({ // construtor da classe _MembroCard
    required this.imagem, // parâmetro obrigatório para imagem
    required this.nome, // ''
    required this.descricao, //  ''
  });


  @override
  State<_MembroCard> createState() => _MembroCardState();
}

class _MembroCardState extends State<_MembroCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MouseRegion(
        onEnter: (_) => setState(() => hover = true), //hr q passa o mouse em cima ele abre
        onExit: (_) => setState(() => hover = false), //hora que sai o mouse sai ele volta ao estado comum
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300), //300milisegundos até abrir completamente
          margin: EdgeInsets.symmetric(vertical: 12),
          width: 340,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset:  Offset(0, 6),
              ),
            ],
          ),
        child: Column( 
  children: [
    SizedBox(height: 20), 
    CircleAvatar( // cria um avatar redondo com imagem
      radius: 50, // tamanho das foto
      backgroundImage: AssetImage(widget.imagem), // imagem do membro
    ),
    SizedBox(height: 10), // espaço entre a foto e o nome
    Text(
      widget.nome, // mostra o nome do membro
      style: GoogleFonts.poppins( 
        color: Colors.white, 
        fontSize: 20, 
        fontWeight: FontWeight.bold, 
      ),
    ),
    SizedBox(height: 8), 
    AnimatedCrossFade( // animação para mostrar ou esconder o texto
      duration: Duration(milliseconds: 300), // duração da animação
      crossFadeState: hover // verifica se vc passou o mouse
          ? CrossFadeState.showFirst // mostra a descrição
          : CrossFadeState.showSecond, // esconde a descrição
      firstChild: Padding( // conteúdo visível quando hover = true (passa o raí do mouse)
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), // espaço interno
        child: Text(
          widget.descricao, // mostra a descrição do membro
          style: GoogleFonts.poppins( 
            color: Colors.white, 
            fontSize: 15, 
            height: 1.4, 
          ),
          textAlign: TextAlign.center, 
        ),
      ),
      secondChild: SizedBox(height: 0), // conteúdo vazio quando hover = false
    ),
    SizedBox(height: 16), 
  ],
),

        ),
      ),
    );
  }
}
