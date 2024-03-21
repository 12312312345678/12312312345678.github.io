import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/erli_pages/erli_homepage.dart';
import 'package:religous_lifetype_inventory/firebase_options.dart';
import 'package:religous_lifetype_inventory/lobby/lobby.dart';
import 'package:religous_lifetype_inventory/pit_pages/pit_homepage.dart';
import 'package:religous_lifetype_inventory/rli_pages/rli_pages.dart';

import 'counts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => Answers(),
      ),
      ChangeNotifierProvider(
        create: (_) => Answers2(),
      ),
      ChangeNotifierProvider(create: (_) => PreferencesRLITestApp()),
      ChangeNotifierProvider(create: (_) => PITAnswers()),
      ChangeNotifierProvider(create: (_) => TimeStaff())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RLI test program',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/rli': (context) => const RLIHomePageScreen(
              storage: "rli3", //대조군
            ),
        '/pit': (context) => const PITHome(storage: "pit1"),
        '/erli': (context) => const ERLIHome(
              storage: "erli1",
            ),
        '/lobby': (context) => const MainTestPage(),
        '/???': (context) => const RLIHomePageScreen(
              storage: "rliAlpha", //실험군 1
            ),
        '/???': (context) => const RLIHomePageScreen(
              storage: "rliBeta", //실험군 2
            ),
        '/???': (context) => const RLIHomePageScreen(
              storage: "rliGamma", //실험군 2
            ),
        '/???': (context) => const PITHome(storage: "pitAlpha" //실험군 1
            ),
        '/???': (context) => const PITHome(storage: "pitBeta" //실험군 2
            ),
      },
      home: const MainTestPage(),
      /*home: const ResultsPage(),*/
    );
  }
}
