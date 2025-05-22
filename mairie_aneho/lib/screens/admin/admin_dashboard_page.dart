import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/login.dart';
// import 'admin_pages/admin_agents_page.dart';
// import 'admin_pages/admin_demandes_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int totalDemandes = 0;
  int demandesEnCours = 0;
  int demandesTraitees = 0;
  int totalAgents = 0;

  @override
  void initState() {
    super.initState();
    fetchDashboardStats();
  }

  Future<void> fetchDashboardStats() async {
    final demandes =
        await FirebaseFirestore.instance.collection('demandes').get();
    final agents = await FirebaseFirestore.instance.collection('agents').get();

    setState(() {
      totalDemandes = demandes.docs.length;
      demandesEnCours =
          demandes.docs.where((doc) => doc['statut'] == 'en cours').length;
      demandesTraitees =
          demandes.docs.where((doc) => doc['statut'] == 'traité').length;
      totalAgents = agents.docs.length;
    });
  }

  Widget _buildStatCard(String title, int value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: color.withOpacity(0.9),
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 100,
        child: Row(
          children: [
            Icon(Icons.analytics, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  '$value',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Tableau de Bord Admin'),
        backgroundColor: Colors.teal[800],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Déconnexion',
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: fetchDashboardStats,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildStatCard("Total des Demandes", totalDemandes, Colors.teal),
            _buildStatCard("Demandes en cours", demandesEnCours, Colors.orange),
            _buildStatCard("Demandes traitées", demandesTraitees, Colors.green),
            _buildStatCard("Agents enregistrés", totalAgents, Colors.blueGrey),

            const SizedBox(height: 20),
            const Divider(thickness: 1),
          ],
        ),
      ),
    );
  }
}
