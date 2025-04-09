import 'package:firebase_storage/firebase_storage.dart';

import '../../models/article.dart';
import '../../models/customMarker.dart';
import '../../providers/articleProvider.dart';
import '../../providers/markerProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../utilities/constants.dart';

class Balise {
  final BuildContext context;

  /// Valeur du zoom de la map
  final double zoomMap;

  /// Liste de marker filtré
  final List<CustomMarker> markersFiltered;

  /// Permet d''ouvrir un article
  final Function openMarker;

  /// Degré de rotation de la map
  final double rotation;

  Balise(
      {this.context,
      this.markersFiltered,
      this.zoomMap,
      this.openMarker,
      this.rotation = 0});

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
    'Hôpital Cognacq-Jay':
        'assets/Hôpital Cognacq-Jay - Toyo Ito/IMG_9574.jpeg',
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

  /// @args - item marqueur
  /// @return Renvoie l'image du marqueur
  Future<String> getImage(Article article, [bool test = false]) async {
    String snap = "";
    if (test) {
      snap = await FirebaseStorage.instance
          .ref()
          .child(article.image)
          .getDownloadURL();
    }
    return snap;
  }

  Color stringToColor(String colorString) {
    String valueString = colorString.replaceAll("#", "");

    if (valueString.length == 6) {
      valueString = "FF" + valueString;
    }
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }

