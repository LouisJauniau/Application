import 'package:aura2/models/article.dart';
import 'package:aura2/widgets/favorisWidgets/listeFavoris.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/User.dart';
import '../../providers/articleProvider.dart';
import '../../screens/listeScreen.dart';
import '../../screens/parcoursScreen.dart';

class BoutonParcoursItem extends StatefulWidget {
  String dropdownValue;
  String buttonText;
  List<SavedElement> liste;
  bool showWidget;

  final bool auth;

  final User login;

  final UserCustom user;

  final Function stcokeeParcours;

  List<String> articlesParcours;

  BoutonParcoursItem(
      {this.buttonText,
      this.dropdownValue,
      this.liste,
      this.showWidget = false,
      this.auth,
      this.login,
      this.user,
      this.stcokeeParcours,
      this.articlesParcours});

  @override
  _BoutonParcoursItemState createState() => _BoutonParcoursItemState();
}

class _BoutonParcoursItemState extends State<BoutonParcoursItem> {
  @override
  Widget build(BuildContext context) {
    final articleListImage =
        Provider.of<ArticleProvider>(context).getAllArticlesImage().toList();

    ///Liste contenanat des articles qui possedent pas des images
    final articleListWithoutImage = Provider.of<ArticleProvider>(context)
        .getAllArticlesWithoutImage()
        .toList();

    ///Trier les articles par ordre alphabétiques selon leur titres
    articleListImage.sort(((a, b) => a.title.compareTo(b.title)));
    articleListWithoutImage.sort(((a, b) => a.title.compareTo(b.title)));
    final articleLists = articleListImage + articleListWithoutImage;

    return PopupMenuButton<String>(
      elevation: 10,
      onSelected: (option) async {
        setState(() {
          widget.dropdownValue = option;
          widget.buttonText = option;
          widget.showWidget = false;
        });

        for (int i = 0; i < widget.liste.length; i++) {
          if (option == widget.liste[i].text) {
            widget.dropdownValue = widget.liste[i].text;
            await widget.stcokeeParcours(widget.liste[i].text);

            // Récupérer la liste des markers associés au parcours sélectionné
            var markers = await FirebaseFirestore.instance
                .collection('utilisateur')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .get()
                .then((DocumentSnapshot doc) {
              if (doc.exists && doc.data() != null && doc.data() != null) {
                var data = doc.data() as Map<String, dynamic>;
                if (data[option] != null) {
                  return data[option];
                }
              }
            });

            // Récupérer l'identifiant de chaque article à partir de l'id du marker
            widget.articlesParcours = [];
            for (int j = 0; j < markers.length; j++) {
              await FirebaseFirestore.instance
                  .collection('markers')
                  .doc(markers[j])
                  .get()
                  .then((DocumentSnapshot doc) {
                if (doc.exists && doc.data() != null && doc.data() != null) {
                  var data = doc.data() as Map<String, dynamic>;
                  if (data['idArticle'] != null) {
                    widget.articlesParcours.add(data['idArticle']);
                  }
                }
              });
            }

            List<Article> articleListsParcours = [];
            for (int k = 0; k < articleLists.length; k++) {
              if (widget.articlesParcours != null &&
                  widget.articlesParcours.contains(articleLists[k].id)) {
                articleListsParcours.add(articleLists[k]);
              }
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ParcoursScreen(
                          dropDownValue: widget.dropdownValue,
                          articless: articleListsParcours,
                          auth: true,
                        )));
          }
          if (option == 'Tous') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => listeScreen(
                          auth: true,
                        )));
          }
        }
      },
      itemBuilder: (BuildContext context) {
        List<PopupMenuEntry<String>> entries = [];
        List<String> options2 = ['Tous'];
        for (int i = 0; i < widget.liste.length; i++) {
          options2.add(widget.liste[i].text);
        }

        for (String option in options2) {
          entries.add(
            PopupMenuItem<String>(
              value: option,
              child: Text(option),
            ),
          );
        }
        return entries;
      },
      child: Row(
        children: [
          TextButton(
            // onPressed: () {},
            child: Text(
              widget.dropdownValue,
              style: TextStyle(color: Color.fromRGBO(206, 63, 143, 1)),
            ),
          ),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
