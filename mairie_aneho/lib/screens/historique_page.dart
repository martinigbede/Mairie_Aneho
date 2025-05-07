import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoriqueDemandesPage extends StatelessWidget {
  const HistoriqueDemandesPage({super.key});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'traité':
        return Colors.green;
      case 'rejeté':
        return Colors.red;
      default:
        return Colors.orange; // "en cours"
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Demandes'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body:
          user == null
              ? const Center(child: Text('Utilisateur non connecté'))
              : StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('citizen_requests')
                        .where('uid', isEqualTo: user.uid)
                        //.orderBy('created_at', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Aucune demande trouvée.'));
                  }

                  final demandes = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: demandes.length,
                    itemBuilder: (context, index) {
                      final doc = demandes[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final status = data['status'] ?? 'Inconnu';
                      final service = data['service'] ?? 'Service';
                      final createdAt = data['created_at']?.toDate();

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text(service),
                          subtitle: Text(
                            createdAt != null
                                ? 'Envoyée le ${createdAt.day}/${createdAt.month}/${createdAt.year}'
                                : 'Date inconnue',
                          ),
                          trailing: Text(
                            status,
                            style: TextStyle(
                              color: _getStatusColor(status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            // Navigation vers la page de détails
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => DetailsDemandePage(demande: data),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}

// Cette page affichera les détails d'une demande
class DetailsDemandePage extends StatelessWidget {
  final Map<String, dynamic> demande;

  const DetailsDemandePage({super.key, required this.demande});

  @override
  Widget build(BuildContext context) {
    final formData = demande['form_data'] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la Demande'),
        backgroundColor: Colors.teal[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children:
              formData.entries.map<Widget>((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text(entry.key.replaceAll('_', ' ').toUpperCase()),
                    subtitle: Text(entry.value.toString()),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
