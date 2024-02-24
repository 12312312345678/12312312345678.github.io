import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/erli_pages/erli_homepage.dart';
import 'package:religous_lifetype_inventory/firebase_options.dart';
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
        '/main': (context) => const MainPage(),
        '/rli': (context) => const RLIHomePageScreen(
              storage: "rli3",
            ),
        '/pit': (context) => const PITHome(storage: "pit1"),
        '/erli': (context) => const ERLIHome(
              storage: "erli1",
            ),
      },
      home: const MainPage(),
      /*home: const ResultsPage(),*/
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController control = TextEditingController(text: "cutie");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main page")),
      body: Center(
        child: Column(children: [
          const Text("RLI, 종교 특징 검사"),
          const SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/rli");
              },
              child: const Text("검사하러가기")),
          const SizedBox(
            height: 10.0,
          ),
          const Text("PIT, 종교 가치관 검사"),
          const SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/pit");
              },
              child: const Text("검사하러가기")),
          const SizedBox(
            height: 10.0,
          ),
          const Text("ERLI, 심층 종교 가치관 검사"),
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Warning"),
                        content: const Text(
                            "심층 검사는 소요 시간이 2시간 이상 소요될 수 있습니다. 검사에 참여하더라도 검사 결과를 바로 받을 수 없을 수 있습니다. 제작자에게 문의하세요."),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pushNamed(context, "/erli");
                              },
                              child: const Text("시작")),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                //Navigator.pushNamed(context, "/erli");
                              },
                              child: const Text("닫기")),
                        ],
                      );
                    });
              },
              child: const Text("검사하러가기")),
        ]),
      ),
    );
  }
}
