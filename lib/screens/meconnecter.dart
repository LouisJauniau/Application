import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;

import 'package:aura2/providers/TraductionController.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cron/cron.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../models/User.dart';
import '../models/tag.dart';
import '../widgets/audioWidgets/audio.dart';
import '../widgets/audioWidgets/audioBottomBar.dart';
import '../widgets/favorisWidgets/animatedbuttom2.dart';
import '../widgets/favorisWidgets/boutonNord.dart';
import 'authentificationScreen/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/tagProvider.dart';
import '../widgets/commentaireWidgets/fenetreArticleCom.dart';
import '../widgets/markerWidgets/balise.dart';
import '../models/article.dart';
import '../models/customMarker.dart';
import '../providers/articleProvider.dart';
import '../providers/favoriteProvider.dart';
import '../providers/markerProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../widgets/favorisWidgets/listeFavoris.dart';
import '../widgets/markerWidgets/recherche.dart';
import '../widgets/drawer.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
// AJOUTEZ CET IMPORT SI CE N'EST PAS DEJA FAIT
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class meconnecter extends StatefulWidget {
  meconnecter({
    Key key,
    this.user,
    this.auth,
    this.login,
  }) : super(key: key);

  final bool auth;
  final User login;
  final UserCustom user;

  @override
  _MeconnecterState createState() => _MeconnecterState();
}

class _MeconnecterState extends State<meconnecter> {
  String _idArticle;
  bool _favorisVisible = false;
  bool _rechercheVisible = false;

  LocationData _currentLocation;
  PermissionStatus _permissionGranted;
  List<CustomMarker> _markersFiltered = [];

  bool firstRun = true;
  bool _switchArticle = false;
  LatLng centerMap = LatLng(48.85952489020911, 2.3406119299690786);
  double _position =
      (window.physicalSize.height / window.devicePixelRatio) -
          200 -
          kBottomNavigationBarHeight;

  bool _serviceEnabled;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final MapController mapController = MapController();

  double zoomMap = 13.5;
  bool isInit = false;
  CustomMarker last_art_geoloc;
  CustomMarker last_art_freq;
  List<CustomMarker> art_geoloc = [];
  List<CustomMarker> art_freq = [];
  List<CustomMarker> list;
  List<Article> list_article = [];
  List<Tag> liste_tags = [];
  List<Article> list_articles_pink = [];

  final cron = Cron();
  Size windowSize = MediaQueryData.fromWindow(window).size;
  UserCustom user;

  AudioPlayer audioPlayer = new AudioPlayer();
  bool audioState = false;
  bool lance = false;
  String _snapshot;
  Article _article;
  Article _articleWithAudio;
  Duration savedMaxDuration = new Duration();
  Duration savedPosition = new Duration();
  bool firstLaunchOfArticle = false;
  CustomMarker markerForBottomBar;
  Map notifCreated = new Map();
  bool test = false;
  Timer _timer1, _timer2;

  Map<String, dynamic> dataUser = {};

