import 'package:flutter/material.dart';
import 'package:mobile/app.dart';
import 'package:mobile/theme_provider.dart';
import 'package:provider/provider.dart';

class login extends StatefulWidget {
   login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> { 

  final TextEditingController _nomeController = TextEditingController(); 
  final TextEditingController _senhaController = TextEditingController(); 

  String _dadosAluno = ''; // variável para armazenar dados do aluno 

  @override
  void dispose() { // método chamado quando o widget é removido
    _nomeController.dispose(); 
    _senhaController.dispose(); 
    super.dispose(); // chama o dispose da superclasse
  }

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
                          ? Color.fromARGB(255, 236, 83, 12) // tema escuro
                          : Color.fromARGB(255, 255, 133, 77), // tema claro
                      boxShadow: [ // sombra do cabeçalho
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5), 
                          blurRadius: 7, 
                          offset: Offset(0, 0) // sem deslocamento 
                        )
                      ]
                    ),

                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading:  Icon(Icons.home),
                    title: Text('Início'),
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
             Divider(),

           ListTile( 
              leading: Icon(Icons.bedtime_rounded), 
              title: Text('Modo Escuro'),
              trailing: Switch( // botão q alterna
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(value), 
              ),
            ),

            ListTile(
              leading:  Icon(Icons.settings),
              title:  Text('Configurações'),
              onTap: () => Navigator.pop(context),
            ),
             ListTile(
              leading:  Icon(Icons.lightbulb_outline),
              title:  Text('Projeto'),
              onTap: () => Navigator.pop(context),
            ),

            ListTile(
             leading: Icon(Icons.groups),
             title: Text('Sobre nós'),
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
         SizedBox(height: 5),
        Image.asset(
          "assets/images/logo.png",
          width: 200,
          height: 150,
        ),
         SizedBox(height: 15),
         Text(
          "Login",
          style: TextStyle(
            color: Color.fromARGB(255, 46, 89, 167),
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
         SizedBox(height: 30),

        // Campo Nome
        SizedBox(
          width: 350,
          child: TextField(
            controller: _nomeController,
            decoration: InputDecoration(
              labelText: 'Nome',
              hintText: 'Nome do usuário',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
        ),
         SizedBox(height: 20),

        // Campo Senha
        SizedBox(
          width: 350,
          child: TextField(
            obscureText: true,
            controller: _senhaController,
            decoration: InputDecoration(
              labelText: 'Senha',
              hintText: 'Digite sua senha',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
       SizedBox(height: 30),

        // Botão Enviar
        ElevatedButton(
          onPressed: () {        
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title:Text('Erro de login'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: 
                       Text('OK'),
                    ),
                  ],
                ),
              );
            
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: 
             Color.fromARGB(255, 46, 89, 167),
            padding: 
             EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: 
           Text(
            'Entrar',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),

        
         SizedBox(height: 30),

        // Resultado
       if (_dadosAluno.isNotEmpty) // se a variável _dadosAluno não estiver vazia
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20), 
            child: Text(
              _dadosAluno,
              style: TextStyle(fontSize: 16), 
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