import 'package:aura2/widgets/favorisWidgets/listeFavoris.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/article.dart';
import '../../providers/TraductionController.dart';
import '../../providers/articleProvider.dart';
import '../../screens/parcoursScreen.dart';

/// @return renvoie la vue d'un article
class parcoursSupprime extends StatefulWidget {
  parcoursSupprime({Key key, this.liste, this.deleteTexte}) : super(key: key);

  List<SavedElement> liste;
  final Function deleteTexte;
  @override
  _parcoursSupprimeState createState() => _parcoursSupprimeState();
}

class _parcoursSupprimeState extends State<parcoursSupprime> {
  @override
  Widget build(BuildContext context) {
    var trade =
        Provider.of<TraductionController>(context, listen: false).trade.value ??
            false;
    return Expanded(
      child: ListView.builder(
        itemCount: widget.liste.length,
        itemBuilder: (context, index) {
          final currentText = widget.liste[index].text;
          final currentTaille = widget.liste[index].taille;

          final currentColor = widget.liste[index].color;
          return Dismissible(
            key: Key(currentText),
            //Direction de droite à gauche
            direction: DismissDirection.endToStart,

            onDismissed: (direction) async {
              if (trade == false) {
                bool confirmDelete = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Supprimer ce parcours ?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text("Non"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text("Oui"),
                        ),
                      ],
                    );
                  },
                );
                if (confirmDelete == true) {
                  // delete the text
                  widget.deleteTexte(currentText);
                  // delete the corresponding elements from the list
                  widget.liste.remove(currentText);
                  widget.liste.remove(currentTaille);
                  widget.liste.remove(currentColor);
                } else {
                  // if the user cancels the deletion, simply rebuild the widget to show the text again
                  // setState(() {});
                  Navigator.pop(context, false);
                  //return false;
                }
              } else {
                bool confirmDelete = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Do you want to delete this list ?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text("No"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text("Yes"),
                        ),
                      ],
                    );
                  },
                );
                if (confirmDelete == true) {
                  // delete the text
                  widget.deleteTexte(currentText);
                  // delete the corresponding elements from the list
                  widget.liste.remove(currentText);
                  widget.liste.remove(currentTaille);
                  widget.liste.remove(currentColor);
                } else {
                  // if the user cancels the deletion, simply rebuild the widget to show the text again
                  setState(() {});
                }
              }
            },
            background: Container(
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),

            // le container du bouton text
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextButton(
                onPressed: () async {
                  // Récupérer la liste des markers associés au parcours sélectionné
                  var markers = await FirebaseFirestore.instance
                      .collection('utilisateur')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .get()
                      .then((DocumentSnapshot doc) {
                    if (doc.exists &&
                        doc.data() != null &&
                        doc.data() != null) {
                      var data = doc.data() as Map<String, dynamic>;
                      if (data[currentText] != null) {
                        return data[currentText];
                      }
                    }
                  });

                  // Récupérer l'identifiant de chaque article à partir de l'id du marker
                  var articlesParcours = [];
                  for (int j = 0; j < markers.length; j++) {
                    await FirebaseFirestore.instance
                        .collection('markers')
                        .doc(markers[j])
                        .get()
                        .then((DocumentSnapshot doc) {
                      if (doc.exists &&
                          doc.data() != null &&
                          doc.data() != null) {
                        var data = doc.data() as Map<String, dynamic>;
                        if (data['idArticle'] != null) {
                          articlesParcours.add(data['idArticle']);
                        }
                      }
                    });
                  }

                  final articleProvider =
                      Provider.of<ArticleProvider>(context, listen: false);
                  var articleLists = articleProvider.getAllArticles();

                  List<Article> articleListsParcours = [];
                  for (int k = 0; k < articleLists.length; k++) {
                    if (articlesParcours != null &&
                        articlesParcours.contains(articleLists[k].id)) {
                      articleListsParcours.add(articleLists[k]);
                    }
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ParcoursScreen(
                                dropDownValue: currentText,
                                articless: articleListsParcours,
                                auth: true,
                              )));
                },
                child: Row(
                  children: [
                    Container(
                      width: 25.0,
                      height: 25.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: currentColor),
                      child: Center(
                        child: Text(
                          currentTaille,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentText,
                          style: TextStyle(
                              fontFamily: 'myriad',
                              fontSize: 18,
                              color: currentColor),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