  Widget _imageMarker(
      CustomMarker item, String type, Map<String, dynamic> dataUser) {
    final article = Provider.of<ArticleProvider>(context, listen: false)
        .markerToArticle(item.idArticle);
    final markerProvider = Provider.of<MarkerProvider>(context, listen: false);

    //fonction qui recupere la couleur du parcours
    Color getColor() {
      final parcoursColores = dataUser['couleurs'] as Map<String, dynamic>;

      // Récupération du marker de l'article
      var marker = markerProvider
          .getAllMarkers()
          .singleWhere((element) => element.idArticle == item.idArticle);

      if (parcoursColores == null) return Colors.transparent;
      for (var parcours in parcoursColores.keys) {
        if (dataUser.containsKey(parcours)) {
          var markers = dataUser[parcours];
          if (markers.contains(marker.id)) {
            return stringToColor(parcoursColores[parcours]);
          }
        }
      }
      return Colors.transparent;
    }

    // 2024 : 02-parcours1
    Color color = getColor();

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: Container(
            alignment: AlignmentDirectional.bottomCenter,
            child: Text(
              article.title,
              style: TextStyle(
                fontFamily: 'myriad',
                fontSize: 23,
                //color: Colors.white,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          )),
          if (type == 'marqueurVioletSélectionné')
            GestureDetector(
              onTap: () {
                openMarker(item);
              },
              child: Container(
                  child: Image(
                height: 40,
                width: 40,
                image: AssetImage('assets/images/marker/$type.png'),
              )),
            ),
          if (type == 'marqueurViolet')
            GestureDetector(
              onTap: () {
                openMarker(item);
              },
              child: Container(
                  child: Image(
                height: 40,
                width: 40,
                image: AssetImage('assets/images/marker/$type.png'),
              )),
            ),
          if (type == 'marqueurVioletFoncé')
            GestureDetector(
              onTap: () {
                openMarker(item);
              },
              child: Container(
                  child: Image(
                height: 40,
                width: 40,
                image: AssetImage('assets/images/marker/$type.png'),
              )),
            ),
          if (type == 'marqueurVioletFoncéSélectionné')
            GestureDetector(
              onTap: () {
                openMarker(item);
              },
              child: Container(
                  child: Image(
                height: 40,
                width: 40,
                image: AssetImage('assets/images/marker/$type.png'),
              )),
            ),
          if (type == 'marqueurVioletFoncéCoeur')
            GestureDetector(
              onTap: () {
                openMarker(item);
              },
              child: Stack(
                children: [
                  Positioned(
                    child: Stack(
                      children: [
                        Image(
                          height: 40,
                          width: 40,
                          image: AssetImage(
                              'assets/images/marker/marqueurVioletFoncé.png'),
                        ),
                        Positioned(
                          top: -1,
                          right: 20.0,
                          child: Icon(
                            Icons.circle,
                            color: color,
                            size: 18.0,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          if (type == 'marqueurVioletFavori')
            GestureDetector(
              onTap: () {
                openMarker(item);
              },
              child: Stack(
                children: [
                  Positioned(
                    child: Stack(
                      children: [
                        Image(
                          height: 40,
                          width: 40,
                          image: AssetImage(
                              'assets/images/marker/marqueurViolet.png'),
                        ),
                        Positioned(
                          top: -1,
                          right: 20.0,
                          child: Icon(
                            Icons.circle,
                            color: color,
                            size: 18.0,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          if (type == 'marqueurVioletSélectionnéCoeur')
            GestureDetector(
              onTap: () {
                openMarker(item);
              },
              child: Stack(
                children: [
                  Positioned(
                    child: Stack(
                      children: [
                        Image(
                          height: 40,
                          width: 40,
                          image: AssetImage(
                              'assets/images/marker/marqueurVioletSélectionné.png'),
                        ),
                        Positioned(
                          top: -1,
                          right: 20.0,
                          child: Icon(
                            Icons.circle,
                            color: color,
                            size: 18.0,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          if (type == 'marqueurVioletFoncéSélectionnéCoeur')
            GestureDetector(
              onTap: () {
                openMarker(item);
              },
              child: Stack(
                children: [
                  Positioned(
                    child: Stack(
                      children: [
                        Image(
                          height: 40,
                          width: 40,
                          image: AssetImage(
                              'assets/images/marker/marqueurVioletFoncéSélectionné.png'),
                        ),
                        Positioned(
                          top: -1,
                          right: 20.0,
                          child: Icon(
                            Icons.circle,
                            color: color,
                            size: 18.0,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _mainImage(CustomMarker item, Map<String, dynamic> dataUser) {
    final article = Provider.of<ArticleProvider>(context, listen: false)
        .markerToArticle(item.idArticle);
    final markerProvider = Provider.of<MarkerProvider>(context, listen: false);

    // Récupère la couleur associée au parcours
    Color getColor() {
      final parcoursColores = dataUser['couleurs'] as Map<String, dynamic>;
      var marker = markerProvider
          .getAllMarkers()
          .singleWhere((element) => element.idArticle == item.idArticle);
      if (parcoursColores == null) return Colors.transparent;
      for (var parcours in parcoursColores.keys) {
        if (dataUser.containsKey(parcours)) {
          var markers = dataUser[parcours];
          if (markers.contains(marker.id)) {
            return stringToColor(parcoursColores[parcours]);
          }
        }
      }
      return Colors.transparent;
    }

    Color color = getColor();

    // Vérifie si l'article possède une image en ligne ou une image d'assets
    bool hasNetworkImage = article.imageUrl != null && article.imageUrl.isNotEmpty;
    bool hasAssetImage = imagesMap.containsKey(article.title);

    // Cas où l'article est supposé afficher une image (soit par son texte, soit si l'article a une photo associée)
    if ((article.text.isNotEmpty && item.isFavorite == false && item.isVisible) || item.hasPhoto) {
      if (!item.hasPhoto) {
        return _imageMarker(item, 'marqueurVioletSélectionné', dataUser);
      }
      // Si l'article possède une image via imageUrl ou via l'asset (imagesMap)
      if (hasNetworkImage || hasAssetImage) {
        Widget imageWidget = _imageCircle(item, article, color);
        if (zoomMap > 15.5) {
          return Column(
            children: [
              Text(
                article.title,
                style: TextStyle(
                  fontFamily: 'myriad',
                  fontSize: 23,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              Expanded(child: imageWidget),
            ],
          );
        } else {
          return imageWidget;
        }
      } else {
        // Si aucune image n'est disponible, on retombe sur le marqueur standard
        if (zoomMap > 15.5)
          return _imageMarker(item, 'marqueurVioletSélectionné', dataUser);
        else
          return GestureDetector(
            onTap: () {
              openMarker(item);
            },
            child: Transform.scale(
              scale: item.isVisible ? 1.4 : 1.0,
              child: Image(
                height: 40,
                width: 40,
                image: AssetImage('assets/images/marker/marqueurVioletSélectionné.png'),
              ),
            ),
          );
      }
    } else if (article.text.isEmpty && item.isFavorite == false) {
      if (zoomMap > 15.5)
        return _imageMarker(
            item,
            item.isVisible
                ? 'marqueurVioletFoncéSélectionné'
                : 'marqueurVioletFoncé',
            dataUser);
      else
        return GestureDetector(
          onTap: () {
            openMarker(item);
          },
          child: Transform.scale(
            scale: item.isVisible ? 1.4 : 1.0,
            child: Image(
              height: 40,
              width: 40,
              image: AssetImage(item.isVisible
                  ? 'assets/images/marker/marqueurVioletFoncéSélectionné.png'
                  : 'assets/images/marker/marqueurVioletFoncé.png'),
            ),
          ),
        );
    } else if (article.text.isEmpty && item.isFavorite) {
      if (zoomMap > 15.5)
        return _imageMarker(item, 'marqueurVioletFoncéCoeur', dataUser);
      else
        return GestureDetector(
          onTap: () async {
            openMarker(item);
          },
          child: Stack(
            children: [
              Positioned(
                child: Transform.scale(
                  scale: item.isVisible ? 1.4 : 1.0,
                  child: Stack(
                    children: [
                      Image(
                        height: 40,
                        width: 40,
                        image: AssetImage(item.isVisible
                            ? 'assets/images/marker/marqueurVioletFoncéSélectionné.png'
                            : 'assets/images/marker/marqueurVioletFoncé.png'),
                      ),
                      Positioned(
                        top: -1,
                        right: 20.0,
                        child: Icon(
                          Icons.circle,
                          color: color,
                          size: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
    } else if (article.text.isNotEmpty && item.isFavorite == false) {
      if (zoomMap > 15.5)
        return _imageMarker(
            item,
            item.isVisible ? 'marqueurVioletSélectionné' : 'marqueurViolet',
            dataUser);
      else {
        return GestureDetector(
            onTap: () {
              openMarker(item);
            },
            child: Transform.scale(
              scale: item.isVisible ? 1.4 : 1.0,
              child: Image(
                height: 40,
                width: 40,
                image: AssetImage(item.isVisible
                    ? 'assets/images/marker/marqueurVioletSélectionné.png'
                    : 'assets/images/marker/marqueurViolet.png'),
              ),
            ));
      }
    } else {
      if (zoomMap > 15.5)
        return _imageMarker(item, 'marqueurVioletFavori', dataUser);
      else {
        return GestureDetector(
          onTap: () {
            openMarker(item);
          },
          child: Stack(
            children: [
              Positioned(
                child: Transform.scale(
                  scale: item.isVisible ? 1.4 : 1.0,
                  child: Stack(
                    children: [
                      Image(
                        height: 40,
                        width: 40,
                        image: AssetImage(item.isVisible
                            ? 'assets/images/marker/marqueurVioletSélectionné.png'
                            : 'assets/images/marker/marqueurViolet.png'),
                      ),
                      Positioned(
                        top: -1,
                        right: 20.0,
                        child: Icon(
                          Icons.circle,
                          color: color,
                          size: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }
    }
    return Container();
  }



  GestureDetector _imageCircle(
      CustomMarker item, Article article, Color color) {
    return GestureDetector(
      onTap: () {
        openMarker(item);
      },
      child: Transform.scale(
        scale: item.isVisible ? 1.4 : 1.0,
        child: Container(
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: article.imageUrl != null && article.imageUrl.isNotEmpty
                      ? NetworkImage(article.imageUrl)
                      : AssetImage(imagesMap[article.title]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: -1,
              right: zoomMap > 15.5 ? 110.0 : 20.0,
              child: Icon(
                Icons.circle,
                color: color,
                size: 18.0,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  /// @args - item marqueur
  /// @return Renvoie le design d'un marker
  Marker _buildMarker(CustomMarker item, Map<String, dynamic> dataUser) {
    return Marker(
        anchorPos: AnchorPos.align(AnchorAlign.top),
        width: zoomMap > 15.5 ? 180 : 40,
        height: zoomMap > 15.5 ? 120 : 40,
        rotate: true,
        point: LatLng(item.latitude, item.longitude),
        builder: (ctx) => Transform.rotate(
              angle: -rotation * math.pi / 180,
              alignment: Alignment.bottomCenter,
              child: _mainImage(item, dataUser),
            ));
  }

  List<Marker> buildAllMarker(Map<String, dynamic> dataUser) {
    List<Marker> _markers = [];

    final markersData = Provider.of<MarkerProvider>(context);

    if (markersFiltered.isEmpty)
      for (var i = 0; i < markersData.markers.length; i++) {
        _markers.add(_buildMarker(markersData.markers[i], dataUser));
      }
    else
      for (var i = 0; i < markersFiltered.length; i++) {
        _markers.add(_buildMarker(markersFiltered[i], dataUser));
      }

    return _markers;
  }
}
