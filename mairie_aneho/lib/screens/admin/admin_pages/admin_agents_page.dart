// TODO Implement this library.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminAgentsPage extends StatefulWidget {
  const AdminAgentsPage({super.key});

  @override
  State<AdminAgentsPage> createState() => _AdminAgentsPageState();
}

class _AdminAgentsPageState extends State<AdminAgentsPage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fonctionController = TextEditingController();

  Future<void> _ajouterNouvelAgent() async {
    final nom = _nomController.text.trim();
    final email = _emailController.text.trim();
    final fonction = _fonctionController.text.trim();

    if (nom.isEmpty || email.isEmpty || fonction.isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection('agents').add({
        'nom': nom,
        'email': email,
        'fonction': fonction,
        'mot_de_passe': 'agent1234', // mot de passe par défaut
        'date_ajout': Timestamp.now(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Agent ajouté avec succès')));

      _nomController.clear();
      _emailController.clear();
      _fonctionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    }
  }

  void _afficherDialogueAjout() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Ajouter un agent'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _fonctionController,
                  decoration: const InputDecoration(labelText: 'Fonction'),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Annuler'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text('Ajouter'),
                onPressed: () async {
                  Navigator.pop(context);
                  await _ajouterNouvelAgent();
                },
              ),
            ],
          ),
    );
  }

  Widget _buildAgentCard(DocumentSnapshot agent) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.teal,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(agent['nom']),
        subtitle: Text(agent['fonction']),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('agents')
                .doc(agent.id)
                .delete();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des Agents"),
        backgroundColor: Colors.teal[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _afficherDialogueAjout,
            tooltip: 'Ajouter un agent',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('agents')
                .orderBy('date_ajout', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Erreur de chargement"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final agents = snapshot.data!.docs;

          if (agents.isEmpty) {
            return const Center(child: Text("Aucun agent pour le moment."));
          }

          return ListView.builder(
            itemCount: agents.length,
            itemBuilder: (context, index) {
              return _buildAgentCard(agents[index]);
            },
          );
        },
      ),
    );
  }
}
