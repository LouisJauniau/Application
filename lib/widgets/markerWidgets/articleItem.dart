import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/customMarker.dart';
import '../../models/tag.dart';
import '../../providers/TraductionController.dart';
import '../../providers/markerProvider.dart';
import '../../providers/tagProvider.dart';
import '../../models/article.dart';
import '../../providers/articleProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

import '../audioWidgets/audio.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../favorisWidgets/parcoursItem.dart';

Map<String, String> imagesMap = {
  'Manufacture sur Seine - Quartier Terre':
  'assets/Manufacture sur Seine Quartier Terre/reinventer-seine-manufacture-seine-amateur.jpg',
  'Centre ville de Montreuil Sous Bois':
  'assets/Centre Ville de Montreuil sous Bois Alvaro Siza/Croquis Siza Centre Ville Montreuil.jpg',
  'La Grande Arche': 'assets/La Grande Arche/IMG_3992.jpeg',
  'Fondation Louis Vuitton': 'assets/Fondation Louis Vuitton/IMG_1330.jpeg',
  '100 logements sociaux': 'assets/IMG_4027.jpeg',
  'Stade Jean Bouin': 'assets/IMG_2083.jpeg',
  'La Tour Triangle': 'assets/La Tour Triangle/La Tour Triangle.jpg',
  'Hôpital Cognacq-Jay': 'assets/Hôpital Cognacq-Jay - Toyo Ito/IMG_9574.jpeg',
  'Musée du quai Branly': 'assets/Musée Quai Branly/IMG_3690.jpeg',
  'Espace de méditation UNESCO':
  'assets/Espace de Méditation UNESCO - Tadao Ando/IMG_3819.jpeg',
  'Showroom Citroën': 'assets/Showroom Citroën/IMG_3651.jpeg',
  '57 logements Rue Des Suisses':
  'assets/57 logements - Herzog et Demeuron/IMG_2681.jpeg',
  'Fondation Cartier pour l\'art contemporain':
  'assets/Fondation Cartier/IMG_2195.jpeg',
  'Galerie marchande Gaîté Montparnasse':
  'assets/Galerie Marchande Gaîté Montparnasse/03_Gaîté_Montparnasse_MVRDV_©Ossip van Duivenbode.jpg',
  'Le département des Arts de l\'Islam du Louvre':
  'assets/Département des Arts de l_Islam du Louvre/PARIS_Departement-des-Arts-de-l-Islam-du-musee-du-Louvre_02b.jpg',
  'La Pyramide du Louvre': 'assets/La Pyramide du Louvre/IMG_3222.jpeg',
  'La Nouvelle Samaritaine':
  'assets/La Nouvelle Saint Maritaine - SANAA/IMG_3967.jpeg',
  'La Fondation Pinault': 'assets/téléchargement.jpg',
  'La Canopée': 'assets/La Canopée/IMG_3297.jpeg',
  'Lafayette Anticipation': 'assets/IMG_3353.jpeg',
  'Pavillon Mobile Art Chanel':
  'assets/Pavillon Mobile Art Chanel/chanel_mobile_art_pavilion-zaha_hadid_2_photo AA13.jpg',
  'La Fondation Jérôme Seydoux-Pathé': 'assets/téléchargement (1).jpg',
  'Pushed Slab': 'assets/Pushed Slab/IMG_5889.jpeg',
  'M6B2 Tour de la Biodiversité': 'assets/IMG_7619.jpeg',
  'La Bibliothèque Nationale de France (François Mitterand)':
  'assets/Bibliothèque François Mitterand/IMG_6855.jpeg',
  'Cité de la mode et du design': 'assets/Cité de la mode/IMG_7176.jpeg',
  'La Cinémathèque Française':
  'assets/La Cinémathèque Française/IMG_8448.jpeg',
  'Eden bio': 'assets/Eden Bio/IMG_4174.jpeg',
  'La Philharmonie': 'assets/La Philharmonie/IMG_4684.jpeg',
  'Le Parc de la Villette':
  'assets/Cité de la mode/Le Parc Lavillette/IMG_4727.jpeg',
  '220 logements Rue de Meaux':
  'assets/220 Logements rue de Meaux/IMG_2681.jpeg',
  'Siège du Parti Communiste Français':
  'assets/Siège Parti Communiste/IMG_4383.jpeg',
  'Villa Dall\'Ava': 'assets/Villa d_all_Ava - Oma/IMG_3076.jpeg',
};

/// @return renvoie la vue d'un article
class ArticleItem extends StatefulWidget {
  /// Article à afficher
  final Article article;

  /// Function permettant le changement de l'attribut isFavorite d'un marqueur
  final Function changeFavorite;

