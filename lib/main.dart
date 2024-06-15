import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/edt_pages/edt_homepage.dart';
import 'package:religous_lifetype_inventory/firebase_options.dart';
import 'package:religous_lifetype_inventory/lobby/lobby2.dart';
import 'package:rli_discovery/variables/variable.dart';
import 'package:rli_discovery/variables/variable_erli.dart';
import 'package:rli_discovery/variables/variable_pit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: const [],
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
        '/rli': (context) => EDTHome(
              storage: "rli3", questionSet: RLI(), //대조군
            ),
        '/pit': (context) => EDTHome(
              storage: "pit1", questionSet: PIT(), //대조군
            ),
        '/egt1': (context) => EDTHome(
              storage: "egt1", questionSet: EGeneralInventory(), //대조군
            ),
        '/edt1': (context) => EDTHome(
              storage: "edt1", questionSet: EDogmaInventory(), //대조군
            ),
        '/egpt1': (context) => EDTHome(
              storage: "egpt1", questionSet: EPietInventory(), //대조군
            ),
        '/edpt1': (context) => EDTHome(
              storage: "edpt1", questionSet: EDogmaPietInventory(), //대조군
            ),
      },
      home: const Lobbie(),
      /*home: const ResultsPage(),*/
    );
  }
}
