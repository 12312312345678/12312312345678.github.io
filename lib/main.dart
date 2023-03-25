import 'dart:math';

import 'package:flutter/material.dart';
import 'package:psalm_reminder/questions.dart';
import 'package:psalm_reminder/questions_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

/*
 * 매인페이지
 * 시편 읽기 페이지
 * 장절 맞추기 퀴즈(무한생성)
*/

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("모두 같이 하는 성경공부")),
      body: Center(
        child: Column(children: [
          ElevatedButton(onPressed: () => _buttonReading(context), child: const Text("성경 읽기")),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
              },
              child: const Text("성경 퀴즈"))
        ]),
      ),
    );
  }

  void _buttonReading(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ReadingPage(
                  book: 'Psalms',
                )));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> verse = [2, 4];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("성경 암기용"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
      ),
      body: Center(
          child: BibleQuestionWidget(
        book: "Psalms",
        current: verse,
        tap: () {
          Random r = Random();
          late int newchap, newverse;
          newchap = r.nextInt(Bible.bible["Psalms"]!.length - 1) + 1;
          newverse = r.nextInt(Bible.bible["Psalms"]![newchap].length - 1) + 1;
          setState(() {
            verse = [newchap, newverse];
          });
        },
      )),
    );
  }
}

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key, required this.book});
  final String book;

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  bool isMenu = true;

  int page = 0;

  /*
   * 화면 구성은 리스트뷰로 절 단위로 띄워놓는 것. 
   * 절당 앞쪽에 '1.' 이런 표시 있어서 몇 절인지 볼 수 있음
   * 우측 상단에는 메뉴로 돌아가기, 다음 절, 이전 절로 갈 수 있는 아이콘 버튼을 띄워야 함
  */
  @override
  Widget build(BuildContext context) {
    List<List<String>> text = Bible.bible[widget.book]!;
    if (isMenu) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.book),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
        ),
        body: ListView.builder(
            itemCount: text.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.bookmark_border),
                title: Text(text[index][1]),
                subtitle: Text("$index장"),
                onTap: () {
                  setState(() {
                    page = index;
                    isMenu = false;
                  });
                },
              );
            }),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.book} $page"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (page == 1) return;
                setState(() {
                  page--;
                });
              },
              icon: const Icon(Icons.arrow_back_sharp)),
          IconButton(
              onPressed: () {
                setState(() {
                  page = 0;
                  isMenu = true;
                });
              },
              icon: const Icon(Icons.menu)),
          IconButton(
              onPressed: () {
                if (page == text.length - 1) return;
                setState(() {
                  page++;
                });
              },
              icon: const Icon(Icons.arrow_forward_sharp)),
        ],
      ),
      body: ListView.builder(
          itemCount: text[page].length,
          itemBuilder: (context, index) {
            if (index == 0) return const Divider();
            return ListTile(title: Text("$index. ${text[page][index]}"));
          }),
    );
  }
}
