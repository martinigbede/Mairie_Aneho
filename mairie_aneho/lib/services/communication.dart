import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecuritePage extends StatelessWidget {
  const SecuritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: const Text("Communication"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Service de la communication',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Accédez aux informations sur les services de la communication de la commune.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  _serviceInfoCard(
                    context,
                    title: 'Annonces publiques',
                    description:
                        'Consultez les annonces publiques de la commune.',
                    icon: Icons.announcement,
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Pompier',
                    description:
                        'Accédez aux informations sur les services des pompiers.',
                    icon: Icons.local_fire_department,
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
        leading: Icon(icon, color: Colors.red[700]),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(description),
        onTap: () {
          // Ajouter une logique pour rediriger ou afficher plus d'informations
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Ouverture du service : $title")),
          );
        },
      ),
    );
  }
}
