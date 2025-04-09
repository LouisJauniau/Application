import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

// Fichier généré par "flutterfire configure" avec tes clés
import 'firebase_options.dart';

// Imports de ton projet
import 'providers/TraductionController.dart';
import 'providers/persistence/local_storage_settings_persistence.dart';
import 'providers/persistence/traduction_persistence.dart';
import 'providers/articleProvider.dart';
import 'providers/commentProvider.dart';
import 'providers/favoriteProvider.dart';
import 'providers/markerProvider.dart';
import 'providers/tagProvider.dart';
import 'providers/UserProvider.dart';

// Screens
import 'screens/authentificationScreen/LoginScreen.dart';
import 'screens/authentificationScreen/SignConfirmScreen.dart';
import 'screens/authentificationScreen/SignScreen.dart';
import 'screens/carteScreen.dart';
import 'screens/drawerScreens/aProposScreen.dart';
import 'screens/drawerScreens/conditionScreen.dart';
import 'screens/drawerScreens/contacterScreen.dart';
import 'screens/drawerScreens/politiqueScreen.dart';
import 'screens/homeScreen.dart';

import 'package:provider/provider.dart';

import 'package:flutter_web_plugins/url_strategy.dart';

// Handler pour FCM messages en background (Android/iOS)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Sur le web, il n'est généralement pas déclenché,
  // mais on remet l'init si besoin pour iOS/Android :
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  usePathUrlStrategy();
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // --- Notifications locales (désactivées sur le Web) ---
    if (!kIsWeb) {
      AwesomeNotifications().initialize(
        null, // Icône par défaut pour Android (facultatif si tu en as une)
        [
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'basic_channel',
            defaultColor: Color.fromRGBO(209, 62, 150, 1),
            importance: NotificationImportance.High,
            channelShowBadge: true,
            channelDescription: 'Notifications basiques',
            onlyAlertOnce: true,
          )
        ],
      );

      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      });
    }

    // --- Firebase initialisation ---
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Config background FCM (Android/iOS)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // --- Crashlytics (uniquement mobile/desktop) ---
    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }

    runApp(MyApp(
      traductionPersistence: LocalStorageTraductionPersistence(),
    ));
  }, (error, stack) {
    // capture des erreurs globales
    if (!kIsWeb) {
      // Crashlytics
      FirebaseCrashlytics.instance.recordError(error, stack);
    } else {
      // Sur web, on log dans la console
      print('Unhandled Error on Web: $error\nStack: $stack');
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({
    @required this.traductionPersistence,
  });

  final TraductionPersistence traductionPersistence;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // Forcer l'orientation en portrait
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: [
        Provider<TraductionController>(
          lazy: false,
          create: (context) => TraductionController(
            persistence: widget.traductionPersistence,
          )..loadStateFromPersistence(),
        ),
        ChangeNotifierProvider(create: (ctx) => MarkerProvider()),
        ChangeNotifierProvider(create: (ctx) => ArticleProvider()),
        ChangeNotifierProvider(create: (ctx) => TagProvider()),
        ChangeNotifierProvider(create: (ctx) => FavoriteProvider()),
        ChangeNotifierProvider(create: (ctx) => CommentaireProvider()),
        ChangeNotifierProvider(create: (ctx) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AURA',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'myriad',
        ),
        // Détermine la page d'accueil en fonction de l'auth
        home: StreamBuilder<User>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
              // Sur mobile/desktop, on log l'utilisateur sur Crashlytics
              if (!kIsWeb) {
                FirebaseCrashlytics.instance.log(snapshot.data.toString());
              }
              // S'il est vérifié, on l'envoie sur la Carte
              if (snapshot.data.emailVerified) {
                return CarteScreen(
                  auth: true,
                  login: snapshot.data,
                );
              }
            }
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            // Sinon, HomeScreen
            return HomeScreen();
          },
        ),
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          SignConfirmScreen.routeName: (ctx) => SignConfirmScreen(),
          SignScreen.routeName: (ctx) => SignScreen(),
          ConditionScreen.routeName: (ctx) => ConditionScreen(),
          ContacterScreen.routeName: (ctx) => ContacterScreen(),
          AProposScreen.routeName: (ctx) => AProposScreen(),
          PolitiqueScreen.routeName: (ctx) => PolitiqueScreen(),
        },
      ),
    );
  }
}
