import 'package:flutter/material.dart';

import '../models/article.dart';

final kHintTextStyle = TextStyle(
  color: Color(0xFF9B9A9A),
  fontFamily: 'Myriade',
);

final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'Myriade',
);

final kBoxDecoStyle = BoxDecoration(
  color: Color(0xFFECEBEB),
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.grey,
      blurRadius: 6.0,
      offset: Offset(5, 5),
    ),
  ],
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20.0),
  boxShadow: [
    BoxShadow(
      color: Color.fromRGBO(209, 62, 150, 1),
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

String assetFromTitle(Article article) {
  // Si une URL est renseignée, on la retourne directement.
  if (article.imageUrl != null && article.imageUrl.isNotEmpty) {
    return article.imageUrl;
  }
  var assetImage = "";
  if (article.title == "Manufacture sur Seine - Quartier Terre")
    assetImage =
        "assets/Manufacture sur Seine Quartier Terre/reinventer-seine-manufacture-seine-amateur.jpg";
  if (article.title == "Centre ville de Montreuil Sous Bois")
    assetImage =
        "assets/Centre Ville de Montreuil sous Bois Alvaro Siza/Croquis Siza Centre Ville Montreuil.jpg";
  if (article.title == "La Grande Arche")
    assetImage = "assets/La Grande Arche/IMG_3992.jpeg";
  if (article.title == "Fondation Louis Vuitton")
    assetImage = "assets/Fondation Louis Vuitton/IMG_1330.jpeg";
  if (article.title == "100 logements sociaux")
    assetImage = "assets/IMG_4027.jpeg";
  if (article.title == "Stade Jean Bouin") assetImage = "assets/IMG_2083.jpeg";
  if (article.title == "La Tour Triangle")
    assetImage = "assets/La Tour Triangle/La Tour Triangle.jpg";
  if (article.title == "Hôpital Cognacq-Jay")
    assetImage = "assets/Hôpital Cognacq-Jay - Toyo Ito/IMG_9574.jpeg";
  if (article.title == "Musée du quai Branly")
    assetImage = "assets/Musée Quai Branly/IMG_3690.jpeg";
  if (article.title == "Espace de méditation UNESCO")
    assetImage =
        "assets/Espace de Méditation UNESCO - Tadao Ando/IMG_3819.jpeg";
  if (article.title == "Showroom Citroën")
    assetImage = "assets/Showroom Citroën/IMG_3651.jpeg";
  if (article.title == "57 logements Rue Des Suisses")
    assetImage = "assets/57 logements - Herzog et Demeuron/IMG_2681.jpeg";
  if (article.title == "Fondation Cartier pour l'art contemporain")
    assetImage = "assets/Fondation Cartier/IMG_2195.jpeg";
  if (article.title == "Galerie marchande Gaîté Montparnasse")
    assetImage =
        "assets/Galerie Marchande Gaîté Montparnasse/03_Gaîté_Montparnasse_MVRDV_©Ossip van Duivenbode.jpg";
  if (article.title == "Le département des Arts de l'Islam du Louvre")
    assetImage =
        "assets/Département des Arts de l_Islam du Louvre/PARIS_Departement-des-Arts-de-l-Islam-du-musee-du-Louvre_02b.jpg";
  if (article.title == "La Pyramide du Louvre")
    assetImage = "assets/La Pyramide du Louvre/IMG_3222.jpeg";
  if (article.title == "La Nouvelle Samaritaine")
    assetImage = "assets/La Nouvelle Saint Maritaine - SANAA/IMG_3967.jpeg";
  if (article.title == "La Fondation Pinault")
    assetImage = "assets/téléchargement.jpg";
  if (article.title == "La Canopée")
    assetImage = "assets/La Canopée/IMG_3297.jpeg";
  if (article.title == "Lafayette Anticipation")
    assetImage = "assets/IMG_3353.jpeg";
  if (article.title == "Pavillon Mobile Art Chanel")
    assetImage =
        "assets/Pavillon Mobile Art Chanel/chanel_mobile_art_pavilion-zaha_hadid_2_photo AA13.jpg";
  if (article.title == "La Fondation Jérôme Seydoux-Pathé")
    assetImage = "assets/téléchargement (1).jpg";
  if (article.title == "Pushed Slab")
    assetImage = "assets/Pushed Slab/IMG_5889.jpeg";
  if (article.title == "M6B2 Tour de la Biodiversité")
    assetImage = "assets/IMG_7619.jpeg";
  if (article.title ==
      "La Bibliothèque Nationale de France (François Mitterand)")
    assetImage = "assets/Bibliothèque François Mitterand/IMG_6855.jpeg";
  if (article.title == "Cité de la mode et du design")
    assetImage = "assets/Cité de la mode/IMG_7176.jpeg";
  if (article.title == "La Cinémathèque Française")
    assetImage = "assets/La Cinémathèque Française/IMG_8448.jpeg";
  if (article.title == "Eden bio") assetImage = "assets/Eden Bio/IMG_4174.jpeg";
  if (article.title == "La Philharmonie")
    assetImage = "assets/La Philharmonie/IMG_4684.jpeg";
  if (article.title == "Le Parc de la Villette")
    assetImage = "assets/Cité de la mode/Le Parc Lavillette/IMG_4727.jpeg";
  if (article.title == "220 logements Rue de Meaux")
    assetImage = "assets/220 Logements rue de Meaux/IMG_2681.jpeg";
  if (article.title == "Siège du Parti Communiste Français")
    assetImage = "assets/Siège Parti Communiste/IMG_4383.jpeg";
  if (article.architecte == "ANNE LACATON et JEAN PHILLIPE VASSAL (France)" &&
      article.date == "2009")
    assetImage = "assets/La Tour Bois Le Prêtre - Lacaton Vassal/IMG_0689.jpeg";
  if (article.architecte == "Aires Mateus (Portugal) et AAVP (France)" &&
      article.date == "2018") assetImage = "assets/Emergence/IMG_0324.jpeg";
  if (article.title == "Tower Flower")
    assetImage = "assets/Tower Flower/IMG_0269.jpeg";
  if (article.title == "Beaubourg")
    assetImage = "assets/Beaubourg/IMG_3334.jpeg";
  if (article.title == "Institut du Monde Arabe")
    assetImage = "assets/Institut Monde Arabe/IMG_8831.jpeg";
  if (article.title == "Le Tribunal de Paris")
    assetImage = "assets/Cité de la mode/Le Tribunal de Paris/IMG_0321.jpeg";
  if (article.title == "Villa Dall'Ava")
    assetImage = "assets/Villa d_all_Ava - Oma/IMG_3076.jpeg";
  if (article.image.isEmpty) assetImage = 'assets/images/AURA_VISUEL02.jpg';
  return assetImage;
}
