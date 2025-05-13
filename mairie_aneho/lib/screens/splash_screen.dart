import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mairie_aneho/screens/admin_home.dart';

// import 'admin/admin_dashboard_page.dart';
import 'citoyen_home.dart';
import 'service_carousel_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<Map<String, dynamic>> services = [
    {"label": "État Civil", "icon": Icons.assignment},
    {"label": "Urbanisme", "icon": Icons.location_city},
    {"label": "Santé Publique", "icon": Icons.local_hospital},
    {"label": "Sécurité", "icon": Icons.security},
    {"label": "Éducation", "icon": Icons.school},
  ];

  int _currentServiceIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAnimations();
    _checkUserStatus();
  }

  Timer? _animationTimer;
  void _startAnimations() {
    _animationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;

      if (_currentServiceIndex < services.length - 1) {
        setState(() {
          _currentServiceIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkUserStatus() async {
    await Future.delayed(const Duration(seconds: 4)); // Attendre un peu

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // L'utilisateur est connecté, on lit son rôle
      try {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        final role = doc.data()?['role'];

        if (role == 'citoyen') {
          _redirectTo(const CitoyenHome());
        } else if (role == 'agent') {
          _redirectTo(const AdminHome());
        } else if (role == 'admin') {
          _redirectTo(const AdminHome());
        } else {
          // Rôle non reconnu → on continue vers la page d’accueil
          _redirectTo(const ServiceCarouselPage());
        }
      } catch (e) {
        // Erreur Firestore → on continue vers la page d’accueil
        _redirectTo(const ServiceCarouselPage());
      }
    } else {
      // Pas connecté → on continue vers la page d’accueil
      Future.delayed(const Duration(seconds: 8), () {
        _redirectTo(const ServiceCarouselPage());
      });
    }
  }

  void _redirectTo(Widget page) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final service = services[_currentServiceIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 2),
                curve: Curves.elasticOut,
                builder:
                    (_, value, child) =>
                        Transform.scale(scale: value, child: child),
                child: Image.asset(
                  'assets/logo_mairie.png',
                  width: 300,
                  height: 300,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Commune Lac 1',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Mairie d’Aného',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.teal[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: Row(
                  key: ValueKey(_currentServiceIndex),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(service["icon"], size: 30, color: Colors.teal[700]),
                    const SizedBox(width: 10),
                    Text(
                      service["label"],
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const CircularProgressIndicator(
                color: Colors.teal,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
