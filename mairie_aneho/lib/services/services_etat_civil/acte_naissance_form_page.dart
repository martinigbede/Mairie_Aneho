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
    );
    if (picked != null) {
      _dateNaissanceController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    bool confirmed = await _showConfirmationDialog();
    if (!confirmed) return;

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

      _showSuccessMessage();
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirmation'),
        content: Text('Voulez-vous soumettre cette déclaration de naissance ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Annuler')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text('Confirmer')),
        ],
      ),
    );
  }

  void _showSuccessMessage() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('✅ Succès'),
        content: Text('La déclaration a été enregistrée avec succès.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('❌ Erreur'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Fermer')),
        ],
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        keyboardType: keyboardType,
        validator: (val) => val == null || val.isEmpty ? 'Ce champ est requis' : null,
      ),
    );
  }

  Widget buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: _dateNaissanceController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Date de naissance',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () => _selectDate(context),
        validator: (val) => val == null || val.isEmpty ? 'Ce champ est requis' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Déclaration de Naissance")),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟨 Informations importantes
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                border: Border.all(color: Colors.amber),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("ℹ Informations importantes",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 8),
                  Text(
                    " La déclaration de naissance est obligatoire et doit être faite dans les 45 jours suivant la naissance au centre d'état civil ou, si à l'étranger, auprès des représentations diplomatiques du Togo.",
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 8),
                  Text(
                    " Pièces à fournir :\n- Attestation de naissance\n- Acte de naissance d’un parent ou carnet prénatal\n- Fiche de déclaration",
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 8),
                  Text(
                    " Dépôt : Lundi à Vendredi 07h-12h / 14h30-17h30\n📍 Annexes : Glidji, Zowla, Fiocondji, Adjido ;",
                    

                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            //  Formulaire
            Form(
              key: _formKey,
              child: Column(
                children: [
                  buildTextField(_nomEnfantController, 'Nom de l’enfant'),
                  DropdownButtonFormField(
                    value: _sexe,
                    decoration: InputDecoration(labelText: 'Sexe'),
                    items: ['Masculin', 'Féminin'].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                    onChanged: (val) => setState(() => _sexe = val!),
                  ),
                  buildDateField(),
                  buildTextField(_lieuNaissanceController, 'Lieu de naissance'),
                  Divider(),
                  buildTextField(_nomPrenomPereController, 'Nom & Prénom du père'),
                  buildTextField(_ageNationalitePereController, 'Âge et nationalité du père'),
                  buildTextField(_professionPereController, 'Profession du père'),
                  buildTextField(_domicilePereController, 'Domicile du père'),
                  Divider(),
                  buildTextField(_nomPrenomMereController, 'Nom & Prénom de la mère'),
                  buildTextField(_ageNationaliteMereController, 'Âge et nationalité de la mère'),
                  buildTextField(_professionMereController, 'Profession de la mère'),
                  buildTextField(_domicileMereController, 'Domicile de la mère'),
                  Divider(),
                  buildTextField(_nomPrenomDeclarantController, 'Nom & Prénom du déclarant'),
                  buildTextField(_lienDeclarantController, 'Lien avec l’enfant'),
                  buildTextField(_telephoneController, 'Téléphone', keyboardType: TextInputType.phone),
                  CheckboxListTile(
                    title: Text("Le père est le déclarant"),
                    value: _pereEstDeclarant,
                    onChanged: (val) => setState(() => _pereEstDeclarant = val!),
                  ),
                  CheckboxListTile(
                    title: Text("La mère est le déclarant"),
                    value: _mereEstDeclarant,
                    onChanged: (val) => setState(() => _mereEstDeclarant = val!),
                  ),
                  Divider(),
                  buildTextField(_nbEnfantsVieController, 'Nombre d’enfants vivants', keyboardType: TextInputType.number),
                  buildTextField(_nbEnfantsDecedesController, 'Nombre d’enfants décédés', keyboardType: TextInputType.number),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text("Soumettre la déclaration"),
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
