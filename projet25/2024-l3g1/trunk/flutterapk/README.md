Installation de Flutter, Dart, Java, Firebase et Android Studio

1. Téléchargement et Installation de Flutter, Dart et Java:

- Rendez-vous sur le site officiel de Flutter pour télécharger la version 3.7.8 du SDK Flutter selon votre système d'exploitation.
- Une fois Flutter installé, exécutez la commande `flutter doctor -v` dans votre terminal pour vérifier l'installation et suivre les éventuelles étapes supplémentaires.
- Dart est inclus dans le SDK Flutter, donc aucune installation supplémentaire n'est nécessaire( la version installer devrais être 2.19.5)
- Pour installer Java JDK 11.0.21, rendez-vous sur le site officiel d'Oracle et suivez les instructions pour votre système d'exploitation.
- Assurez vous de définir la variable d'environnement JAVA_HOME pour pointer vers le répertoire d'installation de Java.
Pour java et flutter ne pas oublier de les ajouter au PATH dans les variables systeme 

2. Installation de Firebase:

- Visitez le site officiel de Firebase CLI et téléchargez l'outil selon votre système d'exploitation.
- Liez votre compte Gmail au projet Firebase ( a demander au client)
- Ouvrez votre terminal et exécutez `firebase login` pour vous connecter à votre compte.

3. Installation d'Android Studio:

- Téléchargez Android Studio depuis le site officiel et suivez les instructions d'installation.
- Assurez vous d'installer les SDK Android nécessaires via le SDK Manager d'Android Studio, en incluant les versions spécifiées dans le fichier `flutter doctor -v`.

Assurez vous de suivre attentivement les instructions spécifiques à votre système d'exploitation pour chaque étape.


4. Installation d'Android Studio:

Sur Visual Studio Code, ouvrez le projet Flutter fourni par le client. Installez les extensions Flutter et Dart pour faciliter le développement. Pour lancer l'application sur l'émulateur Android Studio, suivez ces étapes :

- Accédez au dossier du projet (généralement le dossier "flutterapk").
- Ouvrez un terminal dans ce dossier.
- Exécutez la commande `flutter run` pour démarrer l'application sur l'émulateur Android. Ou bien, dans le fichier principal de l'application (main.dart), cliquez sur "Run" (ou l'icône associée) situé généralement au-dessus de la méthode "main".