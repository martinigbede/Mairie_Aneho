import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExtraitActeForm extends StatelessWidget {
  const ExtraitActeForm({super.key});

  // Widget pour afficher clairement les sections d'information
  Widget _buildInfoSection({
    required String title,
    required Widget content,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const Divider(color: Colors.black26, height: 15),
        content,
        const SizedBox(height: 10),
      ],
    );
  }

  // Widget pour la section Tarifs
  Widget _buildTarifSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTarifItem(
          'Acte de Naissance et de Mariage',
          '1000 FCFA',
          primaryColor,
        ),
        _buildTarifItem(
          'Acte de Décès',
          '3000 FCFA',
          primaryColor,
        ),
        const SizedBox(height: 10),
        Text(
          'Paiement effectué à la régie des recettes de la Mairie d’Aného contre quittance.',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  // Sous-widget pour chaque élément de tarif
  Widget _buildTarifItem(String label, String price, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
          ),
          Text(
            price,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.indigo;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: Text(
          "Extrait d’un acte d’état civil",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Extrait d’un acte d’état civil',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Il s’agit de faire sortir les informations essentielles de l’acte de naissance sur un extrait.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // --- Section Pièces à Fournir ---
            _buildInfoSection(
              title: 'Pièces à Fournir',
              color: primaryColor,
              icon: Icons.description,
              content: Text(
                'La **copie de l’acte de naissance** (original ou photocopie lisible).',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
            
            // --- Section Lieu et Horaires ---
            _buildInfoSection(
              title: 'Dépôt et Retrait',
              color: Colors.blueGrey.shade700,
              icon: Icons.location_on,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📍 Lieu : **État civil central à la Mairie d’Aného**',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '🕒 Dépôt (Jours ouvrables) : **07h00 à 12h00** puis de **14h30 à 17h30**',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '⏱️ Retrait : **24 heures après le dépôt**',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            // --- Section Tarifs ---
            _buildInfoSection(
              title: 'Tarifs',
              color: Colors.green.shade700,
              icon: Icons.money,
              content: _buildTarifSection(Colors.green.shade700),
            ),

            // --- Section Contact ---
            _buildInfoSection(
              title: 'Personnes de Contact',
              color: Colors.orange.shade700,
              icon: Icons.contact_phone,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📞 Standard : **70 52 67 67**',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '📧 Email : **contactmairieaneho@lacs1.mairie.tg**',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            
            // Option pour une action (simuler une demande en ligne si possible)
            ElevatedButton.icon(
              onPressed: () {
                // Vous pouvez ajouter ici un lien vers un formulaire de pré-demande
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Le dépôt se fait uniquement au bureau de l'État Civil central."),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Soumettre une pré-demande (si supporté)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}