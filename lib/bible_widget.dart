import 'dart:math';

import 'package:flutter/material.dart';

import 'bible.dart';

class BibleTile extends StatelessWidget {
  final Bible bib;

  const BibleTile(this.bib, {super.key});

  @override
  Widget build(BuildContext context) {
    final a = bib.chapter;
    final b = bib.verse;
    return ListTile(
        leading: const Icon(Icons.receipt),
        title: Text("$a/$b"),
        subtitle: Text(bib.label));
  }
}

typedef AnswerTapping = void Function();

/* ****************************************************************************
 * **************성경 문제 위젯 시작
******************************************************************************/
abstract class BibleQuizWidget extends StatelessWidget {
  const BibleQuizWidget({super.key, required this.bible});
  final Bible bible;
}

//같은 책 내 무작위 추출 문제
class RandomBibleQuestionSelective extends BibleQuizWidget {
  const RandomBibleQuestionSelective(
      {super.key, required super.bible, required this.onTap, this.sameChatper});
  final AnswerTapping onTap;
  final bool? sameChatper;

  @override
  Widget build(BuildContext context) {
    List<Bible> output = [];
    Random r = Random();

    if ((sameChatper != null) && (sameChatper!)) {
      output.add(bible);
      for (int i = 0; i < 2; i++) {
        var bType = bible.book;
        var nchap = bible.chapter;
        var nverse = r.nextInt(Bible.bible[bType]![nchap].length);
        output.add(Bible(bType, nchap, nverse));
      }
      output.shuffle();
    } else {
      output.add(bible);
      for (int i = 0; i < 2; i++) {
        var bType = bible.book;
        var bText = Bible.bible[bType];
        var nchap = r.nextInt(bText!.length - 1);
        var nverse = r.nextInt(Bible.bible[bType]![nchap].length);
        output.add(Bible(bType, nchap, nverse));
      }
      output.shuffle();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(bible.label, style: const TextStyle(fontSize: 16.0)),
        ),
        Expanded(child: _view(output))
      ],
    );
  }

  ListView _view(List<Bible> output) {
    return ListView.builder(
        itemCount: output.length,
        itemBuilder: ((context, index) {
          int chap = output[index].chapter;
          var vers = output[index].verse;
          bool isTrue = (chap == bible.chapter) && (vers == bible.verse);

          if (isTrue) {
            return ListTile(
              leading: const Icon(Icons.album),
              title:
                  Text("${output[index].book.name} ${chap + 1}장 ${vers + 1}절"),
              onTap: onTap,
            );
          }

          return ListTile(
            leading: const Icon(Icons.album),
            title: Text("${output[index].book.name} ${chap + 1}장 ${vers + 1}절"),
            onTap: () => _gotoReviewerPage(context, output[index]),
          );
        }));
  }

  void _gotoReviewerPage(BuildContext context, Bible bible) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BibleTextViewerWidget(bible: bible)));
  }
}

class WriteRandomVerseWidget extends StatefulWidget {
  const WriteRandomVerseWidget(
      {super.key,
      required this.bible,
      required this.onPressed,
      required this.isHide});
  final Bible bible;
  final AnswerTapping onPressed;
  final bool isHide;

  @override
  State<WriteRandomVerseWidget> createState() => _WriteRandomVerseWidgetState();
}

class _WriteRandomVerseWidgetState extends State<WriteRandomVerseWidget> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _controller.text = widget.isHide ? "" : widget.bible.label;
    return Center(
        child: Column(children: [
      const SizedBox(height: 10.0),
      Text(
          "${widget.bible.book.name} ${widget.bible.chapter}:${widget.bible.verse}",
          style: const TextStyle(fontSize: 16.0)),
      const SizedBox(height: 10.0),
      TextField(
        controller: _controller,
        maxLines: 3,
      ),
      const SizedBox(height: 10.0),
      ElevatedButton(onPressed: () => _enter(), child: const Text("Enter")),
      const SizedBox(height: 10.0)
    ]));
  }

  void _enter() {
    if (_controller.text == widget.bible.label) {
      _update();
    } else {
      _controller.text = "Wrong! Fear the LORD, you faithless one";
    }
  }

  void _update() {
    widget.onPressed();
  }
}
/* *****************************************************************************
 * **************성경 문제 위젯 종료 ********************************************
*******************************************************************************/

class BibleTextViewerWidget extends StatelessWidget {
  const BibleTextViewerWidget({super.key, required this.bible, this.compact});
  final Bible bible;
  final bool? compact;

  @override
  Widget build(BuildContext context) {
    int startChapter = bible.chapter;
    BookType book = bible.book;
    List<List<String>> text = Bible.bible[book]!;

    return Scaffold(
        appBar: AppBar(
          title: Text("Review ${book.name} ${startChapter + 1}장"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _regbody(text, book, startChapter));
  }

  Widget _regbody(List<List<String>> text, BookType book, int startChapter) {
    if (compact == null) {
      return ListView.builder(
          itemCount: text[startChapter].length,
          itemBuilder: (context, index) {
            if (index == 0) return const Divider();
            return ListTile(
                title: Text("$index. ${text[startChapter][index]}"));
          });
    } else {
      return ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            if (index == 0) return const Divider();
            return ListTile(
                title: Text("${bible.chapter}:${bible.verse}. ${bible.label}"));
          });
    }
  }
}
