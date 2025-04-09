import 'package:flutter/cupertino.dart';

class Article {
  /// Identifiant de l'article
  final String id;

  /// Titre de l'article
  final String title;

  /// Description de l'article
  /// Titre de l'article en anglais
  final String titleEN;

  /// URL de l'image de l'article
  final String photo;
  final String text;

  /// Date de l'oeuvre
  final String date;

  /// Nom des architectes de l'oeuvre
  final String architecte;
  // Architecte associé
  final String associe;
  // Architecte transformation
  final String transformation;
  // Architecte des Monuments Historiques
  final String monument;
  // Architecte de projet
  final String projet;
  // Architecte local
  final String local;
  // Chef de projet
  final String chef;
  // Ingenieur
  final String ingenieur;
  // Paysagiste
  final String paysagiste;
  // Urbaniste
  final String urbaniste;
  // Artiste
  final String artiste;
  // Eclairagiste
  final String eclairagiste;
  // Conservateur du musée
  final String musee;
  // Année d'installation à Paris
  final String installation;
  // Dimensions
  final String dimensions;
  // Expositions
  final String expositions;
  // Surface
  final String surface;
  // Surface à construire
  final String construire;
  // Surface d'exposition
  final String surfaceExpo;

  /// Nom des architectes des opérations connexes  de l'oeuvre
  final String operation;

  /// Nom de l'architecte du patrimoine de l'oeuvre
  final String patrimoine;

  /// Adresse
  final String lieu;

  /// Liste de mots-clefs correspondant
  final List<String> tags;

  /// Description de l'article en anglais
  final String textEn;

  /// Description de l'article sous format audio
  final String audio;

  /// Description de l'article sous format image
  final String image;

  /// Description de l'article en anglais sous format audio
  final String audioEN;

  final String imageUrl;

  /// Permet de savoir si l'article est ouvert
  bool isOpen;

  Article(
      {@required this.id,
      @required this.title,
      this.titleEN = '',
      this.photo = '',
      this.architecte = '',
      this.operation = '',
      this.patrimoine = '',
      this.lieu = '',
      this.date = '',
      this.textEn = '',
      this.text = '',
      this.image = '',
      this.audio = '',
      this.audioEN = '',
      this.artiste = '',
      this.associe = '',
      this.chef = '',
      this.construire = '',
      this.dimensions = '',
      this.eclairagiste = '',
      this.expositions = '',
      this.ingenieur = '',
      this.installation = '',
      this.local = '',
      this.monument = '',
      this.musee = '',
      this.paysagiste = '',
      this.projet = '',
      this.surface = '',
      this.surfaceExpo = '',
      this.transformation = '',
      this.urbaniste = '',
      this.imageUrl = '',
      this.isOpen = false,
      this.tags});

  // Méthode pour convertir les données Firestore en un objet Article
  factory Article.fromJson(Map<String, dynamic> json, String documentId) {
    return Article(
      id: documentId,
      title: json['title'] ?? '',
      titleEN: json['titleEN'] ?? '',
      photo: json['photo'] ?? '',
      text: json['text'] ?? '',
      date: json['date'] ?? '',
      architecte: json['architecte'] ?? '',
      associe: json['associe'] ?? '',
      transformation: json['transformation'] ?? '',
      monument: json['monument'] ?? '',
      projet: json['projet'] ?? '',
      local: json['local'] ?? '',
      chef: json['chef'] ?? '',
      ingenieur: json['ingenieur'] ?? '',
      paysagiste: json['paysagiste'] ?? '',
      urbaniste: json['urbaniste'] ?? '',
      artiste: json['artiste'] ?? '',
      eclairagiste: json['eclairagiste'] ?? '',
      musee: json['musee'] ?? '',
      installation: json['installation'] ?? '',
      dimensions: json['dimensions'] ?? '',
      expositions: json['expositions'] ?? '',
      surface: json['surface'] ?? '',
      construire: json['construire'] ?? '',
      surfaceExpo: json['surfaceExpo'] ?? '',
      operation: json['operation'] ?? '',
      patrimoine: json['patrimoine'] ?? '',
      lieu: json['lieu'] ?? '',
      textEn: json['textEn'] ?? '',
      audio: json['audio'] ?? '',
      image: json['image'] ?? '',
      audioEN: json['audioEN'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'photo': this.photo,
        'titleEN': this.titleEN,
        'title': this.title,
        'architecte': this.architecte,
        'operation': this.operation,
        'patrimoine': this.patrimoine,
        'lieu': this.lieu,
        'date': this.date,
        'textEn': this.textEn,
        'text': this.text,
        'image': this.image,
        'audio': this.audio,
        'audioEN': this.audioEN,
        'tags': this.tags,
        'associe': this.associe,
        'transformation': this.transformation,
        'monument': this.monument,
        'projet': this.projet,
        'local': this.local,
        'chef': this.chef,
        'ingenieur': this.ingenieur,
        'paysagiste': this.paysagiste,
        'urbaniste': this.urbaniste,
        'artiste': this.artiste,
        'eclairagiste': this.eclairagiste,
        'musee': this.musee,
        'installation': this.installation,
        'dimensions': this.dimensions,
        'expositions': this.expositions,
        'surface': this.surface,
        'construire': this.construire,
        'surfaceExpo': this.surfaceExpo,
        'imageUrl': this.imageUrl,
      };
}
