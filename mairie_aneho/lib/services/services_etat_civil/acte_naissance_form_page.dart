import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class NaissanceForm extends StatefulWidget {
  const NaissanceForm({Key? key}) : super(key: key);

  @override
  State<NaissanceForm> createState() => _NaissanceFormState();
}

class _NaissanceFormState extends State<NaissanceForm> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Champs
  final _nomEnfantController = TextEditingController();
  final _dateNaissanceController = TextEditingController();
  final _lieuNaissanceController = TextEditingController();
  final _nomPrenomPereController = TextEditingController();
  final _ageNationalitePereController = TextEditingController();
  final _professionPereController = TextEditingController();
  final _domicilePereController = TextEditingController();
  final _nomPrenomMereController = TextEditingController();
  final _ageNationaliteMereController = TextEditingController();
  final _professionMereController = TextEditingController();
  final _domicileMereController = TextEditingController();
  final _nomPrenomDeclarantController = TextEditingController();
  final _lienDeclarantController = TextEditingController();
  final _nbEnfantsVieController = TextEditingController();
  final _nbEnfantsDecedesController = TextEditingController();
  final _telephoneController = TextEditingController();

  String _sexe = 'Masculin';
  bool _pereEstDeclarant = false;
  bool _mereEstDeclarant = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nomEnfantController.dispose();
    _dateNaissanceController.dispose();
    _lieuNaissanceController.dispose();
    _nomPrenomPereController.dispose();
    _ageNationalitePereController.dispose();
    _professionPereController.dispose();
    _domicilePereController.dispose();
    _nomPrenomMereController.dispose();
    _ageNationaliteMereController.dispose();
    _professionMereController.dispose();
    _domicileMereController.dispose();
    _nomPrenomDeclarantController.dispose();
    _lienDeclarantController.dispose();
    _nbEnfantsVieController.dispose();
    _nbEnfantsDecedesController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF2E7D32),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _dateNaissanceController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ Veuillez remplir tous les champs obligatoires'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    bool confirmed = await _showConfirmationDialog();
    if (!confirmed) return;

    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Utilisateur non connecté");

      final formData = {
        'enfant': {
          'nom': _nomEnfantController.text,
          'sexe': _sexe,
          'date_naissance': _dateNaissanceController.text,
          'lieu_naissance': _lieuNaissanceController.text,
        },
        'pere': {
          'nom': _nomPrenomPereController.text,
          'age': _ageNationalitePereController.text,
          'profession': _professionPereController.text,
          'domicile': _domicilePereController.text,
        },
        'mere': {
          'nom': _nomPrenomMereController.text,
          'age_nationalite': _ageNationaliteMereController.text,
          'profession': _professionMereController.text,
          'domicile': _domicileMereController.text,
        },
        'declarant': {
          'nom': _nomPrenomDeclarantController.text,
          'lien': _lienDeclarantController.text,
          'telephone': _telephoneController.text,
          'pere_est_declarant': _pereEstDeclarant,
          'mere_est_declarant': _mereEstDeclarant,
        },
        'enfants_anterieurs': {
          'vivants': _nbEnfantsVieController.text,
          'decedes': _nbEnfantsDecedesController.text,
        },
      };

      await FirebaseFirestore.instance.collection('citizen_requests').add({
        'uid': user.uid,
        'form_type': 'naissance',
        'form_data': formData,
        'created_at': Timestamp.now(),
        'status': 'En attente',
      });

      setState(() => _isSubmitting = false);
      _showSuccessMessage();
    } catch (e) {
      setState(() => _isSubmitting = false);
      _showErrorDialog(e.toString());
    }
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.help_outline, color: Color(0xFF2E7D32)),
            SizedBox(width: 12),
            Text('Confirmation'),
          ],
        ),
        content: Text(
          'Voulez-vous soumettre cette déclaration de naissance ?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Annuler', style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Confirmer'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showSuccessMessage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle, color: Colors.green, size: 48),
            ),
            SizedBox(height: 16),
            Text('Succès !', style: TextStyle(color: Colors.green[700])),
          ],
        ),
        content: Text(
          'Votre déclaration a été enregistrée avec succès. Vous recevrez une notification dès qu\'elle sera traitée.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text('OK', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 12),
            Text('Erreur'),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF2E7D32)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        keyboardType: keyboardType,
        validator: (val) => val == null || val.isEmpty ? 'Champ requis' : null,
      ),
    );
  }

  Widget buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _dateNaissanceController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Date de naissance',
          prefixIcon: Icon(Icons.calendar_month, color: Color(0xFF2E7D32)),
          suffixIcon: Icon(Icons.arrow_drop_down),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        onTap: () => _selectDate(context),
        validator: (val) => val == null || val.isEmpty ? 'Champ requis' : null,
      ),
    );
  }

  Widget buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Color(0xFF2E7D32), size: 24),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Déclaration de Naissance"),
        backgroundColor: Color(0xFF2E7D32),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête avec informations importantes
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange[800], size: 28),
                          SizedBox(width: 12),
                          Text(
                            "Informations importantes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.orange[900],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _buildInfoRow(Icons.access_time, "Délai : 45 jours après la naissance"),
                      _buildInfoRow(Icons.description, "Documents : Attestation, acte parent, fiche"),
                      _buildInfoRow(Icons.schedule, "Horaires : Lun-Ven 7h-12h / 14h30-17h30"),
                      _buildInfoRow(Icons.location_on, "Annexes : Glidji, Zowla, Fiocondji, Adjido"),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Formulaire
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Section Enfant
                      buildSectionCard(
                        title: "Informations de l'enfant",
                        icon: Icons.child_care,
                        children: [
                          buildTextField(_nomEnfantController, 'Nom complet de l\'enfant', Icons.person),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: DropdownButtonFormField(
                              value: _sexe,
                              decoration: InputDecoration(
                                labelText: 'Sexe',
                                prefixIcon: Icon(Icons.wc, color: Color(0xFF2E7D32)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              items: [
                                DropdownMenuItem(value: 'Masculin', child: Row(
                                  children: [
                                    Icon(Icons.male, size: 20),
                                    SizedBox(width: 8),
                                    Text('Masculin'),
                                  ],
                                )),
                                DropdownMenuItem(value: 'Féminin', child: Row(
                                  children: [
                                    Icon(Icons.female, size: 20),
                                    SizedBox(width: 8),
                                    Text('Féminin'),
                                  ],
                                )),
                              ],
                              onChanged: (val) => setState(() => _sexe = val!),
                            ),
                          ),
                          buildDateField(),
                          buildTextField(_lieuNaissanceController, 'Lieu de naissance', Icons.location_city),
                        ],
                      ),

                      // Section Père
                      buildSectionCard(
                        title: "Informations du père",
                        icon: Icons.man,
                        children: [
                          buildTextField(_nomPrenomPereController, 'Nom & Prénom', Icons.badge),
                          buildTextField(_ageNationalitePereController, 'Âge et nationalité', Icons.public),
                          buildTextField(_professionPereController, 'Profession', Icons.work),
                          buildTextField(_domicilePereController, 'Domicile', Icons.home),
                        ],
                      ),

                      // Section Mère
                      buildSectionCard(
                        title: "Informations de la mère",
                        icon: Icons.woman,
                        children: [
                          buildTextField(_nomPrenomMereController, 'Nom & Prénom', Icons.badge),
                          buildTextField(_ageNationaliteMereController, 'Âge et nationalité', Icons.public),
                          buildTextField(_professionMereController, 'Profession', Icons.work),
                          buildTextField(_domicileMereController, 'Domicile', Icons.home),
                        ],
                      ),

                      // Section Déclarant
                      buildSectionCard(
                        title: "Informations du déclarant",
                        icon: Icons.assignment_ind,
                        children: [
                          buildTextField(_nomPrenomDeclarantController, 'Nom & Prénom', Icons.person_outline),
                          buildTextField(_lienDeclarantController, 'Lien avec l\'enfant', Icons.family_restroom),
                          buildTextField(_telephoneController, 'Téléphone', Icons.phone, keyboardType: TextInputType.phone),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CheckboxListTile(
                              title: Text("Le père est le déclarant"),
                              value: _pereEstDeclarant,
                              activeColor: Color(0xFF2E7D32),
                              onChanged: (val) => setState(() => _pereEstDeclarant = val!),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.pink[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CheckboxListTile(
                              title: Text("La mère est le déclarant"),
                              value: _mereEstDeclarant,
                              activeColor: Color(0xFF2E7D32),
                              onChanged: (val) => setState(() => _mereEstDeclarant = val!),
                            ),
                          ),
                        ],
                      ),

                      // Section Enfants antérieurs
                      buildSectionCard(
                        title: "Enfants antérieurs",
                        icon: Icons.groups,
                        children: [
                          buildTextField(_nbEnfantsVieController, 'Nombre d\'enfants vivants', Icons.favorite, keyboardType: TextInputType.number),
                          buildTextField(_nbEnfantsDecedesController, 'Nombre d\'enfants décédés', Icons.heart_broken, keyboardType: TextInputType.number),
                        ],
                      ),

                      // Bouton de soumission
                      Container(
                        width: double.infinity,
                        height: 56,
                        margin: EdgeInsets.only(bottom: 40),
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2E7D32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                          child: _isSubmitting
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.send, size: 24),
                                    SizedBox(width: 12),
                                    Text(
                                      "Soumettre la déclaration",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.orange[700]),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}