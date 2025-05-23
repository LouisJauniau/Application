import 'package:provider/provider.dart';

import '../../crypt/encrypt.dart';
import '../../models/User.dart';
import '../../providers/TraductionController.dart';
import '../../widgets/customAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordScreen extends StatefulWidget {
  final UserCustom user;

  PasswordScreen({this.user});

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final myController = TextEditingController();
  bool _isLoading = false;

  /// permet de ne pas afficher le mot de passe lors de la saisie
  bool _isSecret = true;

  /// correspond au nouveau mot de passe  de l'utilisateur
  String _passwordNv = 'aggggg';

  /// correspond au nouveau mot de passe confirmé par  l'utilisateur
  String _passwordNvConfirm1;

  /// rennvoie l'utilisateur courrant
  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  /// permet de valider et d'enregistrer les modifications après avoir appuyer sur le bouton "enregistrer les modifications"
  _submit() {
    var trade =
        Provider.of<TraductionController>(context, listen: false).trade.value ??
            false;
    if (_formKey1.currentState.validate()) {
      _formKey1.currentState.save();

      setState(() {
        _passwordNv = myController.text;
      });

      if (user != null) {
        FirebaseFirestore.instance
            .collection('utilisateur')
            .doc(widget.user.id)
            .update({
          'password': encrypt(_passwordNv),
        });

        user.updatePassword(_passwordNv).then((_) {
          final snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            backgroundColor: Colors.green,
            content: !trade
                ? Text('Votre mot de passe a été changé avec succès',
                    style: TextStyle(color: Colors.white, fontSize: 16))
                : Text('Your password has been successfully changed',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
            action: SnackBarAction(
              label: 'Ok',
              textColor: Colors.white,
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          print("Successfully changed password");
        }).catchError((error) {
          print("Password can't be changed" + error.toString());
          throw error;
        });
      } else {
        print("erreur d'authentification");
      }
    }
  }

  /// modification du mot de passe (validation du mot de passe actuel)
  Widget _buildModificationPasswordActuel(String password) {
    var trade =
        Provider.of<TraductionController>(context, listen: false).trade.value ??
            false;
    return TextFormField(
      obscureText: _isSecret,
      validator: (input) => (input != password)
          ? !trade
              ? 'Le mot de passe est incorrect '
              : 'The password is incorrect'
          : null,
      onSaved: (input) => password = input,
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'myriad',
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          gapPadding: 20,
        ),
        labelText: !trade ? 'Mot de passe actuel' : 'Current password',
        labelStyle: TextStyle(
            color: Color.fromRGBO(209, 62, 150, 1), fontFamily: 'myriad'),
        contentPadding: EdgeInsets.all(14.0),
        hintText: '......',
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: Color.fromRGBO(209, 62, 150, 1),
        ),
      ),
      maxLines: 1,
    );
  }

  /// saisie du nouveau mot de passe
  Widget _buildModificationPasswordNouveau(String password) {
    var trade =
        Provider.of<TraductionController>(context, listen: false).trade.value ??
            false;
    return TextFormField(
      obscureText: _isSecret,
      controller: myController,
      validator: (input) =>
          (password == input) ? 'mot de passe incorrect ' : null,
      onSaved: (input) => _passwordNv = input,
      onChanged: (input) {
        setState(() {
          _passwordNv = myController.text;
        });
      },
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'myriad',
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          gapPadding: 20,
        ),
        labelText: !trade ? 'Nouveau mot de passe' : 'New password',
        labelStyle: TextStyle(
          color: Color.fromRGBO(209, 62, 150, 1),
          fontFamily: 'myriad',
        ),
        hintText: '......',
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'myriad',
        ),
        contentPadding: EdgeInsets.all(14.0),
        prefixIcon: Icon(
          Icons.vpn_key,
          color: Color.fromRGBO(209, 62, 150, 1),
        ),
      ),
      maxLines: 1,
    );
  }

  /// confirmation du nouveau mot de passe
  Widget _buildModificationPasswordConfirm() {
    var trade =
        Provider.of<TraductionController>(context, listen: false).trade.value ??
            false;
    return TextFormField(
      obscureText: _isSecret,
      validator: (input) => input != myController.text
          ? !trade
              ? 'Mot de passe incorrect'
              : 'Incorrect password'
          : null,
      onSaved: (input) => _passwordNvConfirm1 = input,
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'myriad',
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          gapPadding: 20,
        ),
        labelText: !trade
            ? 'Retapez le nouveau mot de passe'
            : 'Reenter your password',
        labelStyle: TextStyle(
            color: Color.fromRGBO(209, 62, 150, 1), fontFamily: 'myriad'),
        hintText: '......',
        hintStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'myriad'),
        contentPadding: EdgeInsets.all(14.0),
        prefixIcon: Icon(
          Icons.vpn_key,
          color: Color.fromRGBO(209, 62, 150, 1),
        ),
      ),
      maxLines: 1,
    );
  }

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
  Widget _buildTextBouton() {
    var trade =
        Provider.of<TraductionController>(context, listen: false).trade.value ??
            false;
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
          _submit();
          setState(() {
            _passwordNv = myController.text;
          });
        });
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
              StreamBuilder<Object>(
                  stream: FirebaseFirestore.instance
                      .collection('utilisateur')
                      .doc(widget.user.id)
                      .get()
                      .asStream(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(15),
                          children: [
                            SizedBox(height: 10),
                            !trade
                                ? _buildText('Modifier mon mot de passe')
                                : _buildText('Change my password'),
                            SizedBox(height: 60),
                            Form(
                              key: _formKey1,
                              child: Column(
                                children: [
                                  _buildModificationPasswordActuel(
                                      decrypt(snapshot.data.get('password'))),
                                  SizedBox(height: 30),
                                  _buildModificationPasswordNouveau(
                                      decrypt(snapshot.data.get('password'))),
                                  SizedBox(height: 30),
                                  _buildModificationPasswordConfirm(),
                                ],
                              ),
                            ),
                            SizedBox(height: 60),
                            _buildTextBouton(),
                          ],
                        ),
                      );
                    } else
                      return CircularProgressIndicator();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
