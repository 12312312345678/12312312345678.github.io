import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/counts.dart';
import 'package:religous_lifetype_inventory/database_controller/firecontrol.dart';
import 'package:religous_lifetype_inventory/rli_section/rli_vars.dart';

class RLIResultPage extends StatefulWidget {
  final Map<String, List<bool>> answerSet;

  const RLIResultPage({super.key, required this.answerSet});

  @override
  State<RLIResultPage> createState() => _RLIResultPageState();
}

class _RLIResultPageState extends State<RLIResultPage> {
  final double generalAAver = 평균;
  final double generalADiap = 표준편차;
  final double dogmaAver = 평균;
  final double dogmaDipa = 표준편차;
  final List<List<double>> weights1 = [
    ???
  ];
  final List<List<double>> weights2 = [
    ???
  ];
  @override
  Widget build(BuildContext context) {
    Map<String, List<bool>> answers = context.read<Answers2>().getSet;
    Iterator iter = answers.keys.iterator;
    Map score = {};
    while (iter.moveNext()) {
      int temp = 0;
      final List<bool> data = answers[iter.current]!;
      final String factor = iter.current;
      for (int i = 0; i < data.length; i++) {
        if (data[i]) {
          temp++;
        }
      }
      score.addAll({factor: temp});
    }
    score = scoringProcedureRules(answers, score);
    String data = "";
    iter = score.keys.iterator;
    ???().addResult(context: context, results: jsonEncode(score));
    while (iter.moveNext()) {
      String factor = iter.current;
      dynamic temp = score[iter.current];
      data = "$data $factor:$temp ";
    }

    //General 먼저 계산
    double zScoreGeneral = (score["General"] - generalAAver) / generalADiap;
    double zScoreDogma = (score["DogmaStress"] - dogmaAver) / dogmaDipa;
    List<double> type = calculate([
      score["General"],
      score["DogmaStress"],
      score["Reactionaries"],
      score["Atheismies"]
    ]);
    double v = (type[0] > type[1]) ? type[0] : type[1];
    String s = (type[0] > type[1]) ? "비기독교 집단" : "기독교 집단";
    final int tipus = (v * 100).ceil();

    return Scaffold(
      appBar: AppBar(title: const Text("결과")),
      body: Center(
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("결과"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "신앙 피로도: ${(50 + zScoreGeneral * 10).ceil()}[${score["General"]}]점"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "교의 피로도 ${(50 + zScoreDogma * 10).ceil()}[${score["DogmaStress"]}]점"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("반현실주의 경향 [${score["Reactionaries"]}]문항"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("회의주의 경향 [${score["Atheismies"]}]문항"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("응답 패턴을 분석하면 $s에 해당될 확률이 $tipus만큼 가깝습니다."),
          ),
        ]),
      ),
    );
  }

  Map scoringProcedureRules(Map answers, Map score) {
    int temp = 0;
    final List<QuestionPair> rules = [
      QuestionPair(answers,
          factor: "antiGeneral",
          number: 0,
          targetFactor: "General",
          targetNumber: 11),
      QuestionPair(answers,
          factor: "antiGeneral",
          number: 1,
          targetFactor: "General",
          targetNumber: 11),
      QuestionPair(answers,
          factor: "antiGeneral",
          number: 1,
          targetFactor: "General",
          targetNumber: 1),
      QuestionPair(answers,
          factor: "antiGeneral",
          number: 2,
          targetFactor: "General",
          targetNumber: 3),
      QuestionPair(answers,
          factor: "antiGeneral",
          number: 3,
          targetFactor: "General",
          targetNumber: 4),
      QuestionPair(answers,
          factor: "antiGeneral",
          number: 4,
          targetFactor: "General",
          targetNumber: 0),
      QuestionPair(answers,
          factor: "antiGeneral",
          number: 5,
          targetFactor: "General",
          targetNumber: 2),
      QuestionPair(answers,
          factor: "antiGeneral",
          number: 5,
          targetFactor: "General",
          targetNumber: 12),
      QuestionPair(answers,
          factor: "antiGeneral",
          number: 6,
          targetFactor: "General",
          targetNumber: 6),
      QuestionPair(answers,
          factor: "antiGeneral",
          number: 7,
          targetFactor: "General",
          targetNumber: 17),
      QuestionPair(answers,
          factor: "antiGeneral",
          number: 8,
          targetFactor: "General",
          targetNumber: 2),
      QuestionPair(answers,
          factor: "antiGeneral",
          number: 8,
          targetFactor: "General",
          targetNumber: 15),
      QuestionPair(answers,
          factor: "antiGeneral",
          number: 8,
          targetFactor: "General",
          targetNumber: 25),
      QuestionPair(answers,
          factor: "antiGeneral",
          number: 8,
          targetFactor: "General",
          targetNumber: 33),
      QuestionPair(answers,
          factor: "antiGeneral",
          number: 10,
          targetFactor: "General",
          targetNumber: 18),
      QuestionPair(answers,
          factor: "antiDogmaStress",
          number: 0,
          targetFactor: "Reactionaries",
          targetNumber: 3),
      QuestionPair(answers,
          factor: "antiDogmaStress",
          number: 1,
          targetFactor: "DogmaStress",
          targetNumber: 5),
      QuestionPair(answers,
          factor: "antiDogmaStress",
          number: 2,
          targetFactor: "DogmaStress",
          targetNumber: 7),
      QuestionPair(answers,
          factor: "antiDogmaStress",
          number: 3,
          targetFactor: "DogmaStress",
          targetNumber: 11),
      QuestionPair(answers,
          factor: "antiDogmaStress",
          number: 4,
          targetFactor: "DogmaStress",
          targetNumber: 3),
      QuestionPair(answers,
          factor: "antiDogmaStress",
          number: 0,
          targetFactor: "DogmaStress",
          targetNumber: 19),
    ];
    for (int i = 0; i < rules.length; i++) {
      if (rules[i].compare()) {
        temp++;
      }
    }
    score.addAll({"Paradoxial": temp});
    return score;
  }

  List<double> calculate(List<int> sample) {
    ???
  }

  double tanH(double x) {
    return (1 / (1 + exp(-x))); //
  }
}

class QuestionPair {
  final Map answers;
  final String factor;
  final int number;
  final String targetFactor;
  final int targetNumber;

  QuestionPair(this.answers,
      {required this.factor,
      required this.number,
      required this.targetFactor,
      required this.targetNumber});

  bool compare() {
    if ((answers[factor] == null) || (answers[targetFactor] == null)) {
      throw Exception("Factor is null!");
    }
    if (answers[factor]!.length <= number) {
      throw Exception(
          "Throwed Exception while comparing factor:$factor, ${answers[factor]!.length} it requires $number");
    }
    if (answers[targetFactor]!.length <= targetNumber) {
      throw Exception(
          "Throwed Exception while comparing with factor:$factor, ${answers[targetFactor]!.length} it requires $targetNumber");
    }
    debugPrint(
        "Comparing ($factor,$number) \"${RLI.rli2[factor]![number]}\" with ($targetFactor,$targetNumber) \"${RLI.rli2[targetFactor]![targetNumber]}\"");
    if (answers[factor]![number] == answers[targetFactor]![targetNumber]) {
      return true;
    } else {
      return false;
    }
  }
}