  @override
  void initState() {
    super.initState();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow Notification'),
            content: Text('We want to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Dont allow',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((_) => Navigator.pop(context)),
                child: Text(
                  'Allow',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        );
      }

      AwesomeNotifications().actionStream.listen((recievedNotification) {
        if (recievedNotification.id > 2 && recievedNotification.id < 6) {
          setState(() {
            mapController.move(
                LatLng(last_art_freq.latitude, last_art_freq.longitude), 17);
          });
          Timer(const Duration(milliseconds: 700), (() {
            WidgetsBinding.instance.handlePointerEvent(PointerDownEvent(
              pointer: 0,
              position: Offset(windowSize.width / 2, windowSize.height / 2),
            ));
            WidgetsBinding.instance.handlePointerEvent(PointerUpEvent(
              pointer: 0,
              position: Offset(windowSize.width / 2, windowSize.height / 2),
            ));
          }));
        }
        if (recievedNotification.id <= 2 && recievedNotification.id >= 0) {
          setState(() {
            mapController.move(
                LatLng(last_art_geoloc.latitude, last_art_geoloc.longitude),
                17);
          });
          Timer(const Duration(milliseconds: 700), (() {
            WidgetsBinding.instance.handlePointerEvent(PointerDownEvent(
              pointer: 0,
              position: Offset(windowSize.width / 2, windowSize.height / 2),
            ));
            WidgetsBinding.instance.handlePointerEvent(PointerUpEvent(
              pointer: 0,
              position: Offset(windowSize.width / 2, windowSize.height / 2),
            ));
          }));
        }
      });
    });

    _getCurrentUserLocation();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      await Provider.of<ArticleProvider>(context, listen: false)
          .fetchAndSetArticle();
      Provider.of<MarkerProvider>(context, listen: false).fetchAndSetMarker();
      Provider.of<TagProvider>(context, listen: false).fetchAndSetTag();

      if (widget.login != null) {
        await FirebaseFirestore.instance
            .collection('utilisateur')
            .get()
            .then((QuerySnapshot querySnapshot) => querySnapshot.docs
            .forEach((QueryDocumentSnapshot element) async {
          if (element.id == widget.login.uid) {
            var x = element.get('favoris');
            List<String> listFav = [...x];
            user = UserCustom(
              id: element.id,
              nom: element.get('name'),
              prenom: element.get('prenom'),
              eMail: element.get('eMail'),
              phone: element.get('phone'),
              dateNaissance: element.get('dateNaissance'),
              passeword: element.get('password'),
              sexe: element.get('sexe'),
              favoris: listFav,
              isAdmin: element.get('isAdmin'),
              range: element.get('range'),
              freq: element.get('freq'),
            );
          }
        }))
            .catchError((onError) => throw onError);
      } else {
        user = widget.user;
      }

      if (widget.auth) {
        Provider.of<FavoriteProvider>(context, listen: false)
            .fetchAndSetFavoris();
      }
    });

    _timer1 = Timer.periodic(Duration(minutes: 5), (timer) {
      if (user != null) {
        if (user.range == false && _currentLocation != null) {
          isNearMarkers(list, list_article, liste_tags, 100);
        }
        if (user.range == true && _currentLocation != null) {
          isNearMarkers(list, list_article, liste_tags, 300);
        }
      }
    });
    _timer2 = Timer.periodic(Duration(seconds: 1), (timer) {
      if (user != null && list_articles_pink.length != 0 && !test) {
        Cron croon = new Cron();
        if (user.freq == 0) {
          croon.schedule(Schedule.parse('30 9 * * *'), () async {
            discoverMarker(list_articles_pink, list, liste_tags);
            croon.close();
          });
        }
        if (user.freq == 1) {
          croon.schedule(Schedule.parse('30 9 * * 1'), () async {
            discoverMarker(list_articles_pink, list, liste_tags);
            croon.close();
          });
        }
        if (user.freq == 2) {
          croon.schedule(Schedule.parse('30 9 1 * *'), () async {
            discoverMarker(list_articles_pink, list, liste_tags);
            croon.close();
          });
        }
        test = true;
      }
    });
  }

  @override
  void dispose() {
    _timer1.cancel();
    _timer2.cancel();
    super.dispose();
  }

  Future<void> _getCurrentUserLocation() async {
    Location location = Location();

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        location.enableBackgroundMode(enable: true);
        return;
      }
    }

    _currentLocation = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation != null) {
        setState(() {
          _currentLocation = currentLocation;
        });
      }
    });
  }

  void isNearMarkers(List<CustomMarker> liste, List<Article> article,
      List<Tag> tags, int rayon) {
    if (_currentLocation != null) {
      for (int i = 0; i < liste.length; i++) {
        double dist = calculateDist(
          _currentLocation.latitude,
          liste[i].latitude,
          _currentLocation.longitude,
          liste[i].longitude,
        );
        if (dist < rayon) {
          Article art;
          last_art_geoloc = liste[i];
          String str = "";
          for (int j = 0; j < article.length; j++) {
            if (liste[i].idArticle == article[j].id) {
              art = article[j];
              for (int k = 0; k < art.tags.length; k++) {
                for (int m = 0; m < tags.length; m++) {
                  if (art.tags[k] == tags[m].id && art.tags.length > 0) {
                    str = str + ', ' + tags[m].label;
                  }
                }
              }
              if (str.length > 3) {
                str = str.substring(2, str.length);
              }
            }
          }
          if (!notifCreated.containsKey(art.id)) {
            //createNotifs(art, str);
            notifCreated[art.id] = true;
          }
        }
      }
    }
  }

  void discoverMarker(
      List<Article> articlePink, List<CustomMarker> liste, List<Tag> tags) {
    var rng = math.Random();
    int random = rng.nextInt(articlePink.length);
    Article art;

    art = articlePink[random];
    for (int i = 0; i < liste.length; i++) {
      if (art.id == liste[i].idArticle) {
        last_art_freq = liste[i];
        break;
      }
    }

    String str = "";
    for (int k = 0; k < art.tags.length; k++) {
      for (int m = 0; m < tags.length; m++) {
        if (art.tags[k] == tags[m].id && art.tags.length > 0) {
          str = str + ', ' + tags[m].label;
        }
      }
    }
    if (str.length > 3) {
      str = str.substring(2, str.length);
    }
    //createNotifFreq(art, str);
  }

  double calculateDist(
      double lat1,
      double lat2,
      double long1,
      double long2,
      ) {
    int r = 6371;
    double dlat = (lat2 - lat1) * (math.pi / 180);
    double dlong = (long2 - long1) * (math.pi / 180);
    double a = math.sin(dlat / 2) * math.sin(dlat / 2) +
        math.cos(lat1 * (math.pi / 180)) *
            math.cos(lat2 * (math.pi / 180)) *
            math.sin(dlong / 2) *
            math.sin(dlong / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double dist = r * c * 1000;
    return dist;
  }

  void _setSwitchFalse() {
    _switchArticle = false;
  }

  void _showMap() {
    setState(() {
      _favorisVisible = false;
      _rechercheVisible = false;
    });
  }

  void play(url) async {
    setState(() {
      audioState = true;
    });
    if (!audioState) {
      await audioPlayer.resume();
    } else {
      await audioPlayer.play(url);
    }
  }

  Future<void> pausePlayer() async {
    setState(() {
      audioState = false;
    });
    if (!audioState) {
      await audioPlayer.pause();
    }
  }

  Future<void> stopPlayer() async {
    setState(() {
      audioState = false;
    });
    if (audioPlayer != null) {
      await audioPlayer.stop();
    }
  }

  void _articleCallback(article, audioPlayer, audioState, snapshot) {
    setState(() {
      this._article = article;
      this._articleWithAudio = article;
      this.audioPlayer = audioPlayer;
      this.audioState = audioState;
      this._snapshot = snapshot;
    });
  }

  void randomAudioCallback(
      Article newArticle, String newSnapshot, bool newState, bool newAudio) {
    this._article = newArticle;
    this._articleWithAudio = newArticle;
    this._snapshot = newSnapshot;
    this.audioState = newState;
  }

  void updateMarkerForPopUp(marker) {
    this.markerForBottomBar = marker;
  }

  void _isPopupOpen(lance) async {
    await Future.delayed(Duration(milliseconds: 1));
    setState(() {
      this.lance = lance;
    });
  }

  void updateDuration(maxDuration, position) {
    this.savedMaxDuration = maxDuration;
    this.savedPosition = position;
  }

  void setFirstLaunchOfArticle() {
    this.firstLaunchOfArticle = true;
  }

  @override
  Widget build(BuildContext context) {
    final markersData = Provider.of<MarkerProvider>(context);
    final favoriteData = Provider.of<FavoriteProvider>(context);
    final _height = MediaQuery.of(context).size.height;
    final articleData = Provider.of<ArticleProvider>(context);
    final tags = Provider.of<TagProvider>(context);

    list = markersData.getAllMarkers();
    list_article = articleData.getAllArticles();
    liste_tags = tags.tags;
    list_articles_pink = articleData.getAllArticlesWithText();

    List<String> listeUserFavori;
    if (widget.auth) {
      listeUserFavori = [...favoriteData.favoris];
    }

    void changeFavorite(String id) {
      CustomMarker _marker =
      markersData.markers.firstWhere((item) => item.id == id);
      if (_marker.isFavorite) {
        markersData.unfavorite(id);
        favoriteData.delete(_marker.id, _marker);
      } else {
        markersData.favorite(id);
        favoriteData.add(_marker);
        favoriteData.addFavoris(_marker.id);

        FirebaseFirestore.instance.collection('/utilisateur').doc(user.id).set({
          'name': user.nom,
          'prenom': user.prenom,
          'sexe': user.sexe,
          'phone': user.phone,
          'eMail': user.eMail,
          'dateNaissance': user.dateNaissance,
          'password': user.passeword,
          'favoris': favoriteData.favoris,
          'isAdmin': user.isAdmin,
          'range': user.range,
          'freq': user.freq,
        });
      }
    }

    if (widget.auth) {
      listeUserFavori.forEach((element) {
        CustomMarker _marker =
        markersData.markers.firstWhere((item) => item.id == element);
        _marker.isFavorite = true;
      });
    }

    if (_permissionGranted == PermissionStatus.granted &&
        _currentLocation != null &&
        firstRun == true) {
      setState(() {
        firstRun = false;
      });
    }

    if (_position == _height) {
      setState(() {
        _position = _height - 200 - kBottomNavigationBarHeight;
        _idArticle = null;
        markersData.resetAllMarker();
      });
    }

    void _slide(DragUpdateDetails details) {
      setState(() {
        _position += details.delta.dy * 1.5;
      });
    }

    void _setPosition(double pos) {
      _position = pos;
    }

    void openMarker(CustomMarker item) {
      setState(() {
        if (widget.auth) {
          _position = _height - 200 - kBottomNavigationBarHeight;
          markersData.resetMarker(item);
          item.isVisible = !item.isVisible;

          if (_idArticle != null) {
            if (markersData.markerOpen()) {
              _idArticle = item.idArticle;
              _switchArticle = true;
            } else {
              _idArticle = null;
            }
          } else {
            _idArticle = item.idArticle;
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      });
    }

    if (_idArticle == null) {
      setState(() {
        _switchArticle = false;
      });
    }

    final balises = Balise(
      context: context,
      markersFiltered: _markersFiltered,
      zoomMap: zoomMap,
      openMarker: openMarker,
    );

    void filterMap(List<Article> articles, bool afficher) {
      if (articles.isEmpty) {
        return;
      }
      setState(() {
        if (afficher) {
          _favorisVisible = false;
          _rechercheVisible = false;
        }
        _markersFiltered = markersData.markersFilter(articles);
      });
    }

    void _afficherArticle(CustomMarker marker) {
      setState(() {
        _favorisVisible = false;
        _rechercheVisible = false;
        _idArticle = marker.idArticle;
        _position = 1;
        marker.isVisible = true;
        mapController.moveAndRotate(
            LatLng(marker.latitude, marker.longitude), 17, 0);
      });
    }

    void _centerMarker(CustomMarker marker) {
      setState(() {
        _favorisVisible = false;
        _rechercheVisible = false;
        mapController.moveAndRotate(
            LatLng(marker.latitude, marker.longitude), 17, 0);
      });
    }

    void openAudio() {
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
          return GestureDetector(
            onTap: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Dismissible(
              movementDuration: Duration(seconds: 1),
              key: Key("key"),
              direction: DismissDirection.vertical,
              onDismissed: (value) {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Audio(
                article: _articleWithAudio,
                audioPlayer: audioPlayer,
                snapshot: _snapshot,
                audioState: audioState,
                lance: lance,
                play: play,
                pausePlayer: pausePlayer,
                stopPlayer: stopPlayer,
                isPopupOpen: _isPopupOpen,
                cameFromArticeItem: false,
                updateDuration: updateDuration,
                savedMaxDuration: savedMaxDuration,
                savedPosition: savedPosition,
                afficherArticle: _afficherArticle,
                marker: markerForBottomBar,
                articleCallback: _articleCallback,
                updateMarkerForPopUp: updateMarkerForPopUp,
                markersData: markersData,
                articlesData: articleData,
                randomAudioCallback: randomAudioCallback,
              ),
            ),
          );
        }),
      ).then((_) => _isPopupOpen(!lance));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      drawer: DrawerCustom(
        auth: widget.auth,
        user: user,
      ),
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          icon: Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Text("Mon application"),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            /// --- AFFICHAGE DE LA FLUTTER MAP ---
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                onTap: (tapPosition, point) {
                  setState(() {
                    _position = _height;
                  });
                },
                onPositionChanged: (mapPos, hasGesture) {
                  if (hasGesture) {
                    setState(() {
                      zoomMap = mapPos.zoom;
                    });
                  }
                },
                center: centerMap,
                zoom: 12.0,
                maxZoom: 19.0,
                minZoom: 4.2,
              ),
              children: [
                TileLayer(
                  maxZoom: 19.0,
                  maxNativeZoom: 19.0,
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                ),

                // ICI ON UTILISE UN MARKER CLUSTER LAYER
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    maxClusterRadius: 45,
                    disableClusteringAtZoom: 16,
                    size: Size(40, 40),
                    anchor: AnchorPos.align(AnchorAlign.center),
                    markers: balises.buildAllMarker(dataUser),
                    builder: (context, clusteredMarkers) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.asset(
                            'assets/images/marker/marqueurVioletFoncé.png',
                            width: 50,
                          ),
                          Positioned(
                            top: 8,
                            left: 0,
                            right: 0,
                            child: Text(
                              '${clusteredMarkers.length}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    spiderfyCircleRadius: 100,
                    spiderfySpiralDistanceMultiplier: 2,
                    showPolygon: true, // pour relier chaque marker
                  ),
                ),

                // On affiche le marker de la position de l’utilisateur séparément
                if (_currentLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 35.0,
                        height: 35.0,
                        point: LatLng(
                            _currentLocation.latitude, _currentLocation.longitude),
                        builder: (ctx) => Image(
                          image: AssetImage('assets/images/utilisateur.png'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            /// --- BOUTON D'OUVERTURE DU DRAWER ---
            Positioned(
              left: 15,
              top: 5,
              child: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 40,
                ),
                onPressed: () => scaffoldKey.currentState.openDrawer(),
              ),
            ),

            /// --- ANIMATED BOTTOM BUTTON ---
            AnimatedButtom2(
              auth: widget.auth,
              user: widget.user,
              login: widget.login,
            ),

            /// --- BOUTON FAKE "FAVORI" (bouton + parcours, etc.) ---
            Positioned(
              right: 15,
              top: 15,
              child: GestureDetector(
                onTap: () {
                  return showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '   Tous les parcours',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'myriad',
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        '+ Parcours',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 33, 44, 243),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  child: Stack(
                    children: [
                      Positioned(
                        right: -6.5,
                        child: Icon(
                          Icons.add,
                          size: 22,
                          color: Color.fromRGBO(206, 63, 143, 1),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(206, 63, 143, 1),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            /// --- BOUTON ABCD AIRE (déclenche la recherche) ---
            Positioned(
              right: 63,
              top: 15,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _idArticle = null;
                    _favorisVisible = false;
                    _rechercheVisible = !_rechercheVisible;
                  });
                },
                child: Container(
                  height: 40,
                  child: IconButton(
                    icon: Image.asset(
                      'assets/images/icones/ICON_LIVRE.png',
                      color: Color.fromRGBO(206, 63, 143, 1),
                    ),
                  ),
                ),
              ),
            ),

            /// --- BOUTON CENTRER NORD ---
            BoutonNord(
              setRotationImage: setRotationImage,
              mapController: mapController,
            ),

            /// --- FENETRE ARTICLE ---
            if (_idArticle != null)
              Consumer<ArticleProvider>(
                builder: (_, articlesData, child) {
                  _article = articlesData.markerToArticle(_idArticle);
                  if (_article.audio.isNotEmpty && _articleWithAudio == null) {
                    _articleWithAudio = _article;
                  }
                  var trade =
                      Provider.of<TraductionController>(context, listen: false)
                          .trade
                          .value ??
                          false;

                  return FutureBuilder<Object>(
                    future: _article.audio.isEmpty
                        ? null
                        : (!trade)
                        ? firebase_storage.FirebaseStorage.instance
                        .ref()
                        .child(_article.audio)
                        .getDownloadURL()
                        : (_article.audioEN.isNotEmpty)
                        ? firebase_storage.FirebaseStorage.instance
                        .ref()
                        .child(_article.audioEN)
                        .getDownloadURL()
                        : null,
                    builder: (context, snapshot) {
                      if (_article.audio.isNotEmpty && _snapshot == null) {
                        _snapshot = snapshot.data;
                      }

                      return FenetreArticleCom(
                        user: user,
                        auth: widget.auth,
                        position: _position,
                        slide: _slide,
                        article: _article,
                        changeFavorite: changeFavorite,
                        idMaker: markersData.markers
                            .firstWhere(
                                (data) => data.idArticle == _idArticle)
                            .id,
                        like: markersData.markers
                            .firstWhere(
                                (data) => data.idArticle == _idArticle)
                            .isFavorite,
                        setPosition: _setPosition,
                        switchArticle: _switchArticle,
                        switchFalse: _setSwitchFalse,
                        articleCallback: _articleCallback,
                        snapshot: snapshot.data,
                        lance: lance,
                        audioPlayer: audioPlayer,
                        audioState: audioState,
                        secondArticle: _articleWithAudio,
                        isPopUpOpen: _isPopupOpen,
                        updateDuration: updateDuration,
                        savedMaxDuration: savedMaxDuration,
                        savedPosition: savedPosition,
                        firstLaunchOfArticle: firstLaunchOfArticle,
                        setFirstLaunchOfArticle: setFirstLaunchOfArticle,
                        afficherArticle: _afficherArticle,
                        marker: markersData.markers.firstWhere(
                              (data) => data.idArticle == _idArticle,
                        ),
                        updateMarkerForPopUp: updateMarkerForPopUp,
                        play: play,
                        pausePlayer: pausePlayer,
                        stopPlayer: stopPlayer,
                        markersData: markersData,
                        articlesData: articleData,
                      );
                    },
                  );
                },
              ),

            /// --- LISTE DES FAVORIS ---
            if (_favorisVisible)
              ListFavoris(
                afficherArticle: _afficherArticle,
                showMap: _showMap,
                centerMarker: _centerMarker,
              ),

            /// --- FENETRE DE RECHERCHE ---
            if (_rechercheVisible)
              Recherche(
                showMap: _showMap,
                filterMap: filterMap,
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ((lance && _article.audio.isNotEmpty) ||
          (lance && _article.audio.isEmpty))
          ? SwipeDetector(
        swipeConfiguration: SwipeConfiguration(
          verticalSwipeMinVelocity: 1.0,
          verticalSwipeMinDisplacement: 1.0,
        ),
        onSwipeUp: () => openAudio(),
        child: AudioBottomBar(
          article: _articleWithAudio,
          audioPlayer: audioPlayer,
          snapshot: _snapshot,
          audioState: audioState,
          lance: lance,
          play: play,
          pausePlayer: pausePlayer,
          stopPlayer: stopPlayer,
          isPopupOpen: _isPopupOpen,
          articleCallback: _articleCallback,
          savedMaxDuration: savedMaxDuration,
          savedPosition: savedPosition,
          updateDuration: updateDuration,
          afficherArticle: _afficherArticle,
          marker: markerForBottomBar,
          updateMarkerForPopUp: updateMarkerForPopUp,
          markersData: markersData,
          articlesData: articleData,
        ),
      )
          : Container(),
    );
  }

  setRotationImage(double degrees) {
    final angle = degrees * math.pi / 180;
    return angle;
  }
}
