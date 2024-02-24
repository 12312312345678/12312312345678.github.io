import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/counts.dart';
import 'package:rli_discovery/pages/super_analyzer.dart';
import 'package:rli_discovery/variables/variable_erli.dart';

class ERLIResult extends StatefulWidget {
  const ERLIResult({super.key});

  @override
  State<ERLIResult> createState() => _ERLIResultState();
}

class _ERLIResultState extends State<ERLIResult> {
  late final ERLISheet _sheet;

  @override
  void initState() {
    super.initState();
    Map<String, List<bool>> inv = context.read<Answers2>().getSet;
    _sheet = ERLISheet(
        idCode: context.read<PreferencesRLITestApp>().userId,
        uidName: context.read<PreferencesRLITestApp>().userName,
        inventory: inv);
    _sheet.enroll(context.read<PreferencesRLITestApp>().storage,
        additional: {"timeStaff": context.read<TimeStaff>().staff});
  }

  @override
  Widget build(BuildContext context) {
    var scoring = _sheet.getScoring();
    List<Widget> outputs = [];
    int totalError = 0;
    double totalBias = 0;
    final int leng = scoring.keys.length;
    for (var factor in scoring.keys) {
      //괴리율
      //basis와 double의 득점차이.
      int error = (scoring[factor]![0] - scoring[factor]![1]).abs();
      totalError += error.abs();
      //오차율
      //basis double과 anti의 득점차이
      double diap = ((scoring[factor]![0] + scoring[factor]![1]) / 2) -
          scoring[factor]![2];
      totalBias += diap.abs();
      outputs.add(Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
        child: Text(
            "요인: ${factor.substring(0, 2)}, 원점수: ${scoring[factor]![0]},${scoring[factor]![1]},${scoring[factor]![2]} 괴리율: $error 오차율: $diap"),
      ));
    }
    return Scaffold(
      appBar: AppBar(
          title: Text(
              "AOError: ${(totalError / leng).ceil()}, AOBias: ${(totalBias / leng).ceil()}")),
      body: Center(
        child: Column(children: outputs),
      ),
    );
  }
}

class ERLISheet extends MasterSheet {
  ERLISheet(
      {required super.idCode,
      required super.uidName,
      required super.inventory});

  ///출력값을 3개로 묶습니다.
  ///
  ///{
  /// 타입: [요소1, 추가요소1, 반요소1] ...
  ///}
  Map<String, List<int>> getScoring() {
    final Map<String, int> score = super.generate()!;
    Map<String, List<int>> outputScore = {};
    for (int i = 0; i < ERLIType.basisTypes.length; i++) {
      List<int> temp = [];
      temp.add(score[ERLIType.basisTypes[i].code]!);
      temp.add(score[ERLIType.doubleTypes[i].code]!);
      temp.add(score[ERLIType.basisAnties[i].code]!);
      outputScore.addAll({ERLIType.basisTypes[i].code: temp});
    }
    return outputScore;
  }
}
