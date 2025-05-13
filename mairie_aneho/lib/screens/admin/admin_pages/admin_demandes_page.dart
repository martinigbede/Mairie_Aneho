// TODO Implement this library.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDemandesPage extends StatelessWidget {
  const AdminDemandesPage({super.key});

  Future<void> _attribuerAgent(BuildContext context, String demandeId) async {
    final agentsSnapshot =
        await FirebaseFirestore.instance.collection('agents').get();
    final agents = agentsSnapshot.docs;

    String? agentChoisi;

    await showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Attribuer à un agent"),
            content: DropdownButtonFormField<String>(
              isExpanded: true,
              items:
                  agents.map((doc) {
                    return DropdownMenuItem(
                      value: doc.id,
                      child: Text("${doc['nom']} - ${doc['fonction']}"),
                    );
                  }).toList(),
              onChanged: (val) {
                agentChoisi = val;
              },
              decoration: const InputDecoration(
                labelText: "Sélectionner un agent",
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Annuler"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text("Attribuer"),
                onPressed: () async {
                  if (agentChoisi != null) {
                    await FirebaseFirestore.instance
                        .collection('demandes')
                        .doc(demandeId)
                        .update({
                          'agent_id': agentChoisi,
                          'statut': 'attribuée',
                          'date_attribution': Timestamp.now(),
                        });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  Widget _buildDemandeCard(DocumentSnapshot doc, BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;

    Color statusColor;
    switch (data['statut']) {
      case 'en attente':
        statusColor = Colors.orange;
        break;
      case 'attribuée':
        statusColor = Colors.blue;
        break;
      case 'traitée':
        statusColor = Colors.green;
        break;
      case 'rejetée':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        title: Text(data['type'] ?? "Demande"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nom: ${data['nom']}"),
            Text(
              "Statut: ${data['statut'] ?? 'en attente'}",
              style: TextStyle(color: statusColor),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.assignment_ind, color: Colors.teal),
          onPressed: () => _attribuerAgent(context, doc.id),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: Text("Détails de la demande"),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          data.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text("${entry.key} : ${entry.value}"),
                            );
                          }).toList(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Fermer"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des Demandes"),
        backgroundColor: Colors.teal[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('demandes')
                .orderBy('date_envoi', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Erreur de chargement"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final demandes = snapshot.data!.docs;

          if (demandes.isEmpty) {
            return const Center(child: Text("Aucune demande pour le moment."));
          }

          return ListView.builder(
            itemCount: demandes.length,
            itemBuilder: (context, index) {
              return _buildDemandeCard(demandes[index], context);
            },
          );
        },
      ),
    );
  }
}
