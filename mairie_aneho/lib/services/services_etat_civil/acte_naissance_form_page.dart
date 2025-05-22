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
  void dispose() {
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
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateNaissanceController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
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
            'age_nationalite': _ageNationalitePereController.text,
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

        Navigator.pop(context); // Ferme le formulaire
        _showSuccessMessage();
      } catch (e) {
        _showErrorDialog(e.toString());
      }
    }
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Confirmation'),
            content: Text(
              'Voulez-vous soumettre cette déclaration de naissance ?',
            ),
            actions: [
              TextButton(
                child: Text('Annuler'),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              ElevatedButton(
                child: Text('Confirmer'),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
    );
  }

  void _showSuccessMessage() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Succès'),
            content: Text('La déclaration a été enregistrée avec succès.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Erreur'),
            content: Text(message),
            actions: [
              TextButton(
                child: Text('Fermer'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Déclaration de Naissance')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informations de l\'enfant',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _nomEnfantController,
                decoration: InputDecoration(labelText: 'Nom de l\'enfant'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              Row(
                children: [
                  Text('Sexe :'),
                  Radio(
                    value: 'Masculin',
                    groupValue: _sexe,
                    onChanged: (val) => setState(() => _sexe = val!),
                  ),
                  Text('Masculin'),
                  Radio(
                    value: 'Féminin',
                    groupValue: _sexe,
                    onChanged: (val) => setState(() => _sexe = val!),
                  ),
                  Text('Féminin'),
                ],
              ),
              TextFormField(
                controller: _dateNaissanceController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Date de naissance'),
                onTap: () => _selectDate(context),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _lieuNaissanceController,
                decoration: InputDecoration(labelText: 'Lieu de naissance'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),

              SizedBox(height: 16),
              Text('Père', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _nomPrenomPereController,
                decoration: InputDecoration(labelText: 'Nom & prénom'),
              ),
              TextFormField(
                controller: _ageNationalitePereController,
                decoration: InputDecoration(labelText: 'Âge & nationalité'),
              ),
              TextFormField(
                controller: _professionPereController,
                decoration: InputDecoration(labelText: 'Profession'),
              ),
              TextFormField(
                controller: _domicilePereController,
                decoration: InputDecoration(labelText: 'Domicile'),
              ),

              SizedBox(height: 16),
              Text('Mère', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _nomPrenomMereController,
                decoration: InputDecoration(labelText: 'Nom & prénom'),
              ),
              TextFormField(
                controller: _ageNationaliteMereController,
                decoration: InputDecoration(labelText: 'Âge & nationalité'),
              ),
              TextFormField(
                controller: _professionMereController,
                decoration: InputDecoration(labelText: 'Profession'),
              ),
              TextFormField(
                controller: _domicileMereController,
                decoration: InputDecoration(labelText: 'Domicile'),
              ),

              SizedBox(height: 16),
              Text('Déclarant', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _nomPrenomDeclarantController,
                decoration: InputDecoration(labelText: 'Nom & prénom'),
              ),
              TextFormField(
                controller: _lienDeclarantController,
                decoration: InputDecoration(labelText: 'Lien de parenté'),
              ),
              TextFormField(
                controller: _telephoneController,
                decoration: InputDecoration(labelText: 'Téléphone'),
              ),
              CheckboxListTile(
                value: _pereEstDeclarant,
                onChanged: (val) => setState(() => _pereEstDeclarant = val!),
                title: Text('Le père est le déclarant'),
              ),
              CheckboxListTile(
                value: _mereEstDeclarant,
                onChanged: (val) => setState(() => _mereEstDeclarant = val!),
                title: Text('La mère est la déclarante'),
              ),

              SizedBox(height: 16),
              Text(
                'Enfants antérieurs',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _nbEnfantsVieController,
                decoration: InputDecoration(labelText: 'Enfants vivants'),
              ),
              TextFormField(
                controller: _nbEnfantsDecedesController,
                decoration: InputDecoration(labelText: 'Enfants décédés'),
              ),

              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.send),
                  label: Text('Soumettre la déclaration'),
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
