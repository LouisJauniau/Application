import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/TraductionController.dart';
import 'package:aura2/models/User.dart';
import 'package:aura2/screens/carteScreen.dart';
import 'package:aura2/screens/listeScreen.dart';

class AnimatedButtom extends StatefulWidget {
  final bool auth;
  final User login;
  final UserCustom user;

  const AnimatedButtom({
    Key key,
    this.auth,
    this.login,
    this.user,
  }) : super(key: key);

  @override
  _AnimatedButtomState createState() => _AnimatedButtomState();
}

class _AnimatedButtomState extends State<AnimatedButtom> {
  bool _isCarteSelected = true; // Par défaut, on sélectionne "Carte"

  @override
  Widget build(BuildContext context) {
    final trade =
        Provider.of<TraductionController>(context, listen: false).trade.value ??
            false;

    // La couleur rose que vous utilisez
    final rose = Color.fromRGBO(206, 63, 143, 1);

    return Positioned(
      top: 16,
      left: 120,
      child: Container(
        width: 180,
        height: 50,
        // Le parent a juste la bordure + angles arrondis,
        // et n'a pas forcément de fond (transparent).
        decoration: BoxDecoration(
          color: Colors.transparent,  // ou Colors.white si vous préférez
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: rose,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // ================== BOUTON "CARTE" ==================
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _isCarteSelected = true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarteScreen(
                        auth: widget.auth,
                        user: widget.user,
                        login: widget.login,
                      ),
                    ),
                  );
                },
                child: Container(
                  // S'il est sélectionné => fond rose, texte blanc
                  // Sinon => fond blanc, texte rose
                  decoration: BoxDecoration(
                    color: _isCarteSelected ? rose : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      bottomLeft: Radius.circular(32),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      trade ? 'Map' : 'Carte',
                      style: TextStyle(
                        color: _isCarteSelected ? Colors.white : rose,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ================== BOUTON "LISTE" ==================
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _isCarteSelected = false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => listeScreen(
                        auth: widget.auth,
                        user: widget.user,
                        login: widget.login,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: !_isCarteSelected ? rose : Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      trade ? 'List' : 'Liste',
                      style: TextStyle(
                        color: !_isCarteSelected ? Colors.white : rose,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
