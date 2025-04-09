class CustomMarker {
  /// Identifiant du marqueur
  final String id;

  /// Latitude du marqueur
  final double latitude;

  /// Longitude du marqueur
  final double longitude;

  /// Identifiant de l'article lié au marqueur
  final String idArticle;

  /// Etat du marqueur si selectionné ou non
  bool isVisible;

  /// Etat du marqueur si a une photo ou non
  bool hasPhoto;

  String couleur;

  /// Etat du marqueur s'il est liké ou non
  bool isFavorite;

  CustomMarker(
      {this.id,
        this.latitude,
        this.longitude,
        this.idArticle,
        this.couleur = "#FF5400",
        this.isVisible = false,
        this.hasPhoto = false,
        this.isFavorite = false});
  void setCouleur(String newColor) {
    //Verifie que la couleur est bien un code hexadécimal et la mets en majuscule avec un #
    if ('Color(' == newColor.substring(0, 6)) {
      newColor = newColor.split('(0x')[1].split(')')[0];
    }
    if (newColor.length == 6) {
      newColor = "#" + newColor;
    }
    if (newColor.length == 10) {
      newColor = "#" + newColor.substring(3);
    }
    //si la couleur commence par Color( alors

    print('newColor : ' + newColor);
    this.couleur = newColor;
  }

  Map<String, dynamic> toJson() => {
    'idArticle': this.idArticle,
    'latitude': this.latitude,
    'longitude': this.longitude,
    'couleur': this.couleur,
  };
}
