import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Assurez-vous que ces chemins d'accès sont corrects dans votre projet
import 'package:mairie_aneho/screens/historique_page.dart';
import '../auth/login.dart';
import '../services/etat_civil_page.dart';
import '../services/autres_page.dart';

class CitoyenHome extends StatefulWidget {
  const CitoyenHome({super.key});

  @override
  State<CitoyenHome> createState() => _CitoyenHomeState();
}

class _CitoyenHomeState extends State<CitoyenHome> {
  int _selectedIndex = 0;

  // CLASSE CORRIGÉE : Utilisation d'AccueilPageContent (nom public)
  final List<Widget> _pages = const [
    AccueilPageContent(),
    HistoriqueDemandesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context) {
    // Utilisation de pushAndRemoveUntil pour nettoyer la pile de navigation
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (Route<dynamic> route) => false, 
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.teal[800];
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 4,
        title: Text(
          'Espace Citoyen',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[500],
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
      ),
    );
  }
}

// CORRECTION : Renommage de _AccueilPageContent en AccueilPageContent
class AccueilPageContent extends StatelessWidget {
  const AccueilPageContent({super.key});

  // Liste de services contenant UNIQUEMENT les deux éléments demandés
  Map<String, dynamic> _getService(int index) {
    final List<Map<String, dynamic>> services = [
      {
        "label": "État Civil",
        "icon": Icons.assignment,
        "color": Colors.teal,
        "page": const EtatCivilPage(),
      },
      {
        "label": "Autres Services", 
        "icon": Icons.more_horiz,
        "color": Colors.grey,
        "page": const AutresPage(),
      },
    ];
    
    // Ajout d'une vérification pour éviter les erreurs, bien que itemCount soit corrigé
    if (index >= 0 && index < services.length) {
        return services[index];
    }
    // Fallback sécurisé (ne devrait pas être atteint)
    throw Exception('Index de service hors limites.');
  }

  Widget _serviceCard(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Card(
        elevation: 8,
        shadowColor: color.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carte de Bienvenue (Header)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.teal[700],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_circle, color: Colors.white, size: 48),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenue !',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Accédez aux services municipaux',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          Text(
            'Services Disponibles',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          // Grille des services
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              // CORRECTION CLÉ : itemCount fixé à 2
              itemCount: 2, 
              itemBuilder: (context, index) {
                final service = _getService(index);
                return _serviceCard(
                  context,
                  label: service['label'] as String,
                  icon: service['icon'] as IconData,
                  color: service['color'] as Color,
                  page: service['page'] as Widget,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}