import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:religous_lifetype_inventory/database_controller/firecontrol.dart';
import 'package:religous_lifetype_inventory/firebase_options.dart';
import 'package:religous_lifetype_inventory/rli_pages/rli_pages.dart';
import 'package:religous_lifetype_inventory/rli_section/rli_vars.dart';
import 'package:religous_lifetype_inventory/rli_section/rli_widget.dart';

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
      ChangeNotifierProvider(create: (_) => PreferencesRLITestApp())
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
      home: HomePageScreen(),
      /*home: const ResultsPage(),*/
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text("대충 검사 (apk version 0.1.0)"),
            ElevatedButton(
                onPressed: () {
                  List<RLITile> inv = [];
                  List<String> delights = RLI.rli[1]!;
                  List<String> nonDelights = RLI.rli[-1]!;
                  List<String> situations = RLI.rli[2]!;
                  List<String> nonSituation = RLI.rli[-2]!;
                  List<String> heresiality = RLI.rli[3]!;
                  List<String> nonHeresiality = RLI.rli[-3]!;
                  List<String> religousibillity = RLI.rli[4]!;
                  List<String> nonReligousibillity = RLI.rli[-4]!;

                  //문제 셔플링. D, S, nD, nS 따로 H R P 따로
                  List<RLITile> subListGeneral = [];
                  Iterator<String> id = delights.iterator;
                  int v = -1;
                  while (id.moveNext()) {
                    v++;
                    subListGeneral.add(RLITile(
                      factor: 1,
                      label: id.current,
                      number: v,
                    ));
                    context.read<Answers>().addAnswer(1);
                  }
                  v = -1;
                  Iterator<String> ind = nonDelights.iterator;
                  while (ind.moveNext()) {
                    v++;
                    subListGeneral.add(RLITile(
                      factor: -1,
                      label: ind.current,
                      number: v,
                    ));
                    context.read<Answers>().addAnswer(-1);
                  }
                  v = -1;

                  Iterator<String> temp = situations.iterator;
                  while (temp.moveNext()) {
                    v++;
                    subListGeneral.add(RLITile(
                      factor: 2,
                      label: temp.current,
                      number: v,
                    ));
                    context.read<Answers>().addAnswer(2);
                  }
                  v = -1;
                  Iterator<String> ins = nonSituation.iterator;
                  while (ins.moveNext()) {
                    v++;
                    subListGeneral.add(RLITile(
                      factor: -2,
                      label: ins.current,
                      number: v,
                    ));
                    context.read<Answers>().addAnswer(-2);
                  }
                  v = -1;
                  subListGeneral.shuffle();
                  inv.addAll(subListGeneral);

                  List<RLITile> subListDogmaticStress = [];
                  Iterator<String> ih = heresiality.iterator;
                  while (ih.moveNext()) {
                    v++;
                    subListDogmaticStress.add(RLITile(
                      factor: 3,
                      label: ih.current,
                      number: v,
                    ));
                    context.read<Answers>().addAnswer(3);
                  }
                  v = -1;
                  Iterator<String> inh = nonHeresiality.iterator;
                  while (inh.moveNext()) {
                    v++;
                    subListDogmaticStress.add(RLITile(
                      factor: -3,
                      label: inh.current,
                      number: v,
                    ));
                    context.read<Answers>().addAnswer(-3);
                  }
                  v = -1;
                  Iterator<String> ir = religousibillity.iterator;
                  while (ir.moveNext()) {
                    v++;
                    subListDogmaticStress.add(RLITile(
                      factor: 4,
                      label: ir.current,
                      number: v,
                    ));
                    context.read<Answers>().addAnswer(4);
                  }
                  v = -1;
                  Iterator<String> inr = nonReligousibillity.iterator;
                  while (inr.moveNext()) {
                    v++;
                    subListDogmaticStress.add(RLITile(
                      factor: -4,
                      label: inr.current,
                      number: v,
                    ));
                    context.read<Answers>().addAnswer(-4);
                  }
                  subListDogmaticStress.shuffle();
                  inv.addAll(subListDogmaticStress);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RLIListWidget(
                            inv: inv,
                          )));
                },
                child: const Text("시작"))
          ],
        ),
      ),
    );
  }
}
