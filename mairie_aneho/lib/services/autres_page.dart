import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Importez ici les formulaires ou pages de services spécifiques si elles existent.
// Exemple : import 'services_autres/declaration_impot_form.dart';

class AutresPage extends StatelessWidget {
  const AutresPage({super.key});

  // Utilisation de la même fonction de carte pour une cohérence de design
  Widget _serviceInfoCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Widget? navigateTo, // Widget de destination (null si non implémenté)
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
        trailing: navigateTo != null 
            ? Icon(Icons.arrow_forward_ios, size: 16, color: color)
            : const Icon(Icons.lock_clock, size: 18, color: Colors.grey),
        onTap: () {
          if (navigateTo != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => navigateTo),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Le service \"$title\" n'est pas encore disponible."),
                backgroundColor: color,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.teal.shade800; 

    return Scaffold(
      backgroundColor: Colors.grey[50], // Fond cohérent
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Autres Services",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Démarches Administratives',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Accédez aux démarches non liées à l\'état civil.',
              style: GoogleFonts.poppins(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  // --- Section Urbanisme et Construction ---
                  _serviceInfoCard(
                    context,
                    title: 'Permis de Construire',
                    description: 'Demande de permis pour tout nouveau projet de construction.',
                    icon: Icons.apartment,
                    color: Colors.blue,
                    navigateTo: null, // Mettez ici le widget du formulaire de permis
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Certificat d\'Urbanisme',
                    description: 'Renseignements sur les règles d\'urbanisme applicables à un terrain.',
                    icon: Icons.location_city,
                    color: Colors.lightBlue,
                    navigateTo: null,
                  ),
                  
                  // --- Section Taxes et Impôts ---
                  _serviceInfoCard(
                    context,
                    title: 'Déclaration des Taxes Locales',
                    description: 'Déclarez et payez vos taxes et impôts locaux en ligne.',
                    icon: Icons.account_balance_wallet,
                    color: Colors.green,
                    navigateTo: null, // Mettez ici le widget du formulaire de taxes
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Paiement de Redevance',
                    description: 'Paiement des redevances diverses (marché, occupation de voirie, etc.).',
                    icon: Icons.receipt_long,
                    color: Colors.lightGreen,
                    navigateTo: null,
                  ),
                  
                  // --- Section Social et Divers ---
                  _serviceInfoCard(
                    context,
                    title: 'Réclamation et Suggestion',
                    description: 'Déposez une plainte ou une suggestion concernant les services de la mairie.',
                    icon: Icons.feedback,
                    color: Colors.orange,
                    navigateTo: null,
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Demande de Rendez-vous',
                    description: 'Planifiez un rendez-vous avec un agent municipal ou le Maire.',
                    icon: Icons.calendar_month,
                    color: Colors.deepPurple,
                    navigateTo: null,
                  ),
                  _serviceInfoCard(
                    context,
                    title: 'Information sur les Projets',
                    description: 'Accédez aux informations concernant les projets et actualités de la Mairie.',
                    icon: Icons.campaign,
                    color: Colors.brown,
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
}