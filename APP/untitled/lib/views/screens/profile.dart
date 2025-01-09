import 'package:flutter/material.dart';
import 'package:untitled/models/user.dart';

import '../../services/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late User _user;
  late UserService _userService;

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _loadUserData();
  }

  void _loadUserData() async {
    // Simulação de obter dados do usuário (pode ser do banco de dados local ou API)
    _user = await _userService.getUserById(1); // Carregar usuário por ID
    setState(() {
      _nameController.text = _user.username;
      _passwordController.text = '';  // Não mostramos a senha por questões de segurança
    });
  }

  void _saveProfile() async {
    final updatedName = _nameController.text;
    final updatedPassword = _passwordController.text;

    // Atualizar o usuário
    try {
      await _userService.updateUsername(_user.id, updatedName);
      await _userService.updatePassword(_user.id, updatedPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar perfil: $e')),
      );
    }
    Navigator.pop(context);  // Fechar tela após a atualização
  }

  void _deleteAccount() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Conta'),
        content: const Text('Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _userService.deleteUser(_user.id);  // Excluir o usuário
                Navigator.pop(context); // Fecha o diálogo
                Navigator.pop(context); // Fecha a tela de perfil
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Conta excluída com sucesso!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao excluir conta: $e')),
                );
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nome do Usuário'),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Senha'),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Salvar'),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: _deleteAccount,
                  child: const Text(
                    'Excluir Conta',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
