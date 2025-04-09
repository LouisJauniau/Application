import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/article.dart';

class AudioProvider extends ChangeNotifier {
  bool isPlaying = false;
  bool isPause = false;
  bool NotPause=true;
  Article currentArticle;
  String snapshot;
  AudioPlayer audioPlayer = AudioPlayer();
  Duration savedMaxDuration = Duration.zero;
  Duration savedPosition = Duration.zero;
  bool isPopupOpen = false;  // Ajout de l'état du popup
  List<Map<String, dynamic>> markersData = [];
  List<Article> articlesData = [];
  Map<String, dynamic> currentMarker = {};

  // Fonction pour jouer de l'audio
/*   void playAudio(Article article, AudioPlayer audioPlayer, bool isPlaying, String snapshot) async {
    currentArticle = article;
    this.snapshot = snapshot;
    Source fileSource = DeviceFileSource(snapshot); // Pour un fichier local

    await audioPlayer.play(fileSource); // Joue l'audio avec le fichier source

    this.isPlaying = true;
    notifyListeners();
  } */
  // Fonction pour jouer de l'audio
  Future<void> playAudio() async {
    Source fileSource = DeviceFileSource(snapshot); // Pour un fichier local
    await audioPlayer.play(fileSource);
    isPlaying=true;
    isPause=false;

    isPopupOpen=true;// Joue l'audio avec le fichier source
    notifyListeners();
  }

  Future <void> pauseAudio() async {
    await audioPlayer.pause(); // Met l'audio en pause
    isPause = true;
    // L'audio n'est plus en lecture, donc l'état devient "false"


    notifyListeners(); // Notifie les listeners pour mettre à jour l'interface utilisateur
  }


  Future<void> stopAudio() async {
    Source fileSource = DeviceFileSource(snapshot);
    await audioPlayer.stop();

    isPlaying = false;
    currentArticle = null;
    snapshot = null;
    notifyListeners();
  }

  void updateDurations(Duration max, Duration position) {
    savedMaxDuration = max;
    savedPosition = position;
    notifyListeners();
  }

  // Fonction pour jouer l'audio à partir de la position actuelle
  void playFromPosition() async {
    await audioPlayer.seek(savedPosition); // Reprendre depuis la position précédente
    await audioPlayer.resume(); // Reprendre la lecture
    isPlaying = true;
    notifyListeners();
  }

  // Fonction pour activer/désactiver le popup
  void setPopupState(bool state) {
    isPopupOpen = state;
    notifyListeners();
  }

  // Mettre à jour l'article au niveau du bottom bar
  void updateArticleCallback(Article article) {
    currentArticle = article;
    notifyListeners();
  }

  // Mettre à jour le marqueur pour le popup
  void updateMarkerForPopUp(Map<String, dynamic> marker) {
    currentMarker = marker;
    notifyListeners();
  }

  // Ajouter des marqueurs aux données
  void setMarkersData(List<Map<String, dynamic>> markers) {
    markersData = markers;
    notifyListeners();
  }

  // Ajouter des articles aux données
  void setArticlesData(List<Article> articles) {
    articlesData = articles;
    notifyListeners();
  }

  // Fonction pour afficher ou masquer l'article
  void afficherArticle(bool show) {
    // C'est une fonction à définir si elle n'est pas encore dans ton projet,
    // tu pourrais par exemple décider de filtrer les articles affichés
    notifyListeners();
  }

  Future<void> setSnapshotAndPlay(String snapshot, Article article) async {
    this.snapshot = snapshot;
    this.currentArticle = article;
    isPlaying = true;
    await playAudio();
    notifyListeners();
  }

  // Obtenir l'état actuel de la lecture audio
  bool get isAudioPlaying => isPlaying;

  // Fonction pour gérer l'état du joueur audio (en cours, en pause, etc.)
  AudioPlayer get getAudioPlayer => audioPlayer;

  // Récupérer les données de l'article actuel
  Article get getCurrentArticle => currentArticle;

  // Récupérer l'état du popup
  bool get getPopupState => isPopupOpen;

  // Récupérer la durée maximale
  Duration get getSavedMaxDuration => savedMaxDuration;

  // Récupérer la position sauvegardée
  Duration get getSavedPosition => savedPosition;

  // Récupérer le marqueur actuel
  Map<String, dynamic> get getCurrentMarker => currentMarker;

  // Récupérer les marqueurs
  List<Map<String, dynamic>> get getMarkersData => markersData;

  // Récupérer les articles
  List<Article> get getArticlesData => articlesData;
}
