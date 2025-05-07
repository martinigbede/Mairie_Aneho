// TODO Implement this library.
import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace Administrateur'),
        backgroundColor: Colors.yellow[800],
      ),
      body: const Center(
        child: Text(
          'Bienvenue dans votre espace administrateur 🧑‍💼',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
