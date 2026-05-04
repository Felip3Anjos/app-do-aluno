import 'package:flutter/material.dart';
import 'package:mobile/app.dart';
import 'package:mobile/theme_provider.dart';
import 'package:provider/provider.dart';

class login extends StatefulWidget {
   const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> { 

  final TextEditingController _nomeController = TextEditingController(); 
  final TextEditingController _senhaController = TextEditingController(); 

  final String _dadosAluno = ''; // variável para armazenar dados do aluno 

  @override
  void dispose() { // método chamado quando o widget é removido
    _nomeController.dispose(); 
    _senhaController.dispose(); 
    super.dispose(); // chama o dispose da superclasse
  }

  @override
  Widget build(BuildContext context) { 
    final themeProvider = Provider.of<ThemeProvider>(context); // acessa o tema atual usando provider de tema e pa
    return Scaffold( 

      appBar: AppBar( 
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true, 
      ),

      drawer: Drawer( 
        child: Column(
          children: [
            Expanded( // ocupa todo o espaço disponível
              child: ListView( 
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader( 
                    decoration: BoxDecoration( 
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? const Color.fromARGB(255, 236, 83, 12) // tema escuro
                          : const Color.fromARGB(255, 255, 133, 77), // tema claro
                      boxShadow: [ // sombra do cabeçalho
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5), 
                          blurRadius: 7, 
                          offset: const Offset(0, 0) // sem deslocamento 
                        )
                      ]
                    ),

                    child: const Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading:  const Icon(Icons.home),
                    title: const Text('Início'),
                     onTap: () {
                      Navigator.pop(context); 
                      Navigator.push( 
                        context,
                        MaterialPageRoute(builder: (context) => Mobile()),
                      );
                    },
                  ),
               

                ],
              ),
           ),
             const Divider(),

           ListTile( 
              leading: const Icon(Icons.bedtime_rounded), 
              title: const Text('Modo Escuro'),
              trailing: Switch( // botão q alterna
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(value), 
              ),
            ),

            ListTile(
              leading:  const Icon(Icons.settings),
              title:  const Text('Configurações'),
              onTap: () => Navigator.pop(context),
            ),
             ListTile(
              leading:  const Icon(Icons.lightbulb_outline),
              title:  const Text('Projeto'),
              onTap: () => Navigator.pop(context),
            ),

            ListTile(
             leading: const Icon(Icons.groups),
             title: const Text('Sobre nós'),
             onTap: () => Navigator.pop(context),
           ),
          ],
        ),
      ),
      body:Center(
  child: SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         const SizedBox(height: 5),
        Image.asset(
          "assets/images/logo.png",
          width: 200,
          height: 150,
        ),
         const SizedBox(height: 15),
         const Text(
          "Login",
          style: TextStyle(
            color: Color.fromARGB(255, 46, 89, 167),
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
         const SizedBox(height: 30),

        // Campo Nome
        SizedBox(
          width: 350,
          child: TextField(
            controller: _nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome',
              hintText: 'Nome do usuário',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
        ),
         const SizedBox(height: 20),

        // Campo Senha
        SizedBox(
          width: 350,
          child: TextField(
            obscureText: true,
            controller: _senhaController,
            decoration: const InputDecoration(
              labelText: 'Senha',
              hintText: 'Digite sua senha',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
       const SizedBox(height: 30),

        // Botão Enviar
        ElevatedButton(
          onPressed: () {        
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title:const Text('Erro de login'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: 
                       const Text('OK'),
                    ),
                  ],
                ),
              );
            
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: 
             const Color.fromARGB(255, 46, 89, 167),
            padding: 
             const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: 
           const Text(
            'Entrar',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),

        
         const SizedBox(height: 30),

        // Resultado
       if (_dadosAluno.isNotEmpty) // se a variável _dadosAluno não estiver vazia
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20), 
            child: Text(
              _dadosAluno,
              style: const TextStyle(fontSize: 16), 
              textAlign: TextAlign.center, 
            ),
          ),

      ],
    ),
  ),
),
);   
  }
}