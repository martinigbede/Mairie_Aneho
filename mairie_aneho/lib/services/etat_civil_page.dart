import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mairie_aneho/services/services_etat_civil/extrait_d%E2%80%99un_acte_d%E2%80%99%C3%A9tat_civil_page.dart';
import 'services_etat_civil/acte_naissance_form_page.dart';

class EtatCivilPage extends StatefulWidget {
  const EtatCivilPage({super.key});

  @override
  State<EtatCivilPage> createState() => _EtatCivilPageState();
}

class _EtatCivilPageState extends State<EtatCivilPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  final List<ServiceItem> _services = [
    ServiceItem(
      title: 'Déclaration de Naissance',
      description: 'Déclarez la naissance de votre enfant en ligne, rapidement et en toute sécurité.',
      icon: Icons.baby_changing_station,
      color: Color(0xFF2E7D32),
      category: 'Naissance',
      route: 'naissance',
      isAvailable: true,
    ),
    ServiceItem(
      title: 'Extrait d\'acte de naissance',
      description: 'Obtenez un extrait officiel de votre acte de naissance avec les informations essentielles.',
      icon: Icons.article,
      color: Color(0xFF1976D2),
      category: 'Naissance',
      route: 'extrait',
      isAvailable: true,
    ),
    ServiceItem(
      title: 'Copie intégrale',
      description: 'Demandez une reproduction complète de votre acte de naissance.',
      icon: Icons.content_copy,
      color: Color(0xFFE65100),
      category: 'Naissance',
      route: null,
      isAvailable: false,
    ),
    ServiceItem(
      title: 'Déclaration de Mariage',
      description: 'Déclarez votre intention de mariage auprès de l\'état civil.',
      icon: Icons.favorite,
      color: Color(0xFFC2185B),
      category: 'Mariage',
      route: null,
      isAvailable: false,
    ),
    ServiceItem(
      title: 'Certificat de célibat',
      description: 'Obtenez une attestation officielle de votre statut de célibataire.',
      icon: Icons.person_outline,
      color: Color(0xFF5E35B1),
      category: 'Mariage',
      route: null,
      isAvailable: false,
    ),
    ServiceItem(
      title: 'Déclaration de Décès',
      description: 'Déclarez le décès d\'un proche dans les délais légaux.',
      icon: Icons.church,
      color: Color(0xFF424242),
      category: 'Décès',
      route: null,
      isAvailable: false,
    ),
    ServiceItem(
      title: 'Transcription',
      description: 'Transcrivez un jugement supplétif en acte de naissance officiel.',
      icon: Icons.gavel,
      color: Color(0xFF00796B),
      category: 'Autres',
      route: null,
      isAvailable: false,
    ),
    ServiceItem(
      title: 'Changement de nom',
      description: 'Modifiez officiellement votre nom de famille ou prénom.',
      icon: Icons.edit,
      color: Color(0xFF6A1B9A),
      category: 'Autres',
      route: null,
      isAvailable: false,
    ),
    ServiceItem(
      title: 'Rectification d\'acte',
      description: 'Corrigez les erreurs matérielles présentes sur vos actes d\'état civil.',
      icon: Icons.auto_fix_high,
      color: Color(0xFF795548),
      category: 'Autres',
      route: null,
      isAvailable: false,
    ),
    ServiceItem(
      title: 'Certificat de nationalité',
      description: 'Obtenez une attestation officielle de votre nationalité togolaise.',
      icon: Icons.flag,
      color: Color(0xFF0277BD),
      category: 'Autres',
      route: null,
      isAvailable: false,
    ),
    ServiceItem(
      title: 'Droit de recherche',
      description: 'Recherchez un acte d\'état civil dans nos archives officielles.',
      icon: Icons.search,
      color: Color(0xFFD32F2F),
      category: 'Autres',
      route: null,
      isAvailable: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ServiceItem> get _filteredServices {
    if (_searchQuery.isEmpty) return _services;
    return _services.where((service) {
      return service.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<ServiceItem> _getServicesByCategory(String category) {
    if (category == 'Tous') return _filteredServices;
    return _filteredServices.where((s) => s.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // AppBar moderne avec dégradé
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: Color(0xFF2E7D32),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E7D32), Color(0xFF388E3C), Color(0xFF1B5E20)],
                  ),
                ),
                child: Stack(
                  children: [
                    // Motifs décoratifs
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    // Contenu
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.account_balance, color: Colors.white, size: 32),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'État Civil',
                                        style: GoogleFonts.poppins(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Service en ligne',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Accédez à tous vos services d\'état civil rapidement et en toute sécurité.',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.95),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Barre de recherche
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un service...',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF2E7D32)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ),
            ),
          ),

          // Onglets de catégories
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Color(0xFF2E7D32),
                indicatorWeight: 3,
                labelColor: Color(0xFF2E7D32),
                unselectedLabelColor: Colors.grey[600],
                labelStyle: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(text: 'Tous'),
                  Tab(text: 'Naissance'),
                  Tab(text: 'Mariage'),
                  Tab(text: 'Décès'),
                  Tab(text: 'Autres'),
                ],
              ),
            ),
          ),

          // Contenu des onglets
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildServiceGrid('Tous'),
                _buildServiceGrid('Naissance'),
                _buildServiceGrid('Mariage'),
                _buildServiceGrid('Décès'),
                _buildServiceGrid('Autres'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceGrid(String category) {
    final services = _getServicesByCategory(category);

    if (services.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            SizedBox(height: 16),
            Text(
              'Aucun service trouvé',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) => _buildServiceCard(services[index]),
    );
  }

  Widget _buildServiceCard(ServiceItem service) {
    return GestureDetector(
      onTap: () => _handleServiceTap(service),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: service.color.withOpacity(0.15),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Badge disponibilité
            if (!service.isAvailable)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Bientôt',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.orange[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icône
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          service.color,
                          service.color.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: service.color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(service.icon, color: Colors.white, size: 28),
                  ),
                  
                  SizedBox(height: 12),
                  
                  // Titre
                  Text(
                    service.title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: 8),
                  
                  // Description
                  Expanded(
                    child: Text(
                      service.description,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  // Bouton
                  Container(
                    width: double.infinity,
                    height: 36,
                    decoration: BoxDecoration(
                      color: service.isAvailable 
                          ? service.color.withOpacity(0.1)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          service.isAvailable ? 'Accéder' : 'Prochainement',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: service.isAvailable 
                                ? service.color
                                : Colors.grey[600],
                          ),
                        ),
                        if (service.isAvailable) ...[
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: service.color,
                          ),
                        ],
                      ],
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

  void _handleServiceTap(ServiceItem service) {
    if (!service.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Le service "${service.title}" sera bientôt disponible.',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.all(16),
        ),
      );
      return;
    }

    // Navigation vers les formulaires
    Widget? destination;
    switch (service.route) {
      case 'naissance':
        destination = const NaissanceForm();
        break;
      case 'extrait':
        destination = const ExtraitActeForm();
        break;
    }

    if (destination != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination!),
      );
    }
  }
}

// Classe pour les items de service
class ServiceItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String category;
  final String? route;
  final bool isAvailable;

  ServiceItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
    required this.route,
    required this.isAvailable,
  });
}

// Delegate pour le TabBar sticky
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Color(0xFFF5F7FA),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}