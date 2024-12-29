import 'package:flutter/material.dart';
import 'package:untitled/views/screens/home.dart';
import 'package:untitled/views/screens/login.dart';
import 'package:untitled/views/screens/map.dart';
import 'package:untitled/views/screens/chat.dart';
import 'package:untitled/views/screens/points.dart';
import 'package:untitled/views/screens/register.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF1FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Image.asset('assets/bicycle_logo.png', height: 100),
            // Certifique-se de ter a imagem no diretório assets
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
