// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TechniquePage extends StatelessWidget {
  const TechniquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        title: const Text('Services Techniques'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Titre de la page
            Text(
              'Tout les Services Techniques',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            // Description de la page
            Text(
              'Découvrez les autres services municipaux qui ne sont pas listés précédemment.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),

            // Contenu de la page (exemple de liste ou autres widgets)
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.help, color: Colors.teal[800]),
                    title: Text(
                      'Service Général',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                    onTap: () {
                      // Action pour ce service
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Service général sélectionné'),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.feedback, color: Colors.teal[800]),
                    title: Text(
                      'Feedback',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                    onTap: () {
                      // Action pour le feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Feedback sélectionné')),
                      );
                    },
                  ),
                  // Ajoute d'autres services ici si nécessaire
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
