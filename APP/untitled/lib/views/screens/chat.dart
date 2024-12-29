import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pacote necessário para formatar a data e a hora
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled/views/screens/profile.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _contacts = [];
  final List<String> _allUsers = ['User1', 'User2', 'User3', 'User4', 'User5'];
  List<String> _foundUsers = [];
  bool _isSearching = false;
  int totalPoints = 1050; // Pontos totais iniciais

  @override
  void initState() {
    super.initState();
    _foundUsers = _allUsers;
  }

  void _addContact(String user) {
    setState(() {
      _contacts.add(user);
      _allUsers.remove(user);
      _foundUsers.remove(user);
      _searchController.clear(); // Limpa a barra de pesquisa
      _isSearching = false;
    });
  }

  void _openChat(String user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen(user: user)),
    );
  }

  void _sendPoints(String user) {
    final TextEditingController pointsController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enviar Pontos para $user'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pontos disponíveis: $totalPoints'),
            const SizedBox(height: 8.0),
            TextField(
              controller: pointsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade:',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final int points = int.tryParse(pointsController.text) ?? 0;
              if (points > 0 && points <= totalPoints) {
                setState(() {
                  totalPoints -= points;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pontos enviados para $user. Total de pontos: $totalPoints')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pontos insuficientes ou valor inválido.')),
                );
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  void _searchUsers(String query) {
    final suggestions = _allUsers.where((user) => user.toLowerCase().contains(query.toLowerCase())).toList();
    setState(() {
      _foundUsers = suggestions;
      _isSearching = query.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Pesquisar usuários...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: _searchUsers,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Navega para a tela de edição de perfil
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          if (_isSearching && _foundUsers.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _foundUsers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_foundUsers[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.person_add),
                      onPressed: () => _addContact(_foundUsers[index]),
                    ),
                  );
                },
              ),
            ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_contacts[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chat),
                        onPressed: () => _openChat(_contacts[index]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.change_circle_rounded),
                        onPressed: () => _sendPoints(_contacts[index]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String user;

  const ChatScreen({super.key, required this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await _recorder!.openRecorder();
    await Permission.microphone.request();
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _recorder = null;
    super.dispose();
  }

  void _sendMessage() {
    final String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      final String timestamp = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
      setState(() {
        _messages.add({'text': message, 'isSentByUser': true, 'timestamp': timestamp});
        _messageController.clear();
      });
    }
  }

  Future<void> _startRecording() async {
    setState(() => _isRecording = true);
    await _recorder!.startRecorder(toFile: 'audio_message.aac');
  }

  Future<void> _stopRecording() async {
    final String? path = await _recorder!.stopRecorder();
    setState(() => _isRecording = false);

    if (path != null) {
      final String timestamp = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
      setState(() {
        _messages.add({
          'audioPath': path,
          'isSentByUser': true,
          'timestamp': timestamp,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final messageData = _messages[index];
                final isSentByUser = messageData['isSentByUser'] as bool;
                final timestamp = messageData['timestamp'] as String;

                return Align(
                  alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isSentByUser ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (messageData.containsKey('text'))
                          Text(
                            messageData['text'] as String,
                            style: const TextStyle(fontSize: 16.0),
                          )
                        else if (messageData.containsKey('audioPath'))
                          IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () {
                              FlutterSoundPlayer().startPlayer(fromURI: messageData['audioPath']);
                            },
                          ),
                        const SizedBox(height: 5.0),
                        Text(
                          timestamp,
                          style: TextStyle(fontSize: 8.0, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Digite uma mensagem...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
                IconButton(
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}