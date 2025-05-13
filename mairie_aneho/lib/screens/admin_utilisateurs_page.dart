// TODO Implement this library.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUtilisateursPage extends StatefulWidget {
  const AdminUtilisateursPage({super.key});

  @override
  State<AdminUtilisateursPage> createState() => _AdminUtilisateursPageState();
}

class _AdminUtilisateursPageState extends State<AdminUtilisateursPage> {
  String filtreRole = 'Tous';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: filtreRole,
          items:
              ['Tous', 'citoyen', 'admin', 'agent']
                  .map(
                    (role) => DropdownMenuItem(value: role, child: Text(role)),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              filtreRole = value!;
            });
          },
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final utilisateurs =
                  snapshot.data!.docs.where((doc) {
                    if (filtreRole == 'Tous') return true;
                    return doc['role'] == filtreRole;
                  }).toList();

              if (utilisateurs.isEmpty) {
                return const Center(child: Text('Aucun utilisateur trouvé.'));
              }

              return ListView.builder(
                itemCount: utilisateurs.length,
                itemBuilder: (context, index) {
                  final utilisateur = utilisateurs[index];
                  return Card(
                    child: ListTile(
                      title: Text(utilisateur['nom'] ?? 'Nom inconnu'),
                      subtitle: Text('Rôle : ${utilisateur['role']}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(utilisateur.id)
                              .update({'role': value});
                        },
                        itemBuilder:
                            (context) => [
                              const PopupMenuItem(
                                value: 'citoyen',
                                child: Text('Citoyen'),
                              ),
                              const PopupMenuItem(
                                value: 'admin',
                                child: Text('Admin'),
                              ),
                              const PopupMenuItem(
                                value: 'agent',
                                child: Text('Agent'),
                              ),
                            ],
                      ),
                      onLongPress:
                          () => _confirmerSuppression(context, utilisateur.id),
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

  void _confirmerSuppression(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Supprimer l\'utilisateur ?'),
            content: const Text('Cette action est irréversible.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .delete();
                  Navigator.pop(context);
                },
                child: const Text('Supprimer'),
              ),
            ],
          ),
    );
  }
}