  final Function deleteItem;

  /// Function permettant le changement de l'attribut isFavorite d'un marqueur
  final Function changeArrondissement;

  //Etat du bouton Parcours
  final List<bool> options1;

  /// Identifiant du marqueur à changer
  final String idMaker;

  /// Etat du bouton Favori
  final bool like;

  ///  Affiche l'écran des commentaires
  final Function switchToComm;

  /// Permet de savoir si l'on est passée d'un article à l'autre
  final bool switchArticle;

  final Function switchFalse;

  //Snapshot d'où provient l'audio
  final String snapshot;

  //Permet de savoir si le popUp est lancé ou non
  final bool lance;

  //Fonction callBack qui permet de "faire remonter" les données d'un article vers "CarteScreen"
  final Function(Article, AudioPlayer, bool, String) articleCallback;

  //L'audioPlayer qui permet de jouer/mettre en pause un article
  final AudioPlayer audioPlayer;

  //Permet de savoir si l'audio est en cours ou non
  final bool audioState;

  //Un second article
  final Article secondArticle;

  //Fonction callBack qui permet de renvoyer le booleen vers CarteScreen permettant de savoir si le popUp est ouvert
  final Function(bool) isPopUpOpen;

  //Permet de sauvegarder la durée max d'un audio
  final Duration savedMaxDuration;

  //Permet de sauvegarder la position d'un audio
  final Duration savedPosition;

  //Fonction callBack permettant de remonter les données de savedPosition et savedMaxPosition vers CarteScreen
  final Function(Duration, Duration) updateDuration;

  //Le bool qui permet de savoir si on lance un article pour la première fois
  final bool firstLaunchOfArticle;

  //Permet de set le bool à true
  final Function setFirstLaunchOfArticle;

  //Fonction qui permet d'ouvrir un article depuis le popupp audio
  final Function afficherArticle;

  //Le marker correspondant à l'article courant
  final CustomMarker marker;

  //Fonction pour actualiser le marker utilisé dans audioBottomBar
  final Function(CustomMarker) updateMarkerForPopUp;

  //La fonction qui permet de lancer l'audio
  final Function play;

  //La fonction qui permet de pause l'audio
  final Function pausePlayer;

  //La fonction qui permet d'arrêter l'audio
  final Function stopPlayer;

  //Les markers de l'application
  final MarkerProvider markersData;

  //Les articles de l'application
  final ArticleProvider articlesData;

  ArticleItem({
    this.article,
    this.changeFavorite,
    this.deleteItem,
    this.idMaker,
    this.switchFalse,
    this.like,
    this.switchArticle,
    this.switchToComm,
    this.articleCallback,
    this.snapshot,
    this.lance,
    this.audioPlayer,
    this.audioState,
    this.secondArticle,
    this.isPopUpOpen,
    this.savedMaxDuration,
    this.savedPosition,
    this.updateDuration,
    this.firstLaunchOfArticle,
    this.setFirstLaunchOfArticle,
    this.afficherArticle,
    this.marker,
    this.updateMarkerForPopUp,
    this.pausePlayer,
    this.play,
    this.stopPlayer,
    this.articlesData,
    this.markersData,
    this.changeArrondissement,
    this.options1,
  });
  @override
  _ArticleItemState createState() => _ArticleItemState();
}

class _ArticleItemState extends State<ArticleItem> {
  Article article;

  /// Taille du titre
  double _sizeTitre = 20;

  /// Taille de l'info
  double _sizeInfo = 16;

  /// Taille de l'introduction
  double _sizeIntro = 18;

  /// Taille du text
  double _sizeText = 17;

  /// Echelle du slide
  final double _scale = 0.05;

  // Le nouvel article qui sera retourné dans carteScreen
  Article newArticle;

  //La nouvelle snapshot qui sera retournée dans carteScreen
  String newSnapshot;

  // Savoir si c'est un nouvel audio ou pas
  bool newAudio = false;

  bool newState;

  //liste _cheked pour etat de la case
  List<String> textes = [
    'XI arrondissement',
    'Parcours Ecole',
    'Balade samedi',
    'A visiter',
    'Bâtiments béton'
  ];

  //Listes de couleurs
  List<Color> couleurs = [
    Colors.purple,
    Colors.green,
    Colors.red,
    Colors.yellow,
    Colors.blue
  ];

  Color colorButtonAdd = Colors.transparent;

