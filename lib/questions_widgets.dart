import 'dart:math';

import 'package:flutter/material.dart';
import 'package:psalm_reminder/questions.dart';

typedef AnswerTapping = void Function();

class BibleQuestionWidget extends StatefulWidget {
  const BibleQuestionWidget({super.key, required this.book, required this.current, required this.tap});
  final String book;
  final List<int> current;
  final AnswerTapping tap;

  @override
  State<BibleQuestionWidget> createState() => _BibleQuestionWidgetState();
}

class _BibleQuestionWidgetState extends State<BibleQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(Bible.bible[widget.book]![widget.current[0]][widget.current[1]]),
        Expanded(
            child: RandomBibleQuestionSelectionWidget(
          book: widget.book,
          currect: widget.current,
          onTap: widget.tap,
        ))
      ],
    );
  }
}

class RandomBibleQuestionSelectionWidget extends StatelessWidget {
  const RandomBibleQuestionSelectionWidget({super.key, required this.currect, required this.book, required this.onTap});
  final String book;
  final List<int> currect; //정답 장절 [1:5] 1장 5절
  final AnswerTapping onTap;
  @override
  Widget build(BuildContext context) {
    if (currect[0] > Bible.bible[book]!.length) {}
    List<Bible> output = [];
    Random r = Random();

    output.add(Bible(book, currect[0], currect[1]));
    for (int i = 0; i < 4; i++) {
      var chap = r.nextInt((Bible.bible[book] as List<dynamic>).length - 1) + 1;
      output.add(Bible(book, chap, r.nextInt(Bible.bible[book]![chap].length - 1) + 1));
    }
    output.shuffle();

    return ListView.builder(
        itemCount: output.length,
        itemBuilder: ((context, index) {
          var chap = output[index].chapter;
          var vers = output[index].verse;
          if (chap * vers == currect[0] * currect[1]) {
            return ListTile(
              leading: const Icon(Icons.album),
              title: Text(output[index].label),
              subtitle: Text("시편 $chap장 $vers절"),
              onTap: onTap,
            );
          }
          return ListTile(
            leading: const Icon(Icons.album),
            title: Text(output[index].label),
            subtitle: Text("시편 $chap장 $vers절"),
          );
        }));
  }
}
