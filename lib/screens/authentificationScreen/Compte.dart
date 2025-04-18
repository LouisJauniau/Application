import 'package:provider/provider.dart';

import '../../providers/TraductionController.dart';
import '../../screens/authentificationScreen/PasswordScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/User.dart';
import '../../widgets/customAppBar.dart';

class Compte extends StatefulWidget {
  /// l'utilisateur à modifier
  final UserCustom user;

  Compte({this.user});

  @override
  _CompteState createState() => _CompteState();
}

class _CompteState extends State<Compte> {
  /// la clé globale correspondant au premier formulaire des informations de l'utilisateur

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  /// correspond au sexee  de l'utilisateur
  // String _sexe = 'Homme';
  String _sexe;

  bool _isLoading = false;

  /// permet de savoir si le nom a été modifier
  bool modifierNom = false;

  /// permet de savoir si le prenom a été modifier
  bool modifierPrenom = false;

  /// permet de savoir si le numéro de téléphone a été modifier
  bool modifierPhone = false;

  /// permet de savoir si le sexe a été modifier
  bool modifierSexe = false;

  /// permet de savoir si la date de naissance à été modifier
  bool modifierDate = false;

  /// les variables intermediaires utilisées
  String _nom1, _prenom1, _phone1, _date1;

  /// rennvoie l'utilisateur courrant
  User user = FirebaseAuth.instance.currentUser;

