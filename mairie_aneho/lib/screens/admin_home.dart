import 'package:flutter/material.dart';
import 'admin/admin_dashboard_page.dart';
import 'admin/admin_pages/admin_agents_page.dart';
import 'admin/admin_pages/admin_demandes_page.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    AdminDashboardPage(),
    AdminAgentsPage(),
    AdminDemandesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal[800],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Agents'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Demandes',
          ),
        ],
      ),
    );
  }
}