  void _onAudioPressed() {
    newState = widget.audioState;
    Duration savedPosition = Duration();
    Duration savedMaxDuration = Duration();

    if (widget.secondArticle != widget.article ||
        (widget.audioState && widget.secondArticle != widget.article)) {
      widget.play(widget.snapshot);
      newState = true;
    }
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () =>
                Navigator.of(context, rootNavigator: true).pop(),
            child: Dismissible(
              movementDuration: Duration(seconds: 1),
              key: Key("key"),
              direction: DismissDirection.vertical,
              onDismissed: (value) {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Audio(
                article: widget.article,
                audioPlayer: widget.audioPlayer,
                snapshot: widget.snapshot,
                audioState: widget.firstLaunchOfArticle
                    ? newState != null
                    ? newState
                    : widget.audioState
                    : widget.audioState,
                lance: widget.lance,
                play: widget.play,
                pausePlayer: widget.pausePlayer,
                stopPlayer: widget.stopPlayer,
                cameFromArticeItem: true,
                isPopupOpen: widget.isPopUpOpen,
                updateDuration: widget.updateDuration,
                savedMaxDuration: (widget.secondArticle == widget.article)
                    ? widget.savedMaxDuration
                    : savedMaxDuration,
                savedPosition: (widget.secondArticle == widget.article)
                    ? widget.savedPosition
                    : savedPosition,
                firstLaunchOfArticle: widget.firstLaunchOfArticle,
                setFirstLaunchOfArticle: widget.setFirstLaunchOfArticle,
                afficherArticle: widget.afficherArticle,
                marker: widget.marker,
                updateMarkerForPopUp: widget.updateMarkerForPopUp,
                articleCallback: widget.articleCallback,
                randomAudioCallback: randomAudioCallback,
                articlesData: widget.articlesData,
                markersData: widget.markersData,
              ),
            ),
          );
        },
      ),
    ).then((value) => setStateLance());
  }

  /// Change la taille de la police du titre
  void _fontSizeTitre(ScaleUpdateDetails details) {
    if (_sizeTitre < 20) {
      _sizeTitre = 20;
    }
    if (_sizeTitre > 28) {
      _sizeTitre = 28;
    }
    details.scale > 1
        ? _sizeTitre = _sizeTitre + details.scale * _scale
        : _sizeTitre = _sizeTitre - details.scale * _scale;
  }

  /// Change la taille de la police de l'introduction
  void _fontSizeIntro(ScaleUpdateDetails details) {
    if (_sizeIntro < 18) {
      _sizeIntro = 18;
    }
    if (_sizeIntro > 26) {
      _sizeIntro = 26;
    }
    details.scale > 1
        ? _sizeIntro = _sizeIntro + details.scale * _scale
        : _sizeIntro = _sizeIntro - details.scale * _scale;
  }

  /// Change la taille de la police des informations
  void _fontSizeInfo(ScaleUpdateDetails details) {
    if (_sizeInfo < 16) {
      _sizeInfo = 16;
    }
    if (_sizeInfo > 22) {
      _sizeInfo = 22;
    }
    details.scale > 1
        ? _sizeInfo = _sizeInfo + details.scale * _scale
        : _sizeInfo = _sizeInfo - details.scale * _scale;
  }

  /// Change la taille de la police du texte
  void _fontSizeText(ScaleUpdateDetails details) {
    if (_sizeText < 17) {
      _sizeText = 17;
    }
    if (_sizeText > 25) {
      _sizeText = 25;
    }
    details.scale > 1
        ? _sizeText = _sizeText + details.scale * _scale
        : _sizeText = _sizeText - details.scale * _scale;
  }

  /// Action permettant d'agrandir ou reduire la taille de la police
  void _pinch(ScaleUpdateDetails details) {
    setState(() {
      _fontSizeTitre(details);
      _fontSizeInfo(details);
      _fontSizeIntro(details);
      _fontSizeText(details);
    });
  }

  //Permet de modifier la valeur du bool lance
  //Si un nouvel audio est joué on renvoie les données de l'article vers CarteScreen pour l'afficher sur l'AudioBottomBar
  void setStateLance() {
    widget.isPopUpOpen(!widget.lance);
    if (newAudio) {
      widget.articleCallback(newArticle, widget.audioPlayer, newState, newSnapshot);
    } else {
      widget.articleCallback(widget.article, widget.audioPlayer, widget.audioState, widget.snapshot);
    }
    newAudio = false;
  }

  //Permet de recuperer les donnees du nouvel audio joue aleatoirement dans audio.dart
  void randomAudioCallback(
      Article newArticle, String newSnapshot, bool newState, bool newAudio) {
    this.newArticle = newArticle;
    this.newSnapshot = newSnapshot;
    this.newAudio = newAudio;
    this.newState = newState;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.article.imageUrl);
    var trade = Provider.of<TraductionController>(context, listen: false).trade.value ?? false;

    /// Liste de texte avec introdution
    List<String> intro =
    Provider.of<ArticleProvider>(context, listen: false).getIntro(widget.article, trade);

    /// Liste  des labels
    List<String> labels =
    Provider.of<TagProvider>(context, listen: false).listLabel(widget.article.tags, trade);
    labels.sort((a, b) => a.compareTo(b));

    /// Liste des labels ET des definitions
    List<Tag> _labels = Provider.of<TagProvider>(context).tags;

    ///Liste de texte séparant les phrases en gras ou non
    List<String> gras = Provider.of<ArticleProvider>(context, listen: false)
        .getBold(intro.length == 1 ? intro[0] : intro[1]);

    ///Texte représentant la signature
    String sign = Provider.of<ArticleProvider>(context, listen: false).getSign(gras.last);

    // Ajustement s'il y a un &signature
    if (gras.last.contains('&signature')) {
      var _end = gras.last.split('&signature');
      gras.removeLast();
      gras.add(_end[0]);
    }

    /// Mets en gras les String de gras lorsque [i] est impaire
    List<Widget> addBoldToText() {
      List<SelectableText> l = [];
      if (gras.length > 1) {
        for (var i = 1; i < gras.length; i++) {
          if (i % 2 == 1) {
            l.add(
              SelectableText(
                gras[i],
                style: TextStyle(
                  fontFamily: 'myriad',
                  fontSize: _sizeText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            l.add(
              SelectableText(
                gras[i],
                style: TextStyle(
                  fontFamily: 'myriad',
                  fontSize: _sizeText,
                ),
              ),
            );
          }
        }
      }
      return l;
    }

    /// @rgs - item Etiquette à afficher
    /// @return Renvoi le widget d'une étiquette
    Widget _buildChip(String label, String def) {
      return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Color.fromRGBO(209, 62, 150, 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: GestureDetector(
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: _sizeInfo),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () => Navigator.of(context, rootNavigator: true).pop(),
                  child: Dismissible(
                    movementDuration: Duration(seconds: 1),
                    key: Key("key"),
                    direction: DismissDirection.vertical,
                    onDismissed: (value) {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: AlertDialog(
                      insetPadding: EdgeInsets.zero,
                      title: Text(
                        label,
                        style: TextStyle(
                          color: Color.fromRGBO(209, 62, 150, 1),
                          fontSize: 20,
                        ),
                      ),
                      content: Text(
                        def,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }

    /// @return Renvoi le design de chaque étiquette dans une liste
    List<Container> _buildAllChip() {
      List<Container> _chips = [];
      for (var i = 0; i < labels.length; i++) {
        for (var y = 0; y < _labels.length; y++) {
          if (!trade) {
            if (labels[i].contains(_labels[y].label)) {
              _chips.add(_buildChip(labels[i], _labels[y].definition));
            }
          } else {
            if (labels[i].contains(_labels[y].labelEN)) {
              _chips.add(_buildChip(labels[i], _labels[y].definitionEN));
            }
          }
        }
      }
      return _chips;
    }

    // *** RÉCUPÉRATION & GESTION DES PARCOURS / COULEURS / FIREBASE ***
    final TextEditingController _textEditingController = TextEditingController();
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('utilisateur')
        .doc(FirebaseAuth.instance.currentUser.uid);

    List<String> arrayFieldNames = [];
    Future<List<String>> getArrayFieldNames() async {
      try {
        DocumentSnapshot documentSnapshot = await documentReference.get();
        Map<String, dynamic> documentData =
        documentSnapshot.data() as Map<String, dynamic>;

        documentData.forEach((key, value) {
          if (value is List) {
            if (key != 'favoris') arrayFieldNames.add(key);
          }
        });
        print('Champs de type tableau dans le document Firestore: $arrayFieldNames');
        return arrayFieldNames;
      } catch (e) {
        print('Erreur lors de la récupération des noms de champs de type tableau: $e');
        return null;
      }
    }

    Color stringToColor(String colorString) {
      String valueString = colorString.replaceAll("#", "");
      if (valueString.length == 6) {
        valueString = "FF" + valueString;
      }
      int value = int.parse(valueString, radix: 16);
      return Color(value);
    }

    final markerProvider = Provider.of<MarkerProvider>(context, listen: false);

    Future<Map<String, dynamic>> getMapFields() async {
      final documentReference = FirebaseFirestore.instance
          .collection('utilisateur')
          .doc(FirebaseAuth.instance.currentUser.uid);

      final documentSnapshot = await documentReference.get();
      var dataUser = documentSnapshot.data();
      final mapData = dataUser['couleurs'] as Map<String, dynamic>;

      var marker = markerProvider
          .getAllMarkers()
          .singleWhere((element) => element.idArticle == widget.article.id);

      colorButtonAdd = Colors.black45;
      if (mapData != null) {
        for (var parcours in mapData.keys) {
          if (dataUser.containsKey(parcours)) {
            var markers = dataUser[parcours];
            if (markers.contains(marker.id)) {
              if (!mounted) return null;
              setState(() {
                colorButtonAdd = stringToColor(mapData[parcours]);
              });
            }
          }
        }
      }
      return mapData;
    }

    List<SavedElement> savedElements = [SavedElement('', Colors.white, false)];

    String colorToString(Color color) {
      String colorString = color.value.toRadixString(16).toUpperCase();
      if (colorString.length == 8) {
        colorString = colorString.substring(2);
      }
      return "#" + colorString;
    }

    void myFunction(List<String> myList, Map<String, dynamic> mapResultat) async {
      myList = await getArrayFieldNames();
      mapResultat = await getMapFields();
      print(mapResultat);
      savedElements.clear();

      if (mapResultat != null && mapResultat.isNotEmpty) {
        for (int i = 0; i < myList.length; i++) {
          mapResultat.forEach((key, value) async {
            if (key == myList[i]) {
              savedElements.add(SavedElement(myList[i], stringToColor(value), false));
            }
          });
        }
      } else {
        for (int i = 0; i < myList.length; i++) {
          savedElements.add(SavedElement(myList[i], Colors.black, false));
        }
      }
      if (!mounted) return;
      setState(() {});
    }

    Future<void> deleteTexte(String currentText) async {
      DocumentReference documentRef = FirebaseFirestore.instance
          .collection('utilisateur')
          .doc(FirebaseAuth.instance.currentUser.uid);
      Map<String, dynamic> champs = {currentText: FieldValue.delete()};
      await documentRef.update(champs);
    }

    List<String> myList = [];
    Map<String, dynamic> mapResultat = {};
    myFunction(myList, mapResultat);

    if (widget.article.text.contains('&signature')) {
      sign;
    }

    void fonctionStockeFirebase(String newText) {
      final documentReference = FirebaseFirestore.instance
          .collection('utilisateur')
          .doc(FirebaseAuth.instance.currentUser.uid);

      documentReference
          .update({newText: []})
          .then((value) => print("Champ ajouté avec succès"))
          .catchError((error) => print("Erreur lors de l'ajout du champ : $error"));
    }

    void fonctionAjoutCouleur(String newText, String hexColor) async {
      final CollectionReference articlesCollection =
      FirebaseFirestore.instance.collection('utilisateur');
      Map<String, dynamic> nouvelleValeur = {newText: hexColor};

      Map<String, dynamic> monChamp = await getMapFields();
      monChamp.addAll(nouvelleValeur);

      articlesCollection
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({'couleurs': monChamp})
          .then((value) => print("Champ Map ajouté avec succès"))
          .catchError((error) => print("Erreur lors de l'ajout du champ : $error"));
    }

    void fonctionStcokeIdArticle(String text, String id) {
      final CollectionReference articlesCollection =
      FirebaseFirestore.instance.collection('utilisateur');
      articlesCollection.doc(FirebaseAuth.instance.currentUser.uid).update({
        text: FieldValue.arrayUnion([id]),
      }).then((context) {
        print('Chaine ajoutée avec succès.');
      }).catchError((error) {
        print('Erreur lors de l\'ajout de la chaine : $error');
      });
    }

    Future<void> deleteItem(String itemName, String text) async {
      final CollectionReference collection =
      FirebaseFirestore.instance.collection('utilisateur');
      try {
        DocumentSnapshot documentSnapshot = await documentReference.get();
        Map<String, dynamic> documentData =
        documentSnapshot.data() as Map<String, dynamic>;

        documentData.forEach((key, value) async {
          if (value is List) {
            if (key != 'favoris') {
              await collection
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .update({
                text: FieldValue.arrayRemove([itemName])
              });
            }
          }
        });
        print('Élément supprimé avec succès');
      } catch (e) {
        print('Erreur lors de la suppression de l\'élément : $e');
      }
    }

    Future<void> supprimerItemDuParcours() async {
      final marker = markerProvider
          .getAllMarkers()
          .singleWhere((element) => element.idArticle == widget.article.id);
      final documentReference = FirebaseFirestore.instance
          .collection('utilisateur')
          .doc(FirebaseAuth.instance.currentUser.uid);
      final documentSnapshot = await documentReference.get();
      var dataUser = documentSnapshot.data();
      final mapData = dataUser['couleurs'] as Map<String, dynamic>;
      if (mapData != null) {
        for (var parcours in mapData.keys) {
          if (dataUser.containsKey(parcours)) {
            var markers = dataUser[parcours];
            if (markers.contains(marker.id)) {
              await documentReference.update({
                parcours: FieldValue.arrayRemove([marker.id])
              });
            }
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.article.imageUrl.isNotEmpty ||
              widget.article.photo.isNotEmpty ||
              imagesMap.containsKey(widget.article.title))
            Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: widget.article.imageUrl.isNotEmpty
                  ? Image.network(
                widget.article.imageUrl,
                fit: BoxFit.cover,
              )
                  : widget.article.photo.isNotEmpty
                  ? Image.asset(
                widget.article.photo,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                imagesMap[widget.article.title],
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(height: 20),

          // -------------------------------------------------------------
          // BARRE DES DEUX BOUTONS (Enregistrer / Écouter + Discussion)
          // -------------------------------------------------------------
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            color: Colors.white,
            width: double.infinity,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // AJOUT : On entoure l'icône "enregistrer" + texte "Enregistrer" dans une Row
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (!widget.like) {
                          if (!trade) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Ajouter à un parcours ?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          widget.changeFavorite(widget.idMaker);
                                          widget.deleteItem(widget.article.id);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Non"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                          return showModalBottomSheet(
                                            context: context,
                                            builder: (context) => Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.6,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '   Enregistrer dans ...',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontFamily: 'myriad',
                                                          ),
                                                        ),
                                                        SingleChildScrollView(
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                context,
                                                                builder:
                                                                    (BuildContext
                                                                context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'Nom du parcours'),
                                                                    content:
                                                                    SingleChildScrollView(
                                                                      child:
                                                                      Column(
                                                                        mainAxisSize:
                                                                        MainAxisSize.min,
                                                                        children: [
                                                                          Text('Couleur du texte :'),
                                                                          SizedBox(height: 10),
                                                                          ColorPicker(
                                                                            pickerColor: Colors.black,
                                                                            onColorChanged: (clr){},
                                                                            pickerAreaHeightPercent: 0.8,
                                                                          ),
                                                                          SizedBox(height: 10),
                                                                          TextField(
                                                                            controller: _textEditingController,
                                                                            decoration: InputDecoration(
                                                                                hintText: 'Entrez le texte ici'
                                                                            ),
                                                                            onChanged: (text) {
                                                                              _textEditingController.value = TextEditingValue(
                                                                                text: text.length > 0
                                                                                    ? text[0].toUpperCase() + text.substring(1)
                                                                                    : '',
                                                                                selection: _textEditingController.selection,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        child: Text('Annuler'),
                                                                        onPressed: () {
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        child: Text('OK'),
                                                                        onPressed: () {
                                                                          final newText = _textEditingController.text;
                                                                          // (À compléter : apply color if needed)
                                                                          fonctionStockeFirebase(newText);
                                                                          fonctionAjoutCouleur(newText, "#FF0000"); // exemple
                                                                          if (newText.isNotEmpty) {
                                                                            savedElements.add(SavedElement(newText, Colors.black, false));
                                                                          }
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: Text(
                                                              '+ Parcours',
                                                              style: TextStyle(
                                                                color: Color.fromARGB(255, 33, 44, 243),
                                                              ),
                                                            ),
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                              MaterialStateProperty.all<Color>(
                                                                  Colors.white),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ParcoursItem(
                                                      taille: savedElements.length,
                                                      liste: savedElements,
                                                      deleteTexte: deleteTexte,
                                                      deleteItem: deleteItem,
                                                      fonctionStcokeIdArticle:
                                                      fonctionStcokeIdArticle,
                                                      marker: widget.marker,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text("Oui"),
                                      ),
                                    ],
                                  );
                                });
                          } else {
                            // version anglaise
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Add to a course ?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          widget.changeFavorite(widget.idMaker);
                                          widget.deleteItem(widget.article.id);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("No"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                          return showModalBottomSheet(
                                            context: context,
                                            builder: (context) => Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.6,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '   Save in ...',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontFamily:
                                                            'myriad',
                                                          ),
                                                        ),
                                                        SingleChildScrollView(
                                                          child:
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                context,
                                                                builder:
                                                                    (BuildContext
                                                                context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'course name'),
                                                                    content:
                                                                    SingleChildScrollView(
                                                                      child:
                                                                      Column(
                                                                        mainAxisSize:
                                                                        MainAxisSize.min,
                                                                        children: [
                                                                          Text('Course color :'),
                                                                          SizedBox(height: 10),
                                                                          ColorPicker(
                                                                            pickerColor: Colors.black,
                                                                            onColorChanged: (clr){},
                                                                            pickerAreaHeightPercent: 0.8,
                                                                          ),
                                                                          SizedBox(height: 10),
                                                                          TextField(
                                                                            controller: _textEditingController,
                                                                            decoration: InputDecoration(hintText: 'Enter the name of the course'),
                                                                            onChanged: (text) {
                                                                              _textEditingController.value = TextEditingValue(
                                                                                text: text.length > 0
                                                                                    ? text[0].toUpperCase() + text.substring(1)
                                                                                    : '',
                                                                                selection: _textEditingController.selection,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        child: Text('Cancel'),
                                                                        onPressed: () {
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        child: Text('OK'),
                                                                        onPressed: () {
                                                                          final newText = _textEditingController.text;
                                                                          fonctionStockeFirebase(newText);
                                                                          fonctionAjoutCouleur(newText, "#FF0000"); // exemple
                                                                          if (newText.isNotEmpty) {
                                                                            savedElements.add(SavedElement(newText, Colors.black, false));
                                                                          }
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: Text(
                                                              '+ Course',
                                                              style: TextStyle(
                                                                color: Color.fromARGB(255, 33, 44, 243),
                                                              ),
                                                            ),
                                                            style:
                                                            ButtonStyle(
                                                              backgroundColor:
                                                              MaterialStateProperty.all<Color>(
                                                                  Colors.white),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ParcoursItem(
                                                      taille: savedElements.length,
                                                      liste: savedElements,
                                                      deleteTexte: deleteTexte,
                                                      deleteItem: deleteItem,
                                                      fonctionStcokeIdArticle:
                                                      fonctionStcokeIdArticle,
                                                      marker: widget.marker,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text("Yes"),
                                      ),
                                    ],
                                  );
                                });
                          }
                        }

                        // retire du parcours s'il y était
                        await supprimerItemDuParcours();

                        widget.changeFavorite(widget.idMaker);
                        widget.deleteItem(widget.article.id);

                        if (!mounted) return;
                        setState(() {});
                      },

                      // AJOUT : On affiche icône + texte "Enregistrer"
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 1,
                                  child: Icon(
                                    Icons.add,
                                    size: 18,
                                    color: widget.like ? colorButtonAdd : Colors.black45,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: widget.like ? colorButtonAdd : Colors.black45,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Le texte "Enregistrer"
                          Text(
                            !trade ? "Enregistrer" : "Save",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ],
                      ),
                    ),

                    // ------------------------------------------------------
                    //  BOUTON “Écouter”
                    // ------------------------------------------------------
                    if (widget.article.audio.isNotEmpty)
                    // Petite marge horizontale
                      SizedBox(width: 20),
                    if (widget.article.audio.isNotEmpty)
                      Center(
                        child: Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              icon: (!widget.firstLaunchOfArticle)
                                  ? Image.asset(
                                "assets/images/ICON_VOLUME_VIOLET.png",
                                width: 23,
                                height: 23,
                              )
                                  : (widget.article == widget.secondArticle)
                                  ? Image.asset(
                                "assets/images/ICON_VOLUME.png",
                                width: 23,
                                height: 23,
                              )
                                  : Image.asset(
                                "assets/images/ICON_VOLUME_VIOLET.png",
                                width: 23,
                                height: 23,
                              ),
                              onPressed: _onAudioPressed,
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: _onAudioPressed,
                              child: Text(
                                !trade ? "Écouter" : "Listen",
                                style: TextStyle(fontSize: 15, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                // ------------------------------------------------------
                //  Bouton commentaire (DISCUSS)
                // ------------------------------------------------------
                TextButton(
                  child: Row(
                    children: [
                      Text(
                        'DISCUSS',
                        style: TextStyle(
                          fontFamily: 'myriad',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color.fromRGBO(209, 62, 150, 1),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.black45, size: 17),
                    ],
                  ),
                  onPressed: widget.switchToComm,
                ),
              ],
            ),
          ),

          // -------------------------------------------------------------
          // CORPS DU CONTENU
          // -------------------------------------------------------------
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SingleChildScrollView(
                child: Scrollbar(
                  child: GestureDetector(
                    onScaleUpdate: (ScaleUpdateDetails details) {
                      _pinch(details);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (intro.length == 2)
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            margin: EdgeInsets.all(10),
                            child: SelectableText(
                              intro[0],
                              style: TextStyle(
                                fontFamily: 'myriad',
                                fontSize: _sizeIntro,
                              ),
                            ),
                          ),
                        SizedBox(height: 20),
                        Container(
                          color: Colors.white,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: SelectableText(
                            !trade
                                ? widget.article.title
                                : widget.article.titleEN.isEmpty
                                ? widget.article.title
                                : widget.article.titleEN,
                            style: TextStyle(
                              fontFamily: 'myriad',
                              color: Colors.black,
                              fontSize: _sizeTitre,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Mots clés
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Wrap(
                            spacing: 5,
                            children: _buildAllChip(),
                            runSpacing: 3,
                          ),
                        ),

                        if (widget.article.architecte.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.architecte, 'Architecte ')
                              : buildInfo(widget.article.architecte, 'Architect '),

                        if (widget.article.associe.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.associe, 'Architecte associé ')
                              : buildInfo(widget.article.associe, 'Associate architect '),

                        if (widget.article.transformation.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.transformation, 'Architecte transformation ')
                              : buildInfo(widget.article.transformation, 'Transformation architect '),

                        if (widget.article.monument.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.monument, 'Architecte des Monuments Historiques ')
                              : buildInfo(widget.article.monument, 'Architect of the historical monuments '),

                        if (widget.article.projet.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.projet, 'Architecte de projet ')
                              : buildInfo(widget.article.projet, 'Project architect '),

                        if (widget.article.local.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.local, 'Architecte local ')
                              : buildInfo(widget.article.local, 'Local architect '),

                        if (widget.article.operation.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.operation, 'Architecte des opérations connexes ')
                              : buildInfo(widget.article.operation, 'Related operations architect '),

                        if (widget.article.patrimoine.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.patrimoine, 'Architecte du patrimoine ')
                              : buildInfo(widget.article.patrimoine, 'Heritage architect '),

                        if (widget.article.chef.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.chef, 'Chef de projet ')
                              : buildInfo(widget.article.chef, 'Project manager '),

                        if (widget.article.ingenieur.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.ingenieur, 'Ingénieur ')
                              : buildInfo(widget.article.ingenieur, 'Engineer '),

                        if (widget.article.paysagiste.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.paysagiste, 'Paysagiste ')
                              : buildInfo(widget.article.paysagiste, 'Landscaper '),

                        if (widget.article.urbaniste.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.urbaniste, 'Urbaniste ')
                              : buildInfo(widget.article.urbaniste, 'Urban planner '),

                        if (widget.article.artiste.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.artiste, 'Artiste ')
                              : buildInfo(widget.article.artiste, 'Artist '),

                        if (widget.article.eclairagiste.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.eclairagiste, 'Eclairagiste ')
                              : buildInfo(widget.article.eclairagiste, 'Lighting designer '),

                        if (widget.article.musee.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.musee, 'Conservateur du musée ')
                              : buildInfo(widget.article.musee, 'Museum curator '),

                        if (widget.article.lieu.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.lieu, 'Adresse ')
                              : buildInfo(widget.article.lieu, 'Address '),

                        if (widget.article.date.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.date, 'Année ')
                              : buildInfo(widget.article.date, 'Year '),

                        if (widget.article.installation.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.installation, 'Année d\'installation à Paris ')
                              : buildInfo(widget.article.installation, 'Year of settlement in Paris '),

                        if (widget.article.dimensions.isNotEmpty)
                          buildInfo(widget.article.dimensions, 'Dimensions '),

                        if (widget.article.expositions.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.expositions, 'Expositions ')
                              : buildInfo(widget.article.expositions, 'Exhibitions '),

                        if (widget.article.surface.isNotEmpty)
                          buildInfo(widget.article.surface, 'Surface '),

                        if (widget.article.construire.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.construire, 'Surface à construire ')
                              : buildInfo(widget.article.construire, 'Building area '),

                        if (widget.article.surfaceExpo.isNotEmpty)
                          !trade
                              ? buildInfo(widget.article.surfaceExpo, 'Surface d\'exposition ')
                              : buildInfo(widget.article.surfaceExpo, 'Exhibition area '),

                        SizedBox(height: 10),
                        Divider(
                          thickness: 2,
                          color: Colors.black54,
                          endIndent: 20,
                          indent: 20,
                        ),

                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              SelectableText(
                                gras[0],
                                style: TextStyle(
                                  fontFamily: 'myriad',
                                  fontSize: _sizeText,
                                ),
                              ),
                              ...addBoldToText(),
                              if (widget.article.text.contains('&signature'))
                                Container(
                                  width: double.infinity,
                                  child: SelectableText(
                                    sign,
                                    style: TextStyle(
                                      fontFamily: 'myriad',
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 350),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildInfo(info, txt) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SelectableText.rich(
        TextSpan(
          text: txt + "  ",
          style: TextStyle(
            fontFamily: 'myriad',
            fontSize: _sizeInfo,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: info,
              style: TextStyle(
                fontFamily: 'myriad',
                fontSize: _sizeInfo,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SavedElement {
  final String text;
  final Color color;
  bool selected;

  SavedElement(this.text, this.color, this.selected);
}
