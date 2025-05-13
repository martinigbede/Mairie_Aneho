// TODO Implement this library.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDemandesPage extends StatefulWidget {
  const AdminDemandesPage({super.key});

  @override
  State<AdminDemandesPage> createState() => _AdminDemandesPageState();
}

class _AdminDemandesPageState extends State<AdminDemandesPage> {
  String selectedStatut = 'Tous';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: selectedStatut,
          items:
              ['Tous', 'En cours', 'Traité', 'Rejeté']
                  .map(
                    (statut) =>
                        DropdownMenuItem(value: statut, child: Text(statut)),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              selectedStatut = value!;
            });
          },
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('demandes').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final demandes =
                  snapshot.data!.docs.where((doc) {
                    if (selectedStatut == 'Tous') return true;
                    return doc['statut'] == selectedStatut;
                  }).toList();

              if (demandes.isEmpty) {
                return const Center(child: Text('Aucune demande trouvée.'));
              }

              return ListView.builder(
                itemCount: demandes.length,
                itemBuilder: (context, index) {
                  final demande = demandes[index];
                  return Card(
                    child: ListTile(
                      title: Text('${demande['nom']} - ${demande['type']}'),
                      subtitle: Text('Statut: ${demande['statut']}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          FirebaseFirestore.instance
                              .collection('demandes')
                              .doc(demande.id)
                              .update({'statut': value});
                        },
                        itemBuilder:
                            (context) => [
                              const PopupMenuItem(
                                value: 'En cours',
                                child: Text('En cours'),
                              ),
                              const PopupMenuItem(
                                value: 'Traité',
                                child: Text('Traité'),
                              ),
                              const PopupMenuItem(
                                value: 'Rejeté',
                                child: Text('Rejeté'),
                              ),
                            ],
                      ),
                      onTap: () {
                        _showDetailsDialog(context, demande);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDetailsDialog(BuildContext context, QueryDocumentSnapshot demande) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Détails de la demande'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    demande.data()!.entries.map((entry) {
                      return Text('${entry.key} : ${entry.value}');
                    }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
            ],
          ),
    );
  }
}

extension on Object {
  get entries => null;
}
