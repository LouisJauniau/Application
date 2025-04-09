import 'package:aura2/providers/TraductionController.dart';
import 'package:aura2/providers/favoriteProvider.dart';
import 'package:aura2/widgets/favorisWidgets/listeFavoris.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../models/User.dart';
import '../screens/authentificationScreen/Compte.dart';

import '../screens/drawerScreens/aProposScreen.dart';
import '../screens/drawerScreens/conditionScreen.dart';
import '../screens/drawerScreens/contacterScreen.dart';
import '../screens/homeScreen.dart';

import '../screens/authentificationScreen/LoginScreen.dart';

import 'package:flutter/material.dart';
import '../screens/authentificationScreen/SignScreen.dart';
import '../screens/drawerScreens/notification_page.dart';

class DrawerCustom extends StatefulWidget {
  /// indique si y a un utilisateur connecté
  final bool auth;

  /// l'utilisateur courrant
  final UserCustom user;

  // final Function recuperation;

  // final Function teste;
  List<SavedElement> liste;

  DrawerCustom(
      {Key key,
      this.auth,
      this.user,
      // this.recuperation,
      // this.teste,
      this.liste})
      : super(key: key);
  @override
  _DrawerCustomState createState() => _DrawerCustomState();
}

/// affiche les différents champs du drawer
class _DrawerCustomState extends State<DrawerCustom> {
  Widget _buildDrawer(
      BuildContext ctx, String title, String screen, bool trade) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Myriade'),
        ),
        onTap: () {
          //widget.recuperation(trade);
          if (screen == '')
            Navigator.pop(ctx);
          else
            Navigator.popAndPushNamed(ctx, screen);
        },
      ),
    );
  }

  /// affichage de la fenetre mon compte permettant de modifier les informations de l'utilisateur
  Widget _buildCompte(BuildContext ctx) {
    bool trade =
        Provider.of<TraductionController>(ctx, listen: false).trade.value ??
            false;
    return Container(
      margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
      child: ListTile(
        title: !trade
            ? Text(
                'Mon Compte',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'myriad'),
              )
            : Text(
                'My account',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'myriad'),
              ),
        onTap: () {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (context) => Compte(user: widget.user)),
          );
        },
      ),
    );
  }

  /// affichage de la fenetre 'a propos de nous'
  Widget _buildAPropos(BuildContext ctx) {
    bool trade =
        Provider.of<TraductionController>(ctx, listen: false).trade.value ??
            false;
    return Container(
      margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
      child: ListTile(
        title: !trade
            ? Text(
                'A propos de nous',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'myriad'),
              )
            : Text(
                'About us',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'myriad'),
              ),
        onTap: () {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (context) => AProposScreen()),
          );
        },
      ),
    );
  }

  /// affichage de la fenetre 'a propos de nous'
  Widget _buildContact(BuildContext ctx) {
    bool trade =
        Provider.of<TraductionController>(ctx, listen: false).trade.value ??
            false;
    return Container(
      margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
      child: ListTile(
        title: !trade
            ? Text(
                'Nous contacter',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'myriad'),
              )
            : Text(
                'Contact us',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'myriad'),
              ),
        onTap: () {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (context) => ContacterScreen()),
          );
        },
      ),
    );
  }

  /// affichage de la fenetre 'conditions générales d'utilisation'
  Widget _buildCondition(BuildContext ctx) {
    bool trade =
        Provider.of<TraductionController>(ctx, listen: false).trade.value ??
            false;
    return Container(
      margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
      child: ListTile(
        title: !trade
            ? Text(
                'Conditions générales d\'utilisation',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'myriad'),
              )
            : Text(
                'Terms of service',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'myriad'),
              ),
        onTap: () {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (context) => ConditionScreen()),
          );
        },
      ),
    );
  }

  Widget _buildNotif(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
      child: ListTile(
        title: Text(
          'Notifications',
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'myriad'),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NotificationsPage1(
                    user: widget.user,
                  )));
        },
      ),
    );
  }

  /// affichage de la fenetre 'conditions générales d'utilisation'
  Widget _buildPolitique(BuildContext ctx) {
    bool trade =
        Provider.of<TraductionController>(ctx, listen: false).trade.value ??
            false;
    return Container(
      margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
      child: ListTile(
        title: !trade
            ? Text(
                'Politique de confidentialité',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'myriad'),
              )
            : Text(
                'Privacy policy',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'myriad'),
              ),
        onTap: () {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (context) => ConditionScreen()),
          );
        },
      ),
    );
  }

  Widget _buildVersion(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
      child: ListTile(
          title: Text(
        'Version v3.1',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      )),
    );
  }

  //affiche un texte et le bouton de traduction
  Widget _buildTraduction(BuildContext ctx) {
    var traductionProvider =
        Provider.of<TraductionController>(ctx, listen: false);

    return ValueListenableBuilder(
      valueListenable: traductionProvider.trade,
      builder: (ctx, value, child) {
        bool trade = value ?? false;
        return Container(
          margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: SwitchListTile(
            title: Text(
              'English version',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'myriad'),
            ),
            value: trade,
            onChanged: (bool value) {
              var traductionController =
                  Provider.of<TraductionController>(ctx, listen: false);
              traductionController.toggleTraduction();

              if (!mounted) return;
              setState(() {});
            },
          ),
        );
      },
    );
  }

  /// affichage du message de confirmation de  la déconnexion
  /// l'utilisateur peut confirmer ou annuler
  showAlertDialog(BuildContext context) {
    bool trade =
        Provider.of<TraductionController>(context, listen: false).trade.value ??
            false;
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: !trade
          ? Text(
              "Se déconnecter",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Myriade'),
            )
          : Text(
              "Sign out",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Myriade'),
            ),
      style: ButtonStyle(
        alignment: Alignment.center,
        shadowColor: MaterialStateProperty.all<Color>(Color(0xFFce3f8f)),
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFce3f8f)),
      ),
      onPressed: () {
        FirebaseAuth.instance.signOut();

        Provider.of<FavoriteProvider>(context, listen: false).clear();

        Navigator.pushNamed(context, HomeScreen.routeName);
      },
    );

    Widget continueButton = ElevatedButton(
      child: !trade
          ? Text(
              "Annuler",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Myriade'),
            )
          : Text(
              "Cancel",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Myriade'),
            ),
      style: ButtonStyle(
        alignment: Alignment.center,
        shadowColor: MaterialStateProperty.all<Color>(Color(0xFFce3f8f)),
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFce3f8f)),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Container(
        child: Column(
          children: [
            Icon(
              Icons.power_settings_new,
              color: Color(0xFFce3f8f),
              size: 40,
            ),
            !trade
                ? Text(
                    'Déconnexion',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFce3f8f),
                      fontFamily: 'Myriade',
                    ),
                  )
                : Text(
                    'Sign out',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFce3f8f),
                      fontFamily: 'Myriade',
                    ),
                  ),
          ],
        ),
      ),
      content: !trade
          ? Text(
              "Êtes-vous sûr de vouloir vous déconnecter ?",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Myriade',
              ),
            )
          : Text(
              "Are you sure you want to logout ?",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Myriade',
              ),
            ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// permet de tracer une ligne
  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
      child: Divider(
        color: Colors.grey[600],
      ),
    );
  }

  /// permet de tracer une ligne
  Widget _buildListeTitle() {
    return Container(
        margin: EdgeInsets.fromLTRB(30, 0, 0, 0), child: ListTile());
  }

  @override
  Widget build(BuildContext context) {
    bool trade =
        Provider.of<TraductionController>(context, listen: false).trade.value ??
            false;
    bool auth = widget.auth;

    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/logo_aura_violet.png'),
                    width: 30,
                  ),
                  Text(
                    'AURA',
                    style: TextStyle(fontSize: 24, fontFamily: 'myriad'),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            _buildTraduction(context),
            _buildDivider(),
            _buildNotif(context),
            _buildDivider(),
            if (auth == true) ...[
              _buildCompte(context),
              _buildDivider(),
            ] else ...[
              !trade
                  ? _buildDrawer(
                      context, 'Se connecter', LoginScreen.routeName, trade)
                  : _buildDrawer(
                      context, 'Log in', LoginScreen.routeName, trade),
              _buildDivider(),
              !trade
                  ? _buildDrawer(
                      context, 'S\'inscrire', SignScreen.routeName, trade)
                  : _buildDrawer(
                      context, 'Register', SignScreen.routeName, trade),
              _buildDivider(),
            ],
            _buildAPropos(context),
            _buildDivider(),
            _buildContact(context),
            _buildDivider(),
            _buildCondition(context),
            _buildDivider(),
            _buildPolitique(context),
            _buildDivider(),
            if (auth) ...[
              Container(
                margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: ListTile(
                  title: !trade
                      ? Text(
                          'Déconnexion',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'myriad'),
                        )
                      : Text(
                          'Sign out',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'myriad'),
                        ),
                  onTap: () {
                    showAlertDialog(context);
                  },
                ),
              ),
              _buildDivider(),
              _buildListeTitle(),
              _buildListeTitle(),
              _buildVersion(context),
            ],
          ],
        ),
      ),
    );
  }
}
