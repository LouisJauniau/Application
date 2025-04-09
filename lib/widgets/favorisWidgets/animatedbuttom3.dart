import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/TraductionController.dart';
import 'package:aura2/models/User.dart';
import 'package:aura2/screens/carteScreen.dart';
import 'package:aura2/screens/listeScreen.dart';

class AnimatedButtom3 extends StatefulWidget {
  final bool auth;
  final User login;
  final UserCustom user;

  const AnimatedButtom3({
    Key key,
    this.auth,
    this.login,
    this.user,
  }) : super(key: key);

  @override
  _AnimatedButtom3State createState() => _AnimatedButtom3State();
}

class _AnimatedButtom3State extends State<AnimatedButtom3> {
  bool _isCarteSelected = true;

  @override
  Widget build(BuildContext context) {
    final trade =
        Provider.of<TraductionController>(context, listen: false).trade.value ??
            false;
    final rose = Color.fromRGBO(206, 63, 143, 1);

    return Positioned(
      top: 16,
      left: 120,
      child: Container(
        width: 180,
        height: 50,
        decoration: BoxDecoration(
          color: rose, // fond rose global
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: rose, width: 2),
        ),
        child: Row(
          children: [
            // ========== BOUTON "CARTE" ==========
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _isCarteSelected = true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CarteScreen(
                        auth: widget.auth,
                        user: widget.user,
                        login: widget.login,
                      ),
                    ),
                  );
                },
                child: Container(
                  // Si sélectionné => fond blanc, sinon fond rose
                  decoration: BoxDecoration(
                    color: _isCarteSelected ? Colors.white : rose,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      bottomLeft: Radius.circular(32),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      trade ? 'Map' : 'Carte',
                      // Si fond blanc => texte rose, sinon texte blanc
                      style: TextStyle(
                        color: _isCarteSelected ? rose : Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ========== BOUTON "LISTE" ==========
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _isCarteSelected = false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => listeScreen(
                        auth: widget.auth,
                        user: widget.user,
                        login: widget.login,
                      ),
                    ),
                  );
                },
                child: Container(
                  // Si sélectionné => fond blanc, sinon fond rose
                  decoration: BoxDecoration(
                    color: !_isCarteSelected ? Colors.white : rose,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      trade ? 'List' : 'Liste',
                      style: TextStyle(
                        color: !_isCarteSelected ? rose : Colors.white,
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
