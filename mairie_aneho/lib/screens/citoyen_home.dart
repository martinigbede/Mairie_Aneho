import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mairie_aneho/screens/historique_page.dart';
import '../auth/login.dart';
import '../services/etat_civil_page.dart';
import '../services/sante_publique_page.dart';
import '../services/urbanisme_page.dart';
import '../services/securite_page.dart';
import '../services/education_page.dart';
import '../services/autres_page.dart';

class CitoyenHome extends StatefulWidget {
  const CitoyenHome({super.key});

  @override
  State<CitoyenHome> createState() => _CitoyenHomeState();
}

class _CitoyenHomeState extends State<CitoyenHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [_AccueilPageContent(), HistoriqueDemandesPage()];

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
      appBar: AppBar(
        title: const Text('Accueil Citoyen'),
        backgroundColor: Colors.teal[800],
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[800],
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenue !',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Accédez facilement aux services municipaux et faites vos demandes en toute simplicité',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: 6,
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
        "label": "Urbanisme",
        "icon": Icons.location_city,
        "color": Colors.amber[700]!,
        "page": const UrbanismePage(),
      },
      {
        "label": "Santé",
        "icon": Icons.local_hospital,
        "color": Colors.blue[800]!,
        "page": const SantePubliquePage(),
      },
      {
        "label": "Sécurité",
        "icon": Icons.security,
        "color": Colors.black87,
        "page": const SecuritePage(),
      },
      {
        "label": "Éducation",
        "icon": Icons.school,
        "color": Colors.green[700]!,
        "page": const EducationPage(),
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
        elevation: 5,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 40),
              const SizedBox(height: 10),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
