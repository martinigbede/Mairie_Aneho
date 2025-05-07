// TODO Implement this library.
import 'package:flutter/material.dart';

class AgentHome extends StatelessWidget {
  const AgentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace Agent de Mairie'),
        backgroundColor: Colors.blue[700],
      ),
      body: const Center(
        child: Text(
          'Bienvenue dans votre espace agent 🛠️',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
