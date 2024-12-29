import 'package:flutter/material.dart';
import 'index.dart'; // Substitua pelo arquivo correto onde está a tela inicial ou a próxima tela

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para os campos de entrada
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Função para simular o processo de login
  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Validação simples: verificar se os campos estão vazios
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    // Simulação de login (substitua isso com sua lógica de autenticação real)
    if (username == 'usuario' && password == 'senha123') {
      // Navega para a tela inicial se o login for bem-sucedido
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } else {
      // Exibe mensagem de erro se as credenciais estiverem incorretas
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciais incorretas!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      backgroundColor: const Color(0xFFEAF1FF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                'BinasJC',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              // Campo de username
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Campo de senha
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),
              // Botão de login
              ElevatedButton(
                onPressed: _login, // Chama a função de login
                child: const Text(
                  'Entrar',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xEE134B70), // Cor do botão
                  minimumSize: const Size(200, 50), // Tamanho do botão
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
