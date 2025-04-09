import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/article.dart';

import '../../models/customMarker.dart';
import '../../models/tag.dart';
import '../../providers/TraductionController.dart';
import '../../providers/articleProvider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/markerProvider.dart';
import '../../providers/tagProvider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../utilities/constants.dart';
import '../audioWidgets/audio.dart';

class parcoursItemList extends StatefulWidget {
  parcoursItemList(
      {this.article,
      this.firstLaunchOfArticle,
      this.secondArticle,
      this.audioState,
      this.play,
      this.snapshot,
      this.audioPlayer,
      this.lance,
      this.pausePlayer,
      this.stopPlayer,
      this.isPopUpOpen,
      this.savedMaxDuration,
      this.savedPosition,
      this.updateDuration,
      this.afficherArticle,
      this.marker,
      this.setFirstLaunchOfArticle,
      this.updateMarkerForPopUp,
      this.articleCallback,
      this.articlesData,
      this.markersData,
      this.idarticle,
      this.nomParcours,
      this.delete});

  final Article article;
  final bool firstLaunchOfArticle;
  //Un second article
  final Article secondArticle;
//Permet de savoir si l'audio est en cours ou non
  final bool audioState;

  //La fonction qui permet de lancer l'audio
  final Function play;

  //Snapshot d'où provient l'audio
  final String snapshot;

  String idarticle;
  String nomParcours;
  final Function delete;

  //L'audioPlayer qui permet de jouer/mettre en pause un article
  final AudioPlayer audioPlayer;
  //Permet de savoir si le popUp est lancé ou non
  final bool lance;

  //La fonction qui permet de pause l'audio
  final Function pausePlayer;

  //La fonction qui permet d'areter l'audio
  final Function stopPlayer;

  //Fonction callBack qui permet de renvoyer le booleen vers CarteScreen permettant de savoir si le popUp est ouvert
  final Function(bool) isPopUpOpen;

  //Permet de sauvegarder la durée max d'un audio
  final Duration savedMaxDuration;

  //Permet de sauvegarder la position d'un audio
  final Duration savedPosition;

  //Fonction callBack permettant de remonter les données de savedPosition et savedMaxPosition vers CarteScreen
  final Function(Duration, Duration) updateDuration;

  //Permet de set le bool à true
  final Function setFirstLaunchOfArticle;

  //Fonction qui permet d'ouvrir un article depuis le popupp audio
  final Function afficherArticle;

  //Le marker conrrespondant à l'article courant
  final CustomMarker marker;

  //Fonction pour actualiser le marker utilisé dans audioBottomBar
  final Function(CustomMarker) updateMarkerForPopUp;

  //Fonction callBack qui permet de "faire remonter" les données d'un article vers "CarteScreen"
  final Function(Article, AudioPlayer, bool, String) articleCallback;

  //Les markers de l'application
  final MarkerProvider markersData;

  //Les articles de l'application
  final ArticleProvider articlesData;
  @override
  _parcoursItemListState createState() => _parcoursItemListState();
}

class _parcoursItemListState extends State<parcoursItemList> {
  Article article;

  // Le nouvel article qui sera retourner dans carteScreen
  Article newArticle;

  //La nouvelle snapshot qui sera retourné dans carteScreen
  String newSnapshot;

  // Savoir si c'est un nouvel audio ou pas
  bool newAudio = false;

  // Le nouveau state qui sera retourner dans carteScreen
  bool newState;

  // La couleur du parcours
  Color color = Colors.black;

  //Permet de recuperer les donnees du nouvel audio joue aleatoirement dans audio.dart
  //Au depart elle me servait uniquemement pour un nouvel audio, mais maintenant je l'utilise des que le state change dans audio.dart
  void randomAudioCallback(
      Article newArticle, String newSnapshot, bool newState, bool newAudio) {
    this.newArticle = newArticle;
    this.newSnapshot = newSnapshot;
    this.newAudio = newAudio;
    this.newState = newState;
  }

  //Permet de modifier la valeur du bool lance
  //Si un nouvel audio est joué on renvoie les données de l'article vers CarteScreen pour l'afficher sur l'AudioBottomBar
  void setStateLance() {
    widget.isPopUpOpen(!widget.lance);
    if (newAudio)
      widget.articleCallback(
          newArticle, widget.audioPlayer, newState, newSnapshot);
    else
      widget.articleCallback(widget.article, widget.audioPlayer,
          widget.audioState, widget.snapshot);

    newAudio = false;
  }

