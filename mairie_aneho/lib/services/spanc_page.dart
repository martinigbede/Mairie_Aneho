import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SantePubliquePage extends StatelessWidget {
  const SantePubliquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Spanc"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Service du Spanc',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Accédez aux services de santé publique et faites vos démarches.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  _serviceInfoCard(
                    context,
                    title: 'Vidange de fosse',
                    description:
                        'Demandez une vidange de fosse septique en ligne.',
                    icon: Icons.cleaning_services,
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Assainissement',
                    description:
                        'Accédez aux informations sur les services d\'assainissement.',
                    icon: Icons.water_damage,
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Hygiène publique',
                    description:
                        'Consultez les informations sur l\'hygiène publique.',
                    icon: Icons.health_and_safety,
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
        leading: Icon(icon, color: Colors.green[700]),
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
