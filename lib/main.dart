import 'dart:math';

import 'package:flutter/material.dart';
import 'bible.dart';
import 'bible_widget.dart';

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
      home: const Screen1(),
    );
  }
}

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("모두 같이 하는 성경공부")),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _buttonReading(context),
              child: const Text("성경 읽기"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () => _buttonQuiz(context),
                child: const Text("성경 퀴즈")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () => _buttonWrite(context),
                child: const Text("성경 쓰기")),
          )
        ]),
      ),
    );
  }

  void _buttonReading(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ScreenChoose()));
  }

  void _buttonQuiz(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ScreenQuizChoose()));
  }

  void _buttonWrite(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ScreenWrite()));
  }
}

class ScreenReading extends StatefulWidget {
  const ScreenReading({super.key, required this.type});
  final BookType type;

  @override
  State<ScreenReading> createState() => _ScreenReadingState();
}

class _ScreenReadingState extends State<ScreenReading> {
  int page = 0;
  bool isMenu = true;

  @override
  Widget build(BuildContext context) {
    if (isMenu) {
      return _menuPage(context);
    }
    return _readingPage(context);
  }

  void _gotoHome(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ScreenChoose()));
  }

  Widget _menuPage(BuildContext context) {
    final List<List<String>> text = Bible.bible[widget.type]!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type.name),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => _gotoHome(context),
        ),
      ),
      body: ListView.builder(
          itemCount: Bible.bible[widget.type]!.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.bookmark_border),
              title: Text(text[index][1]),
              subtitle: Text("${index + 1}"),
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

  Widget _readingPage(BuildContext context) {
    final List<List<String>> text = Bible.bible[widget.type]!;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.type.name} ${page + 1}"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            setState(() {
              page = 0;
              isMenu = true;
            });
          },
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => _sameChapterQuizPage(context))),
              icon: const Icon(Icons.document_scanner)),
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

  StatefulBuilder _sameChapterQuizPage(BuildContext context) {
    late Bible bib;
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        Random r = Random();
        var v = r.nextInt(Bible.bible[widget.type]![page].length);
        bib = Bible(widget.type, page, v);
        return _sameChapterQuizPageWidget(context, bib, () {
          var v = r.nextInt(Bible.bible[widget.type]![page].length);
          setState(() {
            bib = Bible(BookType.psalms, page, v);
          });
        });
      },
    );
  }

  Widget _sameChapterQuizPageWidget(
      BuildContext context, Bible bible, AnswerTapping onTap) {
    //BookType type = bible.book;
    return Scaffold(
      appBar: AppBar(
        title: const Text("성경 암기용"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
          child: RandomBibleQuestionSelective(
              sameChatper: true,
              bible: bible,
              onTap:
                  onTap /*{
          Random r = Random();
          late int newverse;
          newverse =
              r.nextInt(Bible.bible[type]![bible.chapter].length - 1) + 1;
          setState(() {
            bible = Bible(type, bible.chapter, newverse);
          });
        },*/
              )),
    );
  }
}

class ScreenChoose extends StatelessWidget {
  const ScreenChoose({super.key});

  @override
  Widget build(BuildContext context) {
    Iterable iter = Bible.bible.keys;
    return Scaffold(
      appBar: AppBar(
        title: const Text("성경 읽기"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Screen1()));
          },
        ),
      ),
      body: ListView.builder(
          itemCount: iter.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text((iter.elementAt(index) as BookType).name),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScreenReading(
                            type: (iter.elementAt(index) as BookType))));
              },
            );
          }),
    );
  }
}

class ScreenQuizChoose extends StatelessWidget {
  const ScreenQuizChoose({super.key});

  @override
  Widget build(BuildContext context) {
    Iterable iter = Bible.bible.keys;
    return Scaffold(
      appBar: AppBar(
        title: const Text("성경 시험"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Screen1()));
          },
        ),
      ),
      body: ListView.builder(
          itemCount: iter.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text((iter.elementAt(index) as BookType).name),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScreenQuiz(
                              type: (iter.elementAt(index) as BookType),
                            )));
              },
            );
          }),
    );
  }
}

class SameChapterReading extends StatefulWidget {
  final BookType type;

  const SameChapterReading({
    super.key,
    required this.type,
  });

  @override
  State<SameChapterReading> createState() => _SameChapterReadingState();
}

class _SameChapterReadingState extends State<SameChapterReading> {
  int page = 0;
  @override
  Widget build(BuildContext context) {
    //Navigator.push(context, MaterialPage(child: StatefulWidgetBuilder))
    Bible bible = Bible(BookType.psalms, page, 1);
    return Scaffold(
      appBar: AppBar(
        title: const Text("성경 암기용"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
          child: RandomBibleQuestionSelective(
        sameChatper: true,
        bible: bible,
        onTap: () {
          Random r = Random();
          late int newverse;
          newverse =
              r.nextInt(Bible.bible[widget.type]![bible.chapter].length - 1) +
                  1;
          setState(() {
            bible = Bible(widget.type, bible.chapter, newverse);
          });
        },
      )),
    );
  }
}

class ScreenQuiz extends StatefulWidget {
  const ScreenQuiz({super.key, required this.type});
  final BookType type;

  @override
  State<ScreenQuiz> createState() => _ScreenQuizState();
}

class _ScreenQuizState extends State<ScreenQuiz> {
  late Bible bible = Bible(widget.type, 0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("성경 암기용"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => _exit(context),
        ),
        actions: [
          IconButton(
              onPressed: () => _review(context),
              icon: const Icon(Icons.book_outlined)),
        ],
      ),
      body: Center(
          child: RandomBibleQuestionSelective(
        bible: bible,
        onTap: () {
          Random r = Random();
          late int newchap, newverse;
          newchap = r.nextInt(Bible.bible[widget.type]!.length);
          newverse = r.nextInt(Bible.bible[widget.type]![newchap].length);
          setState(() {
            bible = Bible(widget.type, newchap, newverse);
          });
        },
      )),
    );
  }

  void _exit(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Screen1()));
  }

  void _review(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BibleTextViewerWidget(
                  bible: bible,
                )));
  }
}

class ScreenWrite extends StatefulWidget {
  const ScreenWrite({super.key});

  @override
  State<ScreenWrite> createState() => _ScreenWriteState();
}

class _ScreenWriteState extends State<ScreenWrite> {
  BookType type = BookType.psalms;
  late Bible bible = Bible(type, 2, 4);
  bool isHide = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("복 있는 사람은 오직 여호와의 율법만 주야로 묵상하는도다"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
                onPressed: () => _hide(), icon: const Icon(Icons.hide_source)),
            IconButton(
                onPressed: () => _review(context),
                icon: const Icon(Icons.book_outlined))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: WriteRandomVerseWidget(
            bible: bible,
            onPressed: () => _update(),
            isHide: isHide,
          ),
        ));
  }

  void _update() {
    setState(() {
      bible = _new();
    });
  }

  void _hide() {
    setState(() {
      if (isHide) {
        isHide = false;
      } else {
        isHide = true;
      }
    });
  }

  void _review(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BibleTextViewerWidget(
                  bible: bible,
                  compact: true,
                )));
  }

  Bible _new() {
    Random r = Random();
    var nChap = r.nextInt(Bible.bible[type]!.length - 1) + 1;
    var nVers = r.nextInt(Bible.bible[type]![nChap].length - 1) + 1;
    Bible newBible = Bible(type, nChap, nVers);

    return newBible;
  }
}
