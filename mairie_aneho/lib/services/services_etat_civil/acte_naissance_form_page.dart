import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mairie_aneho/services/etat_civil_page.dart';

class ActeNaissanceFormPage extends StatefulWidget {
  const ActeNaissanceFormPage({super.key});

  @override
  State<ActeNaissanceFormPage> createState() => _ActeNaissanceFormPageState();
}

class _ActeNaissanceFormPageState extends State<ActeNaissanceFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs texte
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

  // Sélections
  String? _sexe;
  bool _juge = false;
  bool _sageFemme = false;
  bool _autreAccoucheur = false;
  bool _aDesJumeaux = false;
  bool _acteMariageJoint = false;
  bool _mariageCoutumier = false;

  // Soumission Firestore
  Future<void> _showConfirmationDialog() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Vérification des informations"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nom de l'enfant : ${_nomEnfantController.text}"),
                  Text("Sexe : $_sexe"),
                  Text("Date de naissance : ${_dateNaissanceController.text}"),
                  Text("Lieu de naissance : ${_lieuNaissanceController.text}"),
                  Text("Nom père : ${_nomPrenomPereController.text}"),
                  Text("Nom mère : ${_nomPrenomMereController.text}"),
                  Text("Déclarant : ${_nomPrenomDeclarantController.text}"),
                  Text("Téléphone : ${_telephoneController.text}"),
                  const SizedBox(height: 10),
                  const Text("Souhaitez-vous envoyer ces informations ?"),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); // Fermer la boîte de dialogue
                  _showLoadingAndSubmit();
                },
                child: const Text("Confirmer et Envoyer"),
              ),
            ],
          ),
    );
  }

  Future<void> _showLoadingAndSubmit() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 3));
    Navigator.pop(context); // Fermer le chargement

    // Enregistrement Firestore
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('citizen_requests').add({
          'uid': user.uid,
          'service': 'État Civil - Déclaration Naissance',
          'status': 'En cours',
          'created_at': FieldValue.serverTimestamp(),
          'form_data': {
            'nom_enfant': _nomEnfantController.text,
            'sexe': _sexe,
            'date_naissance': _dateNaissanceController.text,
            'lieu_naissance': _lieuNaissanceController.text,
            'nom_prenom_pere': _nomPrenomPereController.text,
            'age_nationalite_pere': _ageNationalitePereController.text,
            'profession_pere': _professionPereController.text,
            'domicile_pere': _domicilePereController.text,
            'nom_prenom_mere': _nomPrenomMereController.text,
            'age_nationalite_mere': _ageNationaliteMereController.text,
            'profession_mere': _professionMereController.text,
            'domicile_mere': _domicileMereController.text,
            'nom_prenom_declarant': _nomPrenomDeclarantController.text,
            'lien_declarant': _lienDeclarantController.text,
            'juge': _juge,
            'sage_femme': _sageFemme,
            'autre_accoucheur': _autreAccoucheur,
            'jumeaux': _aDesJumeaux,
            'nb_enfants_vie': _nbEnfantsVieController.text,
            'nb_enfants_decedes': _nbEnfantsDecedesController.text,
            'acte_mariage_joint': _acteMariageJoint,
            'mariage_coutumier': _mariageCoutumier,
            'telephone': _telephoneController.text,
          },
        });

        // Redirection
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EtatCivilPage()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Demande envoyée avec succès !")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur : $e")));
    }
  }

  // Widget TextField
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? 'Ce champ est requis' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fiche de Déclaration de Naissance"),
        backgroundColor: Colors.teal[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Informations sur l'enfant",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildTextField(
                _nomEnfantController,
                'Nom et prénoms de l’enfant',
                '',
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Sexe :'),
                  Radio<String>(
                    value: 'Féminin',
                    groupValue: _sexe,
                    onChanged: (val) => setState(() => _sexe = val),
                  ),
                  const Text('Féminin'),
                  Radio<String>(
                    value: 'Masculin',
                    groupValue: _sexe,
                    onChanged: (val) => setState(() => _sexe = val),
                  ),
                  const Text('Masculin'),
                ],
              ),
              _buildTextField(
                _dateNaissanceController,
                'Date et heure de naissance',
                '',
              ),
              _buildTextField(
                _lieuNaissanceController,
                'Lieu de naissance',
                '',
              ),
              const SizedBox(height: 12),
              const Text(
                "Informations sur le père",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildTextField(_nomPrenomPereController, 'Nom et prénoms', ''),
              _buildTextField(
                _ageNationalitePereController,
                'Âge et nationalité',
                '',
              ),
              _buildTextField(_professionPereController, 'Profession', ''),
              _buildTextField(_domicilePereController, 'Domicile', ''),
              const SizedBox(height: 12),
              const Text(
                "Informations sur la mère",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildTextField(_nomPrenomMereController, 'Nom et prénoms', ''),
              _buildTextField(
                _ageNationaliteMereController,
                'Âge et nationalité',
                '',
              ),
              _buildTextField(_professionMereController, 'Profession', ''),
              _buildTextField(_domicileMereController, 'Domicile', ''),
              const SizedBox(height: 12),
              _buildTextField(
                _nomPrenomDeclarantController,
                'Nom, prénoms du déclarant',
                '',
              ),
              _buildTextField(
                _lienDeclarantController,
                'Profession et domicile du déclarant',
                '',
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text('Accouchement assisté par un juge'),
                value: _juge,
                onChanged: (val) => setState(() => _juge = val!),
              ),
              CheckboxListTile(
                title: const Text('Accouchement assisté par une sage-femme'),
                value: _sageFemme,
                onChanged: (val) => setState(() => _sageFemme = val!),
              ),
              CheckboxListTile(
                title: const Text(
                  'Accouchement assisté par une autre personne',
                ),
                value: _autreAccoucheur,
                onChanged: (val) => setState(() => _autreAccoucheur = val!),
              ),
              CheckboxListTile(
                title: const Text('L’enfant fait partie de jumeaux / triplés'),
                value: _aDesJumeaux,
                onChanged: (val) => setState(() => _aDesJumeaux = val!),
              ),
              _buildTextField(
                _nbEnfantsVieController,
                'Combien d’enfants déjà en vie ?',
                '',
              ),
              _buildTextField(
                _nbEnfantsDecedesController,
                'Combien d’enfants décédés ?',
                '',
              ),
              CheckboxListTile(
                title: const Text('Joindre une copie de l’acte de mariage'),
                value: _acteMariageJoint,
                onChanged: (val) => setState(() => _acteMariageJoint = val!),
              ),
              CheckboxListTile(
                title: const Text('Mariage coutumier'),
                value: _mariageCoutumier,
                onChanged: (val) => setState(() => _mariageCoutumier = val!),
              ),
              _buildTextField(
                _telephoneController,
                'Téléphone, adresse et signature du déclarant',
                '',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _sexe != null) {
                    _showConfirmationDialog();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Veuillez remplir tous les champs obligatoires.",
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Vérifier et Envoyer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
