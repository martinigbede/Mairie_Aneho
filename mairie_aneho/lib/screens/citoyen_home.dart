import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mairie_aneho/screens/historique_page.dart';
import '../auth/login.dart';
import '../services/etat_civil_page.dart';
import '../services/spanc_page.dart';
import '../services/selpt_page.dart';
import '../services/communication.dart';
import '../services/recrouvement_page.dart';
import '../services/autres_page.dart';
import '../services/technique_page.dart';

class CitoyenHome extends StatefulWidget {
  const CitoyenHome({super.key});

  @override
  State<CitoyenHome> createState() => _CitoyenHomeState();
}

class _CitoyenHomeState extends State<CitoyenHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    _AccueilPageContent(),
    const HistoriqueDemandesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 4,
        title: Text(
          'Espace Citoyen',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.teal[800],
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
        selectedItemColor: Colors.teal[800],
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

class _AccueilPageContent extends StatelessWidget {
  const _AccueilPageContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                Column(
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
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: 7,
              itemBuilder: (context, index) {
                final service = _getService(index);
                return _serviceCard(
                  context,
                  label: service['label'],
                  icon: service['icon'],
                  color: service['color'],
                  page: service['page'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getService(int index) {
    final services = [
      {
        "label": "État Civil",
        "icon": Icons.assignment,
        "color": Colors.teal,
        "page": const EtatCivilPage(),
      },
      {
        "label": "Selpt",
        "icon": Icons.location_on,
        "color": Colors.amber[700]!,
        "page": const UrbanismePage(),
      },
      {
        "label": "Spanc",
        "icon": Icons.nature_people,
        "color": Colors.blue[800]!,
        "page": const SantePubliquePage(),
      },
      {
        "label": "Communication",
        "icon": Icons.forum,
        "color": Colors.black87,
        "page": const SecuritePage(),
      },
      {
        "label": "Recouvrement",
        "icon": Icons.assignment_returned,
        "color": Colors.green[700]!,
        "page": const EducationPage(),
      },
      {
        "label": "Service Technique",
        "icon": Icons.build,
        "color": const Color.fromARGB(255, 70, 69, 50),
        "page": const TechniquePage(),
      },
      {
        "label": "Autres",
        "icon": Icons.more_horiz,
        "color": Colors.grey,
        "page": const AutresPage(),
      },
    ];
    return services[index];
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
}
