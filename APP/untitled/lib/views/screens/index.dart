import 'package:flutter/material.dart';
import 'package:untitled/views/screens/home.dart';
import 'package:untitled/views/screens/login.dart';
import 'package:untitled/views/screens/map.dart';
import 'package:untitled/views/screens/chat.dart';
import 'package:untitled/views/screens/points.dart';
import 'package:untitled/views/screens/register.dart';
import '../../datalocal/appDatabase.dart';
import '../../datalocal/user.dart';
import '../../models/user.dart';
import '../utils/AppColor.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MapsWidget(),
    HomeWidget(),
    ChatWidget(),
    PointsWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Maps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike_outlined),
            label: 'Bike',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Points',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColor.primary,
        unselectedItemColor: AppColor.primarySoft,
        onTap: _onItemTapped,
      ),
    );
  }
}

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  @override
  void initState() {
    super.initState();
    // Verifica se há um usuário registrado ao carregar a tela
    _checkUser();
  }

  // Função que verifica se há um usuário no banco de dados
  Future<void> _checkUser() async {
    final appDatabase = AppDatabase.instance;
    final userDatabase = UserDatabase(appDatabase);

    try {
      List<User> users = await userDatabase.getAll();
      userDatabase.close();

      if (users.isNotEmpty) {
        // int userId = users.first.id; // Assume que o primeiro usuário é o atual
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(), // Passa o ID
          ),
        );
      }
    } catch (e) {
      // Log ou mostre uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao verificar sessao iniciada.')),
      );    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF1FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'BinasJC',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xEE134B70), // Cor do botão
                minimumSize: const Size(200, 50), // Tamanho do botão
              ),
              child: const Text(
                'Entrar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xEE134B70), // Cor do botão
                minimumSize: const Size(200, 50), // Tamanho do botão
              ),
              child: const Text(
                'Registrar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
