import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/counts.dart';
import 'package:religous_lifetype_inventory/rli_pages/rli_page_result.dart';
import 'package:religous_lifetype_inventory/rli_section/rli_debug_text.dart';
import 'package:religous_lifetype_inventory/rli_section/rli_widget.dart';
import 'package:rli_discovery/variables/variable.dart';

class RLI2SurveyScreen extends StatefulWidget {
  const RLI2SurveyScreen({super.key});

  @override
  State<RLI2SurveyScreen> createState() => _RLI2SurveyScreenState();
}

//R 여기에서부터 작업하면 된데요
class _RLI2SurveyScreenState extends State<RLI2SurveyScreen> {
  bool init = true;
  List<Widget> tiles = [];
  @override
  Widget build(BuildContext context) {
    if (init) {
      return RLIStandardScreenExamples.loadingPage;
    }
    return Scaffold(
      appBar: AppBar(
        title: context.watch<PreferencesRLITestApp>().isDebugging
            ? const TextualVision()
            : const Text("Welcome"),
        actions: [
          IconButton(
              onPressed: () {
                context.read<Answers2>().initAnswer(2);
              },
              icon: const Icon(Icons.settings_backup_restore_sharp)),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RLIResultPage(
                              answerSet: {},
                            )));
              },
              icon: const Icon(Icons.check_circle_outline))
        ],
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return tiles[index];
        },
        itemCount: tiles.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(thickness: 1);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Map<String, List<String>> temp = RLI.rli2;

    Iterator iter = temp.keys.iterator;
    while (iter.moveNext()) {
      String e = iter.current;
      // 문제 타일들 만드는 부분
      for (int i = 0; i < temp[e]!.length; i++) {
        tiles.add(RLIQuestionTile(factor: e, label: temp[e]![i], number: i));
      }
    }

    // seed 값에 따라서 문제들을 셔플하는부분
    tiles.shuffle(Random(context.read<PreferencesRLITestApp>().instance));

    setState(() {
      init = false;
    });
  }
}

class RLIStandardScreenExamples {
  static const Widget loadingPage =
      Scaffold(body: Center(child: CircularProgressIndicator()));
}
