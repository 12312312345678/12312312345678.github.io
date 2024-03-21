import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:religous_lifetype_inventory/counts.dart';
import 'package:rli_discovery/material/result_inveltory.dart';
import 'package:rli_discovery/variables/variable.dart';

class RLIResultPage extends StatefulWidget {
  final Map<String, List<bool>> answerSet;

  const RLIResultPage({super.key, required this.answerSet});

  @override
  State<RLIResultPage> createState() => _RLIResultPageState();
}

class _RLIResultPageState extends State<RLIResultPage> {
  // 평균
  final double generalAAver = 7.26595744680851;
  //표준편차
  final double generalADiap = 8.136044744425611;
  final double dogmaAver = 4.553191489361702;
  final double dogmaDipa = 4.618687805907456;
  //가중치 행렬
  final List<List<double>> weights1 = [
    [
      0.7737604370671146,
      0.6997633834096119,
      0.761169116717197,
      0.8029425448790164,
      0.36998394736534695
    ],
    [
      0.12185057980156536,
      0.4315558648307094,
      0.38410944945986014,
      0.5057423888266303,
      0.3322047990390352
    ],
    [
      0.7132959763100035,
      0.7795896402221634,
      0.11987851095074376,
      0.5433125055681626,
      0.44390159213844904
    ],
    [
      -0.16494192183691597,
      1.6385822513210355,
      -0.17323788210121274,
      -2.9793732400159585,
      0.5229569789671631
    ],
    [
      0.8606872119501223,
      0.8987829569893425,
      0.3204125908666024,
      0.8239741977190512,
      0.0552957448067738
    ],
    [
      0.686300998250071,
      0.5788402973148161,
      0.8589445016903489,
      0.49905449559157544,
      0.6129925220900043
    ]
  ];
  //출력층 가중치 행렬
  final List<List<double>> weights2 = [
    [
      -1.6281246727531002,
      -1.5271479575209472,
      -1.3829651776768388,
      4.631310083716346,
      6.5566685733493175,
      -1.7336878898239902,
      -1.6191328301579881
    ],
    [
      1.8924946977425756,
      1.6162842093739243,
      1.0169927855124221,
      -4.623377483727619,
      -6.552743746900865,
      1.964983133101847,
      1.389753907742767
    ]
  ];
  @override
  Widget build(BuildContext context) {
    Map<String, List<bool>> answers = context.read<Answers2>().getSet;
    MasterSheet sheet = MasterSheet(
        idCode: context.read<PreferencesRLITestApp>().userId,
        uidName: context.read<PreferencesRLITestApp>().userName,
        inventory: answers);
    //enroll에서 업로드 되는 정보는 총 5개
    sheet.enroll(context.read<PreferencesRLITestApp>().storage, additional: {
      "timeStaff": context.read<TimeStaff>().staff,
      "seed": context.read<PreferencesRLITestApp>().seed
    });

    // userId 는 각 시트에 고유 코드
    // userName은 유저 이름
    // storage는 여기에는 안나와있지만 path에 들어가고
    // seed는 문제를 섞을때 사용했던 seed값을 저장한거
    // timeStaff는 어떤 문제를 테스트 시작하고 몇 밀리초 후에 체크했는지 저장한 리스트

    String data = "";
    final score = sheet.generate()!;
    Iterator iter = score.keys.iterator;

    while (iter.moveNext()) {
      String factor = iter.current;
      dynamic temp = score[iter.current];
      data = "$data $factor:$temp ";
    }

    //General 먼저 계산
    //표준점수 등 계산하는 부분
    double zScoreGeneral = (score["General"]! - generalAAver) / generalADiap;
    double zScoreDogma = (score["DogmaStress"]! - dogmaAver) / dogmaDipa;
    //가중치 행렬로 퍼셉트론 계산하는 부분
    List<double> type = calculate([
      score["General"]!,
      score["DogmaStress"]!,
      score["Reactionaries"]!,
      score["Atheismies"]!
    ]);
    double v = (type[0] > type[1]) ? type[0] : type[1];
    String s = (type[0] > type[1]) ? "비기독교 집단" : "기독교 집단";
    final int tipus = (v * 100).ceil();

    return Scaffold(
      appBar: AppBar(
        title: const Text("결과"),
        leading: null,
      ),
      body: Center(
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("결과"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "종합 피로도: ${(50 + zScoreGeneral * 10).ceil()}[${score["General"]}]점"),
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
            child: Text("신앙 피로도 [${score[RLIType.pietia.code]}]문항"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("응답 패턴을 분석하면 $s에 해당될 것으로 유추됩니다. ($tipus)"),
          ),
        ]),
      ),
    );
  }

  List<double> calculate(List<int> sample) {
    List<int> set = [1];
    final int nW1 = weights1.length;
    final int nW2 = weights2.length;
    set.addAll(sample);
    List<double> zsum = [];
    List<double> zeta = [1];
    List<double> osum = [];
    List<double> o = [];

    for (int node = 0; node < nW1; node++) {
      var temp = 0.0;
      for (int element = 0; element < weights1[node].length; element++) {
        temp += set[element] * weights1[node][element];
      }
      zsum.add(temp);
    }
    for (int i = 0; i < zsum.length; i++) {
      zeta.add(tanH(zsum[i]));
    }
    for (int node = 0; node < nW2; node++) {
      var temp = 0.0;
      for (int element = 0; element < weights2[node].length; element++) {
        temp += zeta[element] * weights2[node][element];
      }
      osum.add(temp);
    }
    for (int i = 0; i < osum.length; i++) {
      o.add(tanH(osum[i]));
    }
    return o;
  }

  //tanH 인데 사실 로지스틱 시그모이드
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
