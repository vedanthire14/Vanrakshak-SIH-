import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vanrakshak/resources/authentication/loginAuthentication.dart';
import 'package:vanrakshak/resources/authentication/signupAuthentication.dart';
import 'package:vanrakshak/resources/mainScreenSetup/mainscreendata.dart';
import 'package:vanrakshak/screens/introSlider/introSlider.dart';
import 'package:vanrakshak/screens/mainScreens/mainScreen.dart';
import 'package:vanrakshak/screens/projectScreens/shyARA.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SignupAuthorization(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginAuthorization(),
        ),
        ChangeNotifierProvider(
          create: (context) => MainScreenSetup(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FeatureDiscovery(
          recordStepsInSharedPreferences: false,
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, userSnp) {
              if (userSnp.hasData) {
                return const ShyARA();
              }
              return MyLiquidSwipe();
            },
          ),
        ),
      ),
    );
  }
}
