import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services_etat_civil/acte_naissance_form_page.dart'; // Assure-toi d'importer le fichier contenant le formulaire

class EtatCivilPage extends StatelessWidget {
  const EtatCivilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        title: const Text("État Civil"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Titre du service
            Text(
              'Service d\'État Civil',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Accédez à vos documents administratifs et faites vos demandes.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            // Description du service
            Expanded(
              child: ListView(
                children: [
                  _serviceInfoCard(
                    context,
                    title: 'Demande de Certificat de Naissance',
                    description:
                        'Faites une demande de certificat de naissance pour vous ou vos proches.',
                    icon: Icons.assignment_ind,
                    navigateTo:
                        ActeNaissanceFormPage(), // Redirection vers le formulaire
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Jugement supplétif d\'acte de naissance',
                    description:
                        'Faites une demande de Jugement supplétif d\'acte de naissance pour vous ou vos proches.',
                    icon: Icons.assignment_ind,
                    navigateTo: null, // Lien à implémenter pour la légalisation
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Légalisation de documents',
                    description:
                        'Faites une demande de légalisation pour vous ou vos proches.',
                    icon: Icons.document_scanner,
                    navigateTo: null, // Lien à implémenter pour la légalisation
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Acte de Mariage',
                    description:
                        'Obtenez un extrait de votre acte de mariage ou faites une demande.',
                    icon: Icons.people,
                    navigateTo:
                        null, // Lien à implémenter pour l'acte de mariage
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Certificat de Décès',
                    description:
                        'Demandez un certificat de décès pour les démarches administratives.',
                    icon: Icons.delete_forever,
                    navigateTo:
                        null, // Lien à implémenter pour le certificat de décès
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
    required Widget? navigateTo, // Paramètre pour la page de redirection
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal[800]),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(description),
        onTap: () {
          if (navigateTo != null) {
            // Si une page est définie pour la redirection, on navigue vers celle-ci
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => navigateTo),
            );
          } else {
            // Si aucun formulaire spécifique n'est défini, affiche un message ou une autre action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Service $title non disponible pour le moment."),
              ),
            );
          }
        },
      ),
    );
  }
}
