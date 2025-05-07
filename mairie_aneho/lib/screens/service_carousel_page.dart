import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'welcome_page.dart';

class ServiceCarouselPage extends StatefulWidget {
  const ServiceCarouselPage({super.key});

  @override
  State<ServiceCarouselPage> createState() => _ServiceCarouselPageState();
}

class _ServiceCarouselPageState extends State<ServiceCarouselPage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> services = [
    {
      "title": "État Civil",
      "description": "Actes de naissance, mariage, décès…",
      "icon": Icons.assignment,
    },
    {
      "title": "Urbanisme",
      "description": "Permis de construire, plans de lotissement…",
      "icon": Icons.location_city,
    },
    {
      "title": "Santé Publique",
      "description": "Campagnes de vaccination, salubrité…",
      "icon": Icons.local_hospital,
    },
    {
      "title": "Sécurité",
      "description": "Police municipale, prévention, secours…",
      "icon": Icons.security,
    },
    {
      "title": "Éducation",
      "description": "Soutien aux écoles, cantines scolaires…",
      "icon": Icons.school,
    },
  ];

  void _nextPage() {
    if (_currentIndex < services.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            // --- PAGEVIEW ---
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: services.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 40,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          service["icon"],
                          size: 100,
                          color: const Color.fromARGB(255, 80, 48, 0),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          service["title"],
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          service["description"],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // --- INDICATEURS + BOUTON ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      services.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              _currentIndex == index
                                  ? const Color.fromARGB(255, 0, 0, 0)
                                  : const Color.fromARGB(255, 80, 48, 0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 80, 48, 0),
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      _currentIndex == services.length - 1
                          ? "Commencer"
                          : "Suivant",
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
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
