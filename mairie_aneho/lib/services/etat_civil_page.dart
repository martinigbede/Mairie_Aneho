import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services_etat_civil/acte_naissance_form_page.dart';

class EtatCivilPage extends StatelessWidget {
  const EtatCivilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8), // Couleur de fond douce
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        elevation: 4,
        centerTitle: true,
        title: Text(
          "État Civil",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre principal
            Text(
              'Service d\'État Civil',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Accédez à vos documents administratifs et faites vos demandes facilement.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Liste des services
            Expanded(
              child: ListView(
                children: [
                  _serviceInfoCard(
                    context,
                    title: 'Demande de Certificat de Naissance',
                    description:
                        'Faites une demande de certificat de naissance pour vous ou vos proches.',
                    icon: Icons.assignment_ind,
                    color: Colors.teal,
                    navigateTo: const NaissanceForm(),
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Jugement supplétif d\'acte de naissance',
                    description:
                        'Faites une demande de jugement supplétif pour les actes de naissance non enregistrés.',
                    icon: Icons.gavel,
                    color: Colors.indigo,
                    navigateTo: null,
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Légalisation de documents',
                    description:
                        'Demandez la légalisation officielle de vos documents administratifs.',
                    icon: Icons.document_scanner,
                    color: Colors.orange,
                    navigateTo: null,
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Acte de Mariage',
                    description:
                        'Obtenez un extrait ou faites une demande d\'acte de mariage.',
                    icon: Icons.favorite,
                    color: Colors.pink,
                    navigateTo: null,
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Certificat de Décès',
                    description:
                        'Demandez un certificat de décès pour vos démarches administratives.',
                    icon: Icons.local_florist,
                    color: Colors.redAccent,
                    navigateTo: null,
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
    required Color color,
    required Widget? navigateTo,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          radius: 26,
          child: Icon(icon, size: 28, color: color),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          description,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
        ),
        onTap: () {
          if (navigateTo != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => navigateTo),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Le service \"$title\" n'est pas encore disponible.",
                ),
                backgroundColor: Colors.teal[700],
              ),
            );
          }
        },
      ),
    );
  }
}
