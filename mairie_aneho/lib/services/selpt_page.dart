import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UrbanismePage extends StatelessWidget {
  const UrbanismePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        title: const Text("Selpt"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Service d\'Selpt',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Consultez les documents d\'urbanisme et faites vos demandes de permis.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  _serviceInfoCard(
                    context,
                    title: 'Permis de Construire',
                    description:
                        'Faites une demande de permis pour vos projets.',
                    icon: Icons.house,
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Certificat d\'Urbanisme',
                    description:
                        'Obtenez un certificat pour vos démarches d\'urbanisme.',
                    icon: Icons.location_city,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceInfoCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.amber[700]),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(description),
        onTap: () {
          // Ajouter une logique pour la redirection ou afficher plus d'informations
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Ouverture du service : $title")),
          );
        },
      ),
    );
  }
}