  double _sizeInfo = 16;
  @override
  Widget build(BuildContext context) {
    var trade =
        Provider.of<TraductionController>(context, listen: false).trade.value ??
            false;
    final articlesData = Provider.of<ArticleProvider>(context, listen: false);
    final markerProvider = Provider.of<MarkerProvider>(context, listen: false);
    List<String> options = articlesData.getListTitle();
    options.sort((a, b) => a.compareTo(b));

    List<String> labels = Provider.of<TagProvider>(context, listen: false)
        .listLabel(widget.article.tags, trade);
    List<Tag> _labels = Provider.of<TagProvider>(context).tags;
    labels.sort((a, b) => a.compareTo(b));

    /// @return Renvoi le titre de l'article
    String getTitle() {
      return articlesData.markerToArticle(widget.article.id).title;
    }

    /// @return Renvoi l'architecte titre de l'article
    String getArchitecte() {
      return articlesData.markerToArticle(widget.article.id).architecte;
    }

    /// @return Renvoi le titre de l'article
    String getTitleEn() {
      return articlesData.markerToArticle(widget.article.id).titleEN;
    }

    /// @return Renvoi la date de l'article
    String getDate() {
      return articlesData.markerToArticle(widget.article.id).date;
    }

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
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
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
                              fontSize: 20),
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
            }),
      );
    }

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

    Color stringToColor(String colorString) {
      String valueString = colorString.replaceAll("#", "");
      if (valueString.length == 6) {
        valueString = "FF" + valueString;
      }
      int value = int.parse(valueString, radix: 16);
      return Color(value);
    }

    //fonction qui recupere la couleur du parcours
    Future<void> getColor() async {
      // Récupération de la référence au document Firebase
      final documentReference = FirebaseFirestore.instance
          .collection('utilisateur')
          .doc(FirebaseAuth.instance.currentUser.uid);

      // Récupération du document Firebase
      final documentSnapshot = await documentReference.get();

      // Récupération du champ de type Map à partir du document
      var data = documentSnapshot.data();
      final mapData = data['couleurs'] as Map<String, dynamic>;

      // Récupération du marker de l'article
      var marker = markerProvider
          .getAllMarkers()
          .singleWhere((element) => element.idArticle == widget.article.id);

      if (data.containsKey(widget.nomParcours)) {
        var markers = data[widget.nomParcours];
        if (markers.contains(marker.id)) {
          if (!mounted) return;

          setState(() {
            color = stringToColor(mapData[widget.nomParcours]);
          });
        }
      }
    }

    // 2024 : 02-parcours3
    getColor();

    String assetImage = assetFromTitle(widget.article);

    return ClipRect(
      child: Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (assetImage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                      height: 120,
                      width: 120,
                      child: Image(
                        image: AssetImage(
                          assetImage,
                        ),
                        fit: BoxFit.cover,
                      )),
                ),
              if (widget.article.image.isNotEmpty)
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 10),
                      height: 181,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (color != Colors.black)
                                    Icon(
                                      Icons.circle,
                                      color: color,
                                      size: 18.0,
                                    ),
                                  if (color != Colors.black)
                                    SizedBox(
                                      width: 5,
                                    ),
                                  Expanded(
                                      child: !trade
                                          ? Text(
                                              getTitle(),
                                              // gettitlefromliste(options),
                                              style: TextStyle(
                                                fontFamily: 'myriad',
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                              //maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          : widget.article.titleEN.isEmpty
                                              ? Text(
                                                  getTitle(),
                                                  // gettitlefromliste(options),
                                                  style: TextStyle(
                                                    fontFamily: 'myriad',
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                  ),
                                                  //maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              : Text(
                                                  getTitleEn(),
                                                  // gettitlefromliste(options),
                                                  style: TextStyle(
                                                    fontFamily: 'myriad',
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                  ),
                                                  //maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                  if (widget.article.audio.isNotEmpty)
                                    IconButton(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 25),
                                      //padding: EdgeInsets.only(top: 4.0),
                                      iconSize: 26,
                                      icon: (!widget.firstLaunchOfArticle)
                                          ? Image.asset(
                                              "assets/images/ICON_VOLUME_VIOLET.png")
                                          : (widget.article ==
                                                  widget.secondArticle)
                                              ? Image.asset(
                                                  "assets/images/ICON_VOLUME.png")
                                              : Image.asset(
                                                  "assets/images/ICON_VOLUME_VIOLET.png"),
                                      onPressed: () {
                                        newState = widget.audioState;

                                        //Les nouvelles durée initialisé à 0 si on change d'article
                                        //voir condition ternaire dans l'appel du constructeur de Audio juste en dessous
                                        Duration savedPosition = new Duration();
                                        Duration savedMaxDuration =
                                            new Duration();

                                        if (widget.secondArticle !=
                                                widget.article ||
                                            (widget.audioState &&
                                                widget.secondArticle !=
                                                    widget.article)) {
                                          widget.play(widget.snapshot);
                                          newState = true;
                                        }
                                        //Le statefulbuilder ne sert plus a rien normalement
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                StatefulBuilder(builder:
                                                    (context, setState) {
                                                  return GestureDetector(
                                                    onTap: () => Navigator.of(
                                                            context,
                                                            rootNavigator: true)
                                                        .pop(),
                                                    child: Dismissible(
                                                        movementDuration:
                                                            Duration(
                                                                seconds: 1),
                                                        key: Key("key"),
                                                        direction:
                                                            DismissDirection
                                                                .vertical,
                                                        onDismissed: (value) {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                        child: Audio(
                                                          article:
                                                              widget.article,
                                                          audioPlayer: widget
                                                              .audioPlayer,
                                                          snapshot:
                                                              widget.snapshot,
                                                          audioState: widget
                                                                  .firstLaunchOfArticle
                                                              ? newState != null
                                                                  ? newState
                                                                  : widget
                                                                      .audioState
                                                              : widget
                                                                  .audioState,
                                                          lance: widget.lance,
                                                          play: widget.play,
                                                          pausePlayer: widget
                                                              .pausePlayer,
                                                          stopPlayer:
                                                              widget.stopPlayer,
                                                          cameFromArticeItem:
                                                              true,
                                                          isPopupOpen: widget
                                                              .isPopUpOpen,
                                                          updateDuration: widget
                                                              .updateDuration,
                                                          savedMaxDuration: (widget
                                                                      .secondArticle ==
                                                                  widget
                                                                      .article)
                                                              ? widget
                                                                  .savedMaxDuration
                                                              : savedMaxDuration,
                                                          savedPosition: (widget
                                                                      .secondArticle ==
                                                                  widget
                                                                      .article)
                                                              ? widget
                                                                  .savedPosition
                                                              : savedPosition,
                                                          firstLaunchOfArticle:
                                                              widget
                                                                  .firstLaunchOfArticle,
                                                          setFirstLaunchOfArticle:
                                                              widget
                                                                  .setFirstLaunchOfArticle,
                                                          afficherArticle: widget
                                                              .afficherArticle,
                                                          marker: widget.marker,
                                                          updateMarkerForPopUp:
                                                              widget
                                                                  .updateMarkerForPopUp,
                                                          articleCallback: widget
                                                              .articleCallback,
                                                          randomAudioCallback:
                                                              randomAudioCallback,
                                                          articlesData: widget
                                                              .articlesData,
                                                          markersData: widget
                                                              .markersData,
                                                        )),
                                                  );
                                                })).then(
                                            (value) => setStateLance());
                                      },
                                    ),
                                ]),
                          ),
                          Container(
                            child: Text(
                              getArchitecte(),
                              style: TextStyle(
                                  fontFamily: 'myriad',
                                  color: Colors.black54,
                                  fontSize: 14),
                              maxLines: 1,
                            ),
                          ),
                          Text(
                            getDate(),
                            style: TextStyle(
                                fontFamily: 'myriad',
                                color: Colors.black54,
                                fontSize: 14),
                            maxLines: 1,
                          ),
                          Container(
                            child: Wrap(
                              spacing: 3,
                              children: _buildAllChip().toList(),
                              runSpacing: 2,
                            ),
                          ),
                        ],
                      )),
                ),
              if (widget.article.image.isEmpty)
                Expanded(
                  child: Container(
                      height: 181,
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (color != Colors.black)
                                      Icon(
                                        Icons.circle,
                                        color: color,
                                        size: 18.0,
                                      ),
                                    if (color != Colors.black)
                                      SizedBox(
                                        width: 5,
                                      ),
                                    Expanded(
                                        child: !trade
                                            ? Text(
                                                getTitle(),
                                                // gettitlefromliste(options),
                                                style: TextStyle(
                                                  fontFamily: 'myriad',
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                                //maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            : widget.article.titleEN.isEmpty
                                                ? Text(
                                                    getTitle(),
                                                    // gettitlefromliste(options),
                                                    style: TextStyle(
                                                      fontFamily: 'myriad',
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    ),
                                                    //maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : Text(
                                                    getTitleEn(),
                                                    // gettitlefromliste(options),
                                                    style: TextStyle(
                                                      fontFamily: 'myriad',
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    ),
                                                    //maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                    if (widget.article.audio.isNotEmpty)
                                      IconButton(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25),
                                        //padding: EdgeInsets.only(top: 4.0),
                                        iconSize: 26,
                                        icon: (!widget.firstLaunchOfArticle)
                                            ? Image.asset(
                                                "assets/images/ICON_VOLUME_VIOLET.png")
                                            : (widget.article ==
                                                    widget.secondArticle)
                                                ? Image.asset(
                                                    "assets/images/ICON_VOLUME.png")
                                                : Image.asset(
                                                    "assets/images/ICON_VOLUME_VIOLET.png"),
                                        onPressed: () {
                                          newState = widget.audioState;

                                          //Les nouvelles durée initialisé à 0 si on change d'article
                                          //voir condition ternaire dans l'appel du constructeur de Audio juste en dessous
                                          Duration savedPosition =
                                              new Duration();
                                          Duration savedMaxDuration =
                                              new Duration();

                                          if (widget.secondArticle !=
                                                  widget.article ||
                                              (widget.audioState &&
                                                  widget.secondArticle !=
                                                      widget.article)) {
                                            widget.play(widget.snapshot);
                                            newState = true;
                                          }
                                          //Le statefulbuilder ne sert plus a rien normalement
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  StatefulBuilder(builder:
                                                      (context, setState) {
                                                    return GestureDetector(
                                                      onTap: () => Navigator.of(
                                                              context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(),
                                                      child: Dismissible(
                                                          movementDuration:
                                                              Duration(
                                                                  seconds: 1),
                                                          key: Key("key"),
                                                          direction:
                                                              DismissDirection
                                                                  .vertical,
                                                          onDismissed: (value) {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop();
                                                          },
                                                          child: Audio(
                                                            article:
                                                                widget.article,
                                                            audioPlayer: widget
                                                                .audioPlayer,
                                                            snapshot:
                                                                widget.snapshot,
                                                            audioState: widget
                                                                    .firstLaunchOfArticle
                                                                ? newState !=
                                                                        null
                                                                    ? newState
                                                                    : widget
                                                                        .audioState
                                                                : widget
                                                                    .audioState,
                                                            lance: widget.lance,
                                                            play: widget.play,
                                                            pausePlayer: widget
                                                                .pausePlayer,
                                                            stopPlayer: widget
                                                                .stopPlayer,
                                                            cameFromArticeItem:
                                                                true,
                                                            isPopupOpen: widget
                                                                .isPopUpOpen,
                                                            updateDuration: widget
                                                                .updateDuration,
                                                            savedMaxDuration: (widget
                                                                        .secondArticle ==
                                                                    widget
                                                                        .article)
                                                                ? widget
                                                                    .savedMaxDuration
                                                                : savedMaxDuration,
                                                            savedPosition: (widget
                                                                        .secondArticle ==
                                                                    widget
                                                                        .article)
                                                                ? widget
                                                                    .savedPosition
                                                                : savedPosition,
                                                            firstLaunchOfArticle:
                                                                widget
                                                                    .firstLaunchOfArticle,
                                                            setFirstLaunchOfArticle:
                                                                widget
                                                                    .setFirstLaunchOfArticle,
                                                            afficherArticle: widget
                                                                .afficherArticle,
                                                            marker:
                                                                widget.marker,
                                                            updateMarkerForPopUp:
                                                                widget
                                                                    .updateMarkerForPopUp,
                                                            articleCallback: widget
                                                                .articleCallback,
                                                            randomAudioCallback:
                                                                randomAudioCallback,
                                                            articlesData: widget
                                                                .articlesData,
                                                            markersData: widget
                                                                .markersData,
                                                          )),
                                                    );
                                                  })).then(
                                              (value) => setStateLance());
                                        },
                                      ),
                                  ]),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                getArchitecte(),
                                style: TextStyle(
                                    fontFamily: 'myriad',
                                    color: Colors.black54,
                                    fontSize: 14),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                getDate(),
                                style: TextStyle(
                                    fontFamily: 'myriad',
                                    color: Colors.black54,
                                    fontSize: 14),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Container(
                            child: Wrap(
                              spacing: 3,
                              children: _buildAllChip().toList(),
                              runSpacing: 2,
                            ),
                          ),
                        ],
                      )),
                ),
            ]),
      ),
      //)
    );
  }
}