  /// permet de valider et d'enregistrer les modifications après avoir appuyer sur le bouton "enregistrer les modifications"
  _submit(var trade) {
    if (_formKey1.currentState.validate()) {
      _formKey1.currentState.save();

      if (user != null) {
        FirebaseFirestore.instance
            .collection('utilisateur')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .update({
          'name': _nom1,
          'prenom': _prenom1,
          'dateNaissance': _date1,
          'eMail': widget.user.eMail,
          'phone': _phone1,
          'password': widget.user.passeword,
          'sexe': _sexe
        });

        final snackBar = SnackBar(
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: !trade
              ? Text('Les informations ont été modifiées avec succès',
                  style: TextStyle(color: Colors.white, fontSize: 16))
              : Text('The information has been successfully modified',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
          action: SnackBarAction(
            label: 'Ok',
            textColor: Colors.white,
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print("erreur d'authentification");
      }
    }
  }

  /// modifiaction du nom
  Widget _buildModificationNom(nom, trade) {
    return TextFormField(
      validator: (input) => input.isEmpty
          ? !trade
              ? 'Le champ est obligatoire'
              : 'The field is required'
          : null,
      onSaved: (input) => _nom1 = input,
      initialValue: nom,
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'myriad',
      ),
      decoration: InputDecoration(
        labelText: !trade ? 'Nom' : 'Last name',
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          gapPadding: 20,
        ),
        fillColor: Color.fromRGBO(209, 62, 150, 1),
        hoverColor: Color.fromRGBO(209, 62, 150, 1),
        labelStyle: TextStyle(
            color: Color.fromRGBO(209, 62, 150, 1), fontFamily: 'myriad'),
        contentPadding: EdgeInsets.all(14.0),
        prefixIcon: Icon(
          Icons.person,
          color: Color.fromRGBO(209, 62, 150, 1),
        ),
        suffixIcon: Icon(
          Icons.done,
          color: modifierNom ? Colors.green : Colors.white,
        ),
      ),
      maxLines: 1,
    );
  }

  /// modification du prénom
  Widget _buildModificationPrenom(prenom, trade) {
    return TextFormField(
      validator: (input) => input.isEmpty
          ? !trade
              ? 'Le champ est obligatoire'
              : 'The field is required'
          : null,
      onSaved: (input) => _prenom1 = input,
      initialValue: prenom,
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'myriad',
      ),
      decoration: InputDecoration(
        labelText: !trade ? 'Prénom' : 'First name',
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          gapPadding: 20,
        ),
        labelStyle: TextStyle(
            color: Color.fromRGBO(209, 62, 150, 1), fontFamily: 'myriad'),
        contentPadding: EdgeInsets.all(14.0),
        prefixIcon: Icon(
          Icons.person,
          color: Color.fromRGBO(209, 62, 150, 1),
        ),
        suffixIcon: Icon(
          Icons.done,
          color: modifierPrenom ? Colors.green : Colors.white,
        ),
      ),
      maxLines: 1,
    );
  }

  /// modification du sexe
  void setSexe() {
    if (widget.user.sexe != _sexe) {
      modifierSexe = true;
    }
  }

  /// modification du prénom
  void setPrenom() {
    if (widget.user.prenom != _prenom1) {
      modifierPrenom = true;
    }
  }

  /// modification du nom
  void setNom() {
    if (widget.user.nom != _nom1) {
      modifierNom = true;
    }
  }

  /// modification de la date
  void setDate() {
    if (widget.user.dateNaissance != _date1) {
      modifierDate = true;
    }
  }

  /// modification du numéro de téléphone
  void setPhone() {
    if (widget.user.phone != _phone1) {
      modifierPhone = true;
    }
  }

  /// Permet d'afficher les textes 'informations utilisateur et mot de passe'
  Widget _buildText(String texte) {
    return Text(
      '\t\t' + texte,
      textAlign: TextAlign.start,
      style: TextStyle(
          fontSize: 23.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'myriad'),
    );
  }

  /// permet d'afficher le bouton "J'enregistre mes modifications"
  Widget _buildTextBouton(trade) {
    return TextButton(
        child: !trade
            ? Text(
                'J\'enregistre mes modifications',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'myriad',
                ),
              )
            : Text(
                'I save my changes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'myriad',
                ),
              ),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Color.fromRGBO(209, 62, 150, 1)),
          padding: MaterialStateProperty.all(
              EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 10)),
        ),
        onPressed: () {
          _submit(trade);
          setState(() {
            setPhone();
            setPrenom();
            setSexe();
            setNom();
            setDate();
          });
        });
  }

  Widget _buildMp(trade) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PasswordScreen(user: widget.user)),
        );
      },
      child: !trade
          ? Text(
              'Modifier mon mot de passe',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                //fontWeight: FontWeight.bold,
                fontFamily: 'myriad',
              ),
            )
          : Text(
              'Change my password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                //fontWeight: FontWeight.bold,
                fontFamily: 'myriad',
              ),
            ),
      style: ButtonStyle(
        overlayColor:
            MaterialStateProperty.all(Color.fromRGBO(209, 62, 150, 1)),
        foregroundColor:
            MaterialStateProperty.all(Color.fromRGBO(209, 62, 150, 1)),
        shadowColor: MaterialStateProperty.all(Color.fromRGBO(209, 62, 150, 1)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        )),
        side:
            MaterialStateProperty.all(BorderSide(width: 1, color: Colors.grey)),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
            EdgeInsets.only(left: 50, right: 50, bottom: 10, top: 10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var trade =
        Provider.of<TraductionController>(context, listen: false).trade.value ??
            false;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leadingWidth: 100,
          leading: CustomAppBar(
            from: '',
          )),
      body: Container(
        color: Colors.white,
        child: Builder(
          builder: (context) => Column(
            children: [
              _isLoading
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.blue[200],
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                    )
                  : SizedBox.shrink(),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('utilisateur')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .get()
                      .asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(15),
                          children: [
                            SizedBox(height: 25),
                            !trade
                                ? _buildText('Mes informations personnelles')
                                : _buildText('My personal information'),
                            SizedBox(height: 25),
                            // _buildSexeCheckbox(snapshot.data.get('sexe')),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Form(
                              key: _formKey1,
                              child: Column(
                                children: [
                                  _buildModificationNom(
                                      snapshot.data.get('name'), trade),
                                  SizedBox(height: 25),
                                  _buildModificationPrenom(
                                      snapshot.data.get('prenom'), trade),
                                ],
                              ),
                            ),
                            SizedBox(height: 25),
                            !trade
                                ? _buildText('Mon mot de passe')
                                : _buildText('My password'),
                            SizedBox(height: 25),
                            _buildMp(trade),
                            SizedBox(height: 50),
                            _buildTextBouton(trade),
                          ],
                        ),
                      );
                    } else
                      return Center(child: CircularProgressIndicator());
                  }),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
