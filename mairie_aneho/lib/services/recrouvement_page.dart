import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Text("Recrouvement"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Service de recrouvement ',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Accédez aux informations sur l\'éducation et les écoles publiques.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  _serviceInfoCard(
                    context,
                    title: 'Inscription scolaire',
                    description:
                        'Inscrivez vos enfants dans les écoles publiques.',
                    icon: Icons.school,
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Bourse d\'Études',
                    description:
                        'Demandez une bourse d\'études pour vos enfants.',
                    icon: Icons.monetization_on,
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
        leading: Icon(icon, color: Colors.blue[700]),
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
